package io.servin.discovery;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.math.BigInteger;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;
import java.util.Objects;
import java.util.Random;
import java.util.Vector;
import java.util.logging.Logger;

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
import com.amazonaws.profile.path.AwsDirectoryBasePathProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.ItemUtils;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.internal.InternalUtils;
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
import com.amazonaws.services.lambda.runtime.Client;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.amazonaws.services.s3.event.S3EventNotification.S3BucketEntity;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.google.common.hash.Hashing;

public class discoveryLambda implements RequestStreamHandler {
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
    
    /*
        Incoming Event object will look like:
        {
            "field": "getSurroundingDiscoveries",
            "arguments": {
                "longMax": -114.10414841026068,
                "latMin": 51.06819857381896,
                "latMax": 51.079065314915646,
                "longMin": -114.12024166435003
            }
        }
    */
    
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

            /*
             * GETTING DISCOVERIES:
             *  Extraction: Minimum Latitude, Maximum Latitude, Minimum Longitude, Maximum Longitude
             *  E(anArrtibute) -> attribute anAttribute meets the existence condition
             *  V(anArrtibute) -> attribute anAttribute meets the validity condition
             *  Process: 
             *      1. Check for existence (The value exist)
             *          By parsing string values to double you check for existence
             *      2. Check for validity (The value is valid)
             *          a. 1 <= length of title <= 250
             *          b. 1 <= length of description <= 2500
             *          c. reqORoff is an element of {request, offer}
             *          d. Price is an integer (Price is an element of Z), 0 <= Price (Price has bottom limit), Price <= 1000 (Price has an upper limit)
             *          e. -90 <= latitude <= 90
             *          f. -180 <= longitude <= 180
             * */
            // parse query parameters
        	
            logger.log("Gets till here!");
            
            JSONObject queryParams = (JSONObject)event.get("arguments");
            logger.log("Query Params");
            logger.log(queryParams.toString());
            double latMin   = Double.parseDouble(queryParams.get("latMin").toString());             // E(latMin)
            double latMax   = Double.parseDouble(queryParams.get("latMax").toString());             // E(latMax)
            double longMin  = Double.parseDouble(queryParams.get("longMin").toString());            // E(longMin)
            double longMax  = Double.parseDouble(queryParams.get("longMax").toString());            // E(longMax)
            
            logger.log("latMin  " + latMin);
            logger.log("latMax  " + latMax);
            logger.log("longMin " + longMin);
            logger.log("longMax " + longMax);
            
            /* Ensure V(latMin), V(latMax), V(longMin), V(longMax) */
            if(     0 < latMax - latMin &&
                    0 < longMax - longMin &&
                    latMax - latMin < BOUND_BOX_SEARCH_SIZE_MAX &&
                    longMax - longMin < BOUND_BOX_SEARCH_SIZE_MAX
            ) {     // all parameters (latMin, latMax, longMing, longMax) for bounded box have existence and validity
                GeoPoint bottomLeft = new GeoPoint(latMin, longMin);
                GeoPoint topRight   = new GeoPoint(latMax, longMax);
                
                // querying database for result
                QueryRectangleRequest queryRectangleRequest = new QueryRectangleRequest(bottomLeft, topRight);
                QueryRectangleResult queryRectangleResult = geoIndexManager.queryRectangle(queryRectangleRequest);
                
                
                JSONArray parsedDiscoveries = new JSONArray();
                for (Map<String, AttributeValue> item : queryRectangleResult.getItem()) {
                	if (item.get("active").getBOOL()) {
                        //String geoRangeKey = item.get("discoveryId").getS();							// reading geoRangeKey (unique for each discovery)
                        
                        JSONObject geoJSON = (JSONObject) parser.parse(item.get("geoJson").getS());
                        JSONArray coordinates = (JSONArray) geoJSON.get("coordinates");
                        
                        
                        // instantiate discovery item and add all required values
                        logger.log("Discovery:");
                        logger.log(item.toString());
                        JSONObject discovery = new JSONObject();
                        discovery.put("geohashPrefix",      item.get("geohashPrefix").getN());
                        discovery.put("discoveryId",		item.get("discoveryId").getS());
                        discovery.put("active",		        item.get("active").getBOOL());
                        discovery.put("cognitoUserName",    item.get("cognitoUserName").getS());
                        discovery.put("description",		item.get("description").getS());
                        discovery.put("price",				item.get("price").getN());
                        discovery.put("request_or_offer",	item.get("request_or_offer").getS());
                        discovery.put("time",				item.get("time").getN());
                        discovery.put("title",				item.get("title").getS());
                        discovery.put("geoJson",			item.get("geoJson").getS());
                        discovery.put("latitude", 			coordinates.get(0));
                        discovery.put("longitude", 			coordinates.get(1));
                        discovery.put("image_0",            ItemUtils.toSimpleMapValue(item.get("image_0").getM()));    //https://stackoverflow.com/questions/43812278/converting-dynamodb-json-to-standard-json-with-java
                        discovery.put("image_1",            ItemUtils.toSimpleMapValue(item.get("image_1").getM()));
                        discovery.put("image_2",            ItemUtils.toSimpleMapValue(item.get("image_2").getM()));
                        discovery.put("image_3",            ItemUtils.toSimpleMapValue(item.get("image_3").getM()));
                        discovery.put("image_4",            ItemUtils.toSimpleMapValue(item.get("image_4").getM()));
                        discovery.put("image_5",            ItemUtils.toSimpleMapValue(item.get("image_5").getM()));

                        parsedDiscoveries.add(discovery);
					}
                }
                logger.log(parsedDiscoveries.toJSONString());
                responseBody.put("discoveries", parsedDiscoveries);
            } else { // there was parameter(s) that didn't meet validity
                response.put("statusCode", 400);
                responseBody.put("error", "Format of request is invalid");
            }
            
        } catch(NullPointerException | NumberFormatException  ex) {
            logger.log(ex.toString());
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

        response = responseBody;
        logger.log("Response is " + response.toString());
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
