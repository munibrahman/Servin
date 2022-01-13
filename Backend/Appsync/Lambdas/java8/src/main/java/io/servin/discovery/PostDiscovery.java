package io.servin.discovery;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Map;
import java.util.Objects;
import java.util.Random;
import java.util.Vector;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.text.RandomStringGenerator;
import org.apache.commons.text.RandomStringGenerator.Builder;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.amazonaws.HttpMethod;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.geo.GeoDataManager;
import com.amazonaws.geo.GeoDataManagerConfiguration;
import com.amazonaws.geo.model.GeoPoint;
import com.amazonaws.geo.model.PutPointRequest;
import com.amazonaws.geo.model.PutPointResult;
import com.amazonaws.geo.model.QueryRectangleRequest;
import com.amazonaws.geo.model.QueryRectangleResult;
import com.amazonaws.geo.s2.internal.S2Manager;
import com.amazonaws.geo.util.GeoTableUtil;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.model.AttributeDefinition;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.CreateTableRequest;
import com.amazonaws.services.dynamodbv2.model.CreateTableResult;
import com.amazonaws.services.dynamodbv2.model.GlobalSecondaryIndex;
import com.amazonaws.services.dynamodbv2.model.KeySchemaElement;
import com.amazonaws.services.dynamodbv2.model.KeyType;
import com.amazonaws.services.dynamodbv2.model.Projection;
import com.amazonaws.services.dynamodbv2.model.ProjectionType;
import com.amazonaws.services.dynamodbv2.model.ProvisionedThroughput;
import com.amazonaws.services.dynamodbv2.model.PutItemRequest;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.amazonaws.services.s3.event.S3EventNotification.S3BucketEntity;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.google.common.hash.Hashing;


/*
This function is used to post a discovery on the Servin Network.
Since we are using AMAZON_COGNITO_USER_POOLS as the Authorizer, the incoming Event object will look like:

{
    "field": "postDiscovery",
    "identity": {
        "sub": "87bff53e-9278-41d0-9a20-6ab9720eab93",
        "sourceIp": [
            "70.72.212.132"
        ],
        "claims": {
            "sub": "87bff53e-9278-41d0-9a20-6ab9720eab93",
            "email_verified": true,
            "iss": "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_HLB3L7FFI",
            "cognito:username": "87bff53e-9278-41d0-9a20-6ab9720eab93",
            "given_name": "Munib",
            "aud": "66qoh6uj5lofubho6vpb21nbrc",
            "event_id": "17ae211c-64d5-11e9-acf8-2b50d219a65d",
            "token_use": "id",
            "auth_time": 1555920200,
            "exp": 1555983819,
            "iat": 1555980219,
            "family_name": "Rahman",
            "email": "munibrhmn@gmail.com"
        },
        "groups": null,
        "defaultAuthStrategy": "ALLOW",
        "issuer": "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_HLB3L7FFI",
        "username": "87bff53e-9278-41d0-9a20-6ab9720eab93"
    },
    "arguments": {
        "price": 10,
        "description": "testing this discovery",
        "title": "testing",
        "request_or_offer": "request",
        "lat": 43.37569571143301,
        "long": -122.69613794982433
    }
}

For more information, please visit: https://docs.aws.amazon.com/appsync/latest/devguide/resolver-context-reference.html#aws-appsync-resolver-context-reference-identity

NOTE: If there is need to change the event object, you can do so in the related appsync resolver.
*/

// TODO: Clean this entire function up, remove the hard coded secret and access keys, and return a proper json object with an optional error field.

public class PostDiscovery implements RequestStreamHandler {
    static LambdaLogger logger;
    GeoDataManager geoIndexManager;
    GeoDataManagerConfiguration config;
    
    static final double BOUND_BOX_SEARCH_SIZE_MAX = 0.5;                            // Approximate width of Calgary
    
    static final int PRICE_LOWER_LIMIT = 1;
    static final int PRICE_UPPER_LIMIT = 1000;
    
    static final double LAT_LOWER_LIMIT   = -90;
    static final double LAT_UPPPER_LIMIT  = 90;
    static final double LONG_LOWER_LIMIT  = -180;
    static final double LONG_UPPPER_LIMIT = 180;
    
    static final int TITLE_MIN_LENGTH = 1;
    static final int TITLE_MAX_LENGTH = 250;
    
    static final int DESCRIPTION_MIN_LENGTH = 1;        // at least 1 since DynamoDB does not store empty string
    static final int DESCRIPTION_MAX_LENGTH = 2500;
    
    static final int numberOfImagesPerDiscovery = 6;
    
    
    @Override
    public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context) throws IOException {
        //createTable(context);
        setup(context);
        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        JSONObject response = new JSONObject();
        JSONObject responseBody = new JSONObject();
        JSONParser parser = new JSONParser();
        logger.log("STAGE: " + System.getenv("STAGE"));
        logger.log("S3BucketName: " + System.getenv("S3BucketName"));
        logger.log("S3ObjectDirectory: " + System.getenv("S3ObjectDirectory"));
        logger.log("numberOfImagesPerDiscovery: " + System.getenv("numberOfImagesPerDiscovery"));
        
        try {
            JSONObject event = (JSONObject)parser.parse(reader);
            logger.log("The event is: " + event.toJSONString());

            JSONObject identity = (JSONObject) event.get("identity");
            logger.log("Identity is " + identity.toString());

            JSONObject claims = (JSONObject) identity.get("claims");
            logger.log("Claims " + claims.toString());

            JSONObject arguments = (JSONObject) event.get("arguments");
            logger.log("Arguments are " + arguments.toString());
            //JSONObject claims = ((JSONObject) event.get("requestContext"))).get("authorizer");

            String GIVEN_NAME = claims.get("given_name").toString();
            String FAMILY_NAME = claims.get("family_name").toString();
            String USERNAME = identity.get("sub").toString();

            logger.log("username is " + USERNAME);

            String TIME = "" +  System.currentTimeMillis() / 1000;
            logger.log("Time is " + TIME);

            /*
             * POSTING DISCOVERY:
             *  Extraction: Title, Description, Request/Offer, Price, Latitude, Longitude
             *  E(anArrtibute) -> attribute anAttribute meets the existence condition
             *  V(anArrtibute) -> attribute anAttribute meets the validity condition
             *  Process: 
             *      1. Check for existence (The value exist)
             *          a. For strings check length if null then exception is thrown
             *          b. For enumeration (reqORoff) checking if element ensures existence
             *          c. Numbers can be parsed (if parsed then they exist- i.e. not null)
             *      2. Check for validity (The value is valid)
             *          a. 1 <= length of title <= 250
             *          b. 1 <= length of description <= 2500
             *          c. reqORoff is an element of {request, offer}
             *          d. Price is an integer (Price is an element of Z), 0 <= Price (Price has bottom limit), Price <= 1000 (Price has an upper limit)
             *          e. -90 <= latitude <= 90
             *          f. -180 <= longitude <= 180
             * */
            logger.log("Starting to parse");
            String titleV       = arguments.get("title").toString();
            String descriptionV = arguments.get("description").toString();
            String reqORoffV    = arguments.get("request_or_offer").toString();
            
            /* Ensures existence of price, latitude and longitude */
            int    priceV       = Integer.parseInt(arguments.get("price").toString());           // E(price)
            double latitudeV    = Double.parseDouble((arguments.get("lat").toString()));         // E(lat)
            double longitudeV   = Double.parseDouble(arguments.get("long").toString());          // E(long)
            logger.log("Checking for validation");
            /* Ensures validity of price, latitude and longitude */
            if(     PRICE_LOWER_LIMIT <= priceV && priceV <= PRICE_UPPER_LIMIT &&                                           // V(price)
                    LAT_LOWER_LIMIT <= latitudeV && latitudeV <= LAT_UPPPER_LIMIT &&                                        // V(lat)
                    LONG_LOWER_LIMIT <= longitudeV && longitudeV <= LONG_UPPPER_LIMIT &&                                    // V(long)
                    TITLE_MIN_LENGTH <= titleV.length() && titleV.length() <= TITLE_MAX_LENGTH &&                           // V(title) and E(title)
                    DESCRIPTION_MIN_LENGTH <= descriptionV.length() && descriptionV.length() <= DESCRIPTION_MAX_LENGTH &&   // V(description) and E(description)
                    ( Objects.equals(reqORoffV, "request") || Objects.equals(reqORoffV, "offer") )                          // V(reqORoff) and E(reqORoff)
            ) {                 // all attributes have existence and validity
                logger.log("Validation is complete");
                // create a GeoPoint
                GeoPoint geoPoint = new GeoPoint(latitudeV, longitudeV);
                
                // generate (SHA-2) SHA-256 hash
                String sha256hex = Hashing.sha256().hashString(Long.toString(System.currentTimeMillis()) + Double.toString(Math.random()) + arguments.toJSONString(), StandardCharsets.UTF_8).toString();
                
                // create Geo-Library hash key and range key
                //String geoHashKey = Long.toString( S2Manager.generateHashKey(S2Manager.generateGeohash(geoPoint), config.getHashKeyLength()) );
                String geoRangeKey = sha256hex;
                logger.log("Creating attributes");
                // initialize discovery
                AttributeValue rangeKeyValue = new AttributeValue().withS(geoRangeKey);
                PutPointRequest putPointRequest = new PutPointRequest(geoPoint, rangeKeyValue);
                
                // get discovery fields
                AttributeValue title = new AttributeValue().withS(titleV);
                AttributeValue description = new AttributeValue().withS(descriptionV);
                AttributeValue price = new AttributeValue().withN(Integer.toString(priceV));
                AttributeValue reqORoff = new AttributeValue().withS(reqORoffV);
                AttributeValue active = new AttributeValue().withBOOL(true);
                AttributeValue time = new AttributeValue().withN(TIME);
                AttributeValue username = new AttributeValue().withS(USERNAME);
                AttributeValue latitude = new AttributeValue().withN(Double.toString(latitudeV));
                AttributeValue longitude = new AttributeValue().withN(Double.toString(longitudeV));
                
                // generate discovery tags field with first and last name of user and univeristy name
                Vector<String> tagsV = new Vector<String>();
                tagsV.add(GIVEN_NAME);
//                There is no need to add the given or family name for now, if there is need to add them then come back here and add them.
                if (!Objects.equals(GIVEN_NAME, FAMILY_NAME)) {
                    tagsV.add(FAMILY_NAME);
				}

                AttributeValue tags = new AttributeValue().withSS(tagsV);
                logger.log("Adding entries");
                // append discovery fields
                PutItemRequest putItemRequest = putPointRequest.getPutItemRequest();
                putItemRequest.addItemEntry("title", title)
                .addItemEntry("description", description)
                .addItemEntry("price", price)
                .addItemEntry("request_or_offer", reqORoff)
                .addItemEntry("active", active)
                .addItemEntry("tags", tags)
                .addItemEntry("time", time)
                .addItemEntry("cognitoUserName", username)
                .addItemEntry("latitude", latitude)
                .addItemEntry("longitude", longitude);

                
                RandomStringGenerator generator = new RandomStringGenerator.Builder().build();
                for (int i = 0; i < numberOfImagesPerDiscovery; i++) {      // add an entry of NULL to each image                       
                    // create metadata for image object
                    JSONObject metadata = new JSONObject();
                    metadata.put("discovery_id", geoRangeKey);
                    metadata.put("geohash_prefix", Long.toString( S2Manager.generateHashKey(S2Manager.generateGeohash(geoPoint), config.getHashKeyLength())));
                    metadata.put("image_number", Integer.toString(i));
                    metadata.put("type", "discovery");
                    //metadata.put("content-type", "image/jpeg");
                    
                    // generate salt for image hash
                    String salt = generator.generate(10, 20);
                    String imageHash = Hashing.sha256().hashString(Long.toString(System.currentTimeMillis()) + arguments.toJSONString() + salt, StandardCharsets.UTF_8).toString();
                    
                    // issue S3 bucket Presigned URLs
                    String imageObjectKey = System.getenv("S3ObjectDirectory") + imageHash + ".jpg";
//                        logger.log("ImageObjectKey: " + imageObjectKey);
//                        logger.log("S3BucketName: " + System.getenv("S3BucketName"));
                    URL url = GeneratePresignedURL.generate("us-west-1", System.getenv("S3BucketName"), imageObjectKey, HttpMethod.PUT, metadata);
                    
                    String key = "image_" + Integer.toString(i);
                    
                    responseBody.put(key, url.toString());
                    
                    AttributeValue value = new AttributeValue().withS(("NIL"));
                    putItemRequest.addItemEntry(key, value);
                }
                
                
                logger.log("Starting to parse");
                // place discovery in DB
                PutPointResult putPointResult = geoIndexManager.putPoint(putPointRequest);

                
                
                // return attributes
                response.put("statusCode", 201);                    // resource created (201)
                responseBody.put("discoveryId", geoRangeKey);
                responseBody.put("geohashPrefix", Long.toString( S2Manager.generateHashKey(S2Manager.generateGeohash(geoPoint), config.getHashKeyLength())));
                responseBody.put("title", title.getS());
                responseBody.put("description", description.getS());
                responseBody.put("price", Integer.parseInt(price.getN()));
                responseBody.put("request_or_offer", reqORoff.getS());
                responseBody.put("active", active.getBOOL());
                responseBody.put("time", Integer.parseInt(time.getN()));
                responseBody.put("cognitoUserName", username.getS());
                responseBody.put("latitude", latitude.getN());
                responseBody.put("longitude", longitude.getN());
                logger.log("Done adding to response");
                
            }else {             // there was at least one attribute that didn't meet existence or validity
                response.put("statusCode", 400);
                responseBody.put("error", "Format of discovery is invalid");
            }
            
        } catch(NullPointerException | NumberFormatException  ex) {
            response.put("statusCode", "400");
            responseBody.put("error", "Format of discovery is invalid");
            //response.put("exception", pex);
        }catch (ParseException ex) {
            // TODO: handle exception
            logger.log("A PARSE EXCEPTION OCCURED");
        } catch (ClassCastException e) {
            // TODO: handle exception
            logger.log("CAST EXCEPTION");
        }

        response =  responseBody;
        logger.log("Response " + response.toString());
        logger.log("Closing stream");
        
        OutputStreamWriter writer = new OutputStreamWriter(outputStream, "UTF-8");
        writer.write(response.toJSONString());  
        writer.close();
        logger.log("Stream ed");
    }
    
    public void setup(Context context) {
        String accessKey = "AKIAJVBE225FGBCKOIZA";
        String secretKey = "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";
        
        AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
        AmazonDynamoDBClient ddb = new AmazonDynamoDBClient(credentials);
        ddb.withRegion(Regions.US_EAST_1);

        config = new GeoDataManagerConfiguration(ddb, "Discoveries").withHashKeyAttributeName("geohashPrefix").withRangeKeyAttributeName("discoveryId");
        geoIndexManager = new GeoDataManager(config);
        logger = context.getLogger();
    }
    
    public void checkCodeEnv(JSONObject event) {
        // If Dev Stage add properties
        if(System.getenv("STAGE").equals("Dev")) {
            logger.log("We are in the development stage!");
            logger.log(event.toJSONString());
            
            // set the fake user name property
            JSONObject claims = new JSONObject();
            claims.put("requestTimeEpoch", 846547200);
            claims.put("family_name", "Turing");
            claims.put("given_name", "Alan");
            claims.put("cognito:username", "54ece203-2301-4cd4-9fe6-cb43bdb5ca6e");
            
            JSONObject requestContext = new JSONObject();
            requestContext.put("claims", claims);
            
            event.put("requestContext", claims);
            // set the fake first and last name
        }
    }
    
    public void createTable(Context context) {
        // discoveryId, geoHashPrefix, Title, Description, Request/Offer, Price, Latitude, Longitude, cognitoUserName, active
        String accessKey = "AKIAJVBE225FGBCKOIZA";
        String secretKey = "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";
        String tableName = "Discoveries";
        
        AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
        AmazonDynamoDBClient ddb = new AmazonDynamoDBClient(credentials);
        Region usWest2 = Region.getRegion(Regions.US_WEST_2);
        ddb.setRegion(usWest2);
        
        GeoDataManagerConfiguration config = new GeoDataManagerConfiguration(ddb, tableName);
        config.withHashKeyAttributeName("geohashPrefix");
        config.withRangeKeyAttributeName("discoveryId");
        
        
        // request to create discoveries table
        CreateTableRequest createTableRequest = GeoTableUtil.getCreateTableRequest(config);
        //-------------------------------------------------------------------------------------------
        
        AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard().build();
        DynamoDB dynamoDB = new DynamoDB(client);
        
        // TODO: rename: servinId -> discoveryId, servinHash -> geoHashPrefix
        
        // Title, Description, Request/Offer, Price, Latitude, Longitude, cognitoUserName, active
        // servinHash, servinId
        // Attribute definitions
        ArrayList<AttributeDefinition> attributeDefinitions = new ArrayList<AttributeDefinition>();
        
        attributeDefinitions.add(new AttributeDefinition().withAttributeName("geohashPrefix").withAttributeType("N"));
        attributeDefinitions.add(new AttributeDefinition().withAttributeName("geohash").withAttributeType("N"));
        attributeDefinitions.add(new AttributeDefinition().withAttributeName("discoveryId").withAttributeType("S"));
//      attributeDefinitions.add(new AttributeDefinition().withAttributeName("geoJson").withAttributeType("S"));
//      
//      attributeDefinitions.add(new AttributeDefinition().withAttributeName("title").withAttributeType("S"));
//      attributeDefinitions.add(new AttributeDefinition().withAttributeName("description").withAttributeType("S"));
//      attributeDefinitions.add(new AttributeDefinition().withAttributeName("request_or_offer").withAttributeType("S"));
//      attributeDefinitions.add(new AttributeDefinition().withAttributeName("price").withAttributeType("N"));
        attributeDefinitions.add(new AttributeDefinition().withAttributeName("cognitoUserName").withAttributeType("S"));
//      attributeDefinitions.add(new AttributeDefinition().withAttributeName("active").withAttributeType("S"));
        
        // Table key schema
        ArrayList<KeySchemaElement> tableKeySchema = new ArrayList<KeySchemaElement>();
        tableKeySchema.add(new KeySchemaElement().withAttributeName("geoHashPrefix").withKeyType(KeyType.HASH));    //Partition key
        tableKeySchema.add(new KeySchemaElement().withAttributeName("discoveryId").withKeyType(KeyType.RANGE));     //Sort key
        
        // CognitoUserNameIndex
        // create GSI (Global Secondary Index) with twice as much as read and write capacity units
        // https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.html
        GlobalSecondaryIndex CognitoUserNameIndex = new GlobalSecondaryIndex()
            .withIndexName("CognitoUserNameIndex")
            .withProvisionedThroughput(new ProvisionedThroughput()
                .withReadCapacityUnits((long) 10)
                .withWriteCapacityUnits((long) 1))
            .withProjection(new Projection().withProjectionType(ProjectionType.ALL));
        
        // define attributes for GSI (Global Secondary Index)
        ArrayList<KeySchemaElement> indexKeySchema = new ArrayList<KeySchemaElement>();
        
        indexKeySchema.add(new KeySchemaElement()
            .withAttributeName("cognitoUserName")
            .withKeyType(KeyType.HASH));            //Partition key
        indexKeySchema.add(new KeySchemaElement()
            .withAttributeName("discoveryId")
            .withKeyType(KeyType.RANGE));           //Sort key
        //indexKeySchema.add(new KeySchemaElement().withAttributeName("geohash"));
        
        CognitoUserNameIndex.setKeySchema(indexKeySchema);
        
        createTableRequest
            //.withTableName(tableName)
            //.withProvisionedThroughput(new ProvisionedThroughput()
            //    .withReadCapacityUnits((long) 5)
            //   .withWriteCapacityUnits((long) 1))
            .withAttributeDefinitions(attributeDefinitions)
            //.withKeySchema(tableKeySchema)
            .withGlobalSecondaryIndexes(CognitoUserNameIndex);
        
        Table table = dynamoDB.createTable(createTableRequest);
        //System.out.println(table.getDescription());
        //-------------------------------------------------------------------------------------------
        //CreateTableResult createTableResult = ddb.createTable(createTableRequest);
        //context.getLogger().log(createTableRequest.toString());
        context.getLogger().log(table.getDescription().toString());
    }
    
    void secondCreateTable() {
        String accessKey = "AKIAJVBE225FGBCKOIZA";
        String secretKey = "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";
        AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
        AmazonDynamoDBClient ddb = new AmazonDynamoDBClient(credentials);
        Region usWest2 = Region.getRegion(Regions.US_WEST_2);
        ddb.setRegion(usWest2);

        GeoDataManagerConfiguration config = new GeoDataManagerConfiguration(ddb, "geo-test");
        
        config.withRangeKeyAttributeName("discoveryId");
        config.withHashKeyAttributeName("geohashPrefix");

        CreateTableRequest createTableRequest = GeoTableUtil.getCreateTableRequest(config);
        CreateTableResult createTableResult = ddb.createTable(createTableRequest);
    }

}
