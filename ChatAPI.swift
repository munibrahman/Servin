//  This file was automatically generated and should not be edited.

import AWSAppSync

public final class CreateConversationMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateConversation($discoveryId: String!) {\n  createConversation(discoveryId: $discoveryId) {\n    __typename\n    createdAt\n    id\n    discoveryId\n    messages {\n      __typename\n      messages {\n        __typename\n        content\n        conversationId\n        createdAt\n        id\n        isSent\n        sender\n      }\n      nextToken\n    }\n    latestMessage {\n      __typename\n      author {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n      content\n      conversationId\n      createdAt\n      id\n      isSent\n      recipient {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n      sender\n    }\n    discovery {\n      __typename\n      discoveryId\n      active\n      cognitoUserName\n      description\n      price\n      request_or_offer\n      time\n      title\n      image_0\n      image_1\n      image_2\n      image_3\n      image_4\n      image_5\n      author {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n    }\n  }\n}"

  public var discoveryId: String

  public init(discoveryId: String) {
    self.discoveryId = discoveryId
  }

  public var variables: GraphQLMap? {
    return ["discoveryId": discoveryId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createConversation", arguments: ["discoveryId": GraphQLVariable("discoveryId")], type: .object(CreateConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createConversation: CreateConversation? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createConversation": createConversation.flatMap { $0.snapshot }])
    }

    /// Create a Conversation. Use some of the cooked in template functions for UUID and DateTime.
    /// # You can create a conversation based on the id. createdAt and id fields will be determined by us (So, users can't manipulate them)
    /// # createConversation(createdAt: String, id: ID!, discoveryId: String!): Conversation
    public var createConversation: CreateConversation? {
      get {
        return (snapshot["createConversation"] as? Snapshot).flatMap { CreateConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createConversation")
      }
    }

    public struct CreateConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .scalar(Int.self)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("latestMessage", type: .object(LatestMessage.selections)),
        GraphQLField("discovery", type: .object(Discovery.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(createdAt: Int? = nil, id: GraphQLID, discoveryId: String, messages: Message? = nil, latestMessage: LatestMessage? = nil, discovery: Discovery? = nil) {
        self.init(snapshot: ["__typename": "Conversation", "createdAt": createdAt, "id": id, "discoveryId": discoveryId, "messages": messages.flatMap { $0.snapshot }, "latestMessage": latestMessage.flatMap { $0.snapshot }, "discovery": discovery.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The Conversation's timestamp.
      public var createdAt: Int? {
        get {
          return snapshot["createdAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      /// A unique identifier for the Conversation.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// The Conversation's discoveryId. (formerly known as name)
      public var discoveryId: String {
        get {
          return snapshot["discoveryId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "discoveryId")
        }
      }

      /// The Conversation's messages.
      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      /// Latest message of a conversation
      public var latestMessage: LatestMessage? {
        get {
          return (snapshot["latestMessage"] as? Snapshot).flatMap { LatestMessage(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "latestMessage")
        }
      }

      /// Discovery related to the conversation
      public var discovery: Discovery? {
        get {
          return (snapshot["discovery"] as? Snapshot).flatMap { Discovery(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "discovery")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["MessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("messages", type: .list(.object(Message.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(messages: [Message?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "MessageConnection", "messages": messages.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var messages: [Message?]? {
          get {
            return (snapshot["messages"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Message(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "messages")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["Message"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("content", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("createdAt", type: .scalar(Int.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("isSent", type: .scalar(Bool.self)),
            GraphQLField("sender", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, sender: String? = nil) {
            self.init(snapshot: ["__typename": "Message", "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "sender": sender])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The message content.
          public var content: String {
            get {
              return snapshot["content"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "content")
            }
          }

          /// The id of the Conversation this message belongs to. This is the table primary key.
          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          /// The message timestamp. This is also the table sort key.
          public var createdAt: Int? {
            get {
              return snapshot["createdAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// Generated id for a message -- read-only
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          /// Flag denoting if this message has been accepted by the server or not.
          public var isSent: Bool? {
            get {
              return snapshot["isSent"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isSent")
            }
          }

          public var sender: String? {
            get {
              return snapshot["sender"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "sender")
            }
          }
        }
      }

      public struct LatestMessage: GraphQLSelectionSet {
        public static let possibleTypes = ["Message"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("author", type: .object(Author.selections)),
          GraphQLField("content", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .scalar(Int.self)),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("isSent", type: .scalar(Bool.self)),
          GraphQLField("recipient", type: .object(Recipient.selections)),
          GraphQLField("sender", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(author: Author? = nil, content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, recipient: Recipient? = nil, sender: String? = nil) {
          self.init(snapshot: ["__typename": "Message", "author": author.flatMap { $0.snapshot }, "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "recipient": recipient.flatMap { $0.snapshot }, "sender": sender])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The author object. Note: `authorId` is only available because we list it in `extraAttributes` in `Conversation.messages`
        public var author: Author? {
          get {
            return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "author")
          }
        }

        /// The message content.
        public var content: String {
          get {
            return snapshot["content"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
          }
        }

        /// The id of the Conversation this message belongs to. This is the table primary key.
        public var conversationId: GraphQLID {
          get {
            return snapshot["conversationId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "conversationId")
          }
        }

        /// The message timestamp. This is also the table sort key.
        public var createdAt: Int? {
          get {
            return snapshot["createdAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        /// Generated id for a message -- read-only
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// Flag denoting if this message has been accepted by the server or not.
        public var isSent: Bool? {
          get {
            return snapshot["isSent"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "isSent")
          }
        }

        public var recipient: Recipient? {
          get {
            return (snapshot["recipient"] as? Snapshot).flatMap { Recipient(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "recipient")
          }
        }

        public var sender: String? {
          get {
            return snapshot["sender"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "sender")
          }
        }

        public struct Author: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }

        public struct Recipient: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }
      }

      public struct Discovery: GraphQLSelectionSet {
        public static let possibleTypes = ["Discovery"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
          GraphQLField("active", type: .scalar(Bool.self)),
          GraphQLField("cognitoUserName", type: .scalar(String.self)),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("price", type: .scalar(Int.self)),
          GraphQLField("request_or_offer", type: .nonNull(.scalar(String.self))),
          GraphQLField("time", type: .scalar(Int.self)),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("image_0", type: .scalar(String.self)),
          GraphQLField("image_1", type: .scalar(String.self)),
          GraphQLField("image_2", type: .scalar(String.self)),
          GraphQLField("image_3", type: .scalar(String.self)),
          GraphQLField("image_4", type: .scalar(String.self)),
          GraphQLField("image_5", type: .scalar(String.self)),
          GraphQLField("author", type: .object(Author.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(discoveryId: String, active: Bool? = nil, cognitoUserName: String? = nil, description: String? = nil, price: Int? = nil, requestOrOffer: String, time: Int? = nil, title: String? = nil, image_0: String? = nil, image_1: String? = nil, image_2: String? = nil, image_3: String? = nil, image_4: String? = nil, image_5: String? = nil, author: Author? = nil) {
          self.init(snapshot: ["__typename": "Discovery", "discoveryId": discoveryId, "active": active, "cognitoUserName": cognitoUserName, "description": description, "price": price, "request_or_offer": requestOrOffer, "time": time, "title": title, "image_0": image_0, "image_1": image_1, "image_2": image_2, "image_3": image_3, "image_4": image_4, "image_5": image_5, "author": author.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// id of the discovery
        public var discoveryId: String {
          get {
            return snapshot["discoveryId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "discoveryId")
          }
        }

        /// Whether this discovery is on the network or not
        public var active: Bool? {
          get {
            return snapshot["active"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "active")
          }
        }

        /// Username of the owner, same thing as cognitoId
        public var cognitoUserName: String? {
          get {
            return snapshot["cognitoUserName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "cognitoUserName")
          }
        }

        /// Description of the discovery
        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        /// Price of the discovery
        public var price: Int? {
          get {
            return snapshot["price"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "price")
          }
        }

        /// Is this a request or an offer
        public var requestOrOffer: String {
          get {
            return snapshot["request_or_offer"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "request_or_offer")
          }
        }

        /// When this discovery was created, seconds from epoch
        public var time: Int? {
          get {
            return snapshot["time"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "time")
          }
        }

        /// Title of the discovery
        public var title: String? {
          get {
            return snapshot["title"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        /// image 1
        public var image_0: String? {
          get {
            return snapshot["image_0"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_0")
          }
        }

        /// image 2
        public var image_1: String? {
          get {
            return snapshot["image_1"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_1")
          }
        }

        /// image 3
        public var image_2: String? {
          get {
            return snapshot["image_2"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_2")
          }
        }

        /// image 4
        public var image_3: String? {
          get {
            return snapshot["image_3"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_3")
          }
        }

        /// image 5
        public var image_4: String? {
          get {
            return snapshot["image_4"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_4")
          }
        }

        /// image 5
        public var image_5: String? {
          get {
            return snapshot["image_5"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_5")
          }
        }

        /// Author of this discovery
        public var author: Author? {
          get {
            return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "author")
          }
        }

        public struct Author: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }
      }
    }
  }
}

public final class CreateMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateMessage($content: String, $conversationId: ID!) {\n  createMessage(content: $content, conversationId: $conversationId) {\n    __typename\n    author {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    content\n    conversationId\n    createdAt\n    id\n    isSent\n    recipient {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    sender\n  }\n}"

  public var content: String?
  public var conversationId: GraphQLID

  public init(content: String? = nil, conversationId: GraphQLID) {
    self.content = content
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["content": content, "conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createMessage", arguments: ["content": GraphQLVariable("content"), "conversationId": GraphQLVariable("conversationId")], type: .object(CreateMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createMessage: CreateMessage? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createMessage": createMessage.flatMap { $0.snapshot }])
    }

    /// Create a message in a Conversation.
    /// # We only let the users pass in content and the conversation id, we take care of created at and message id.
    /// # createMessage(content: String, conversationId: ID!, createdAt: String!, id: ID!): Message
    public var createMessage: CreateMessage? {
      get {
        return (snapshot["createMessage"] as? Snapshot).flatMap { CreateMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createMessage")
      }
    }

    public struct CreateMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("author", type: .object(Author.selections)),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .scalar(Int.self)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("isSent", type: .scalar(Bool.self)),
        GraphQLField("recipient", type: .object(Recipient.selections)),
        GraphQLField("sender", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(author: Author? = nil, content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, recipient: Recipient? = nil, sender: String? = nil) {
        self.init(snapshot: ["__typename": "Message", "author": author.flatMap { $0.snapshot }, "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "recipient": recipient.flatMap { $0.snapshot }, "sender": sender])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The author object. Note: `authorId` is only available because we list it in `extraAttributes` in `Conversation.messages`
      public var author: Author? {
        get {
          return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "author")
        }
      }

      /// The message content.
      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      /// The id of the Conversation this message belongs to. This is the table primary key.
      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationId")
        }
      }

      /// The message timestamp. This is also the table sort key.
      public var createdAt: Int? {
        get {
          return snapshot["createdAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      /// Generated id for a message -- read-only
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// Flag denoting if this message has been accepted by the server or not.
      public var isSent: Bool? {
        get {
          return snapshot["isSent"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isSent")
        }
      }

      public var recipient: Recipient? {
        get {
          return (snapshot["recipient"] as? Snapshot).flatMap { Recipient(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "recipient")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public struct Author: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct Recipient: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class CreateUserConversationsMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateUserConversations($conversationId: ID!, $userId: ID!) {\n  createUserConversations(conversationId: $conversationId, userId: $userId) {\n    __typename\n    associated {\n      __typename\n      associated {\n        __typename\n        conversationId\n        userId\n      }\n      conversation {\n        __typename\n        createdAt\n        id\n        discoveryId\n      }\n      conversationId\n      user {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n      userId\n    }\n    conversation {\n      __typename\n      createdAt\n      id\n      discoveryId\n      messages {\n        __typename\n        nextToken\n      }\n      latestMessage {\n        __typename\n        content\n        conversationId\n        createdAt\n        id\n        isSent\n        sender\n      }\n      discovery {\n        __typename\n        discoveryId\n        active\n        cognitoUserName\n        description\n        price\n        request_or_offer\n        time\n        title\n        image_0\n        image_1\n        image_2\n        image_3\n        image_4\n        image_5\n      }\n    }\n    conversationId\n    user {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    userId\n  }\n}"

  public var conversationId: GraphQLID
  public var userId: GraphQLID

  public init(conversationId: GraphQLID, userId: GraphQLID) {
    self.conversationId = conversationId
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId, "userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createUserConversations", arguments: ["conversationId": GraphQLVariable("conversationId"), "userId": GraphQLVariable("userId")], type: .object(CreateUserConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createUserConversations: CreateUserConversation? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createUserConversations": createUserConversations.flatMap { $0.snapshot }])
    }

    /// Put a single value of type 'User'. If an item does not exist with the same key the item will be created. If there exists an item at that key already, it will be updated.
    /// # No need to create a new user
    /// # createUser(username: String!): User
    /// #  Put a single value of type 'UserConversations'. If an item does not exist with the same key the item will be created. If there exists an item at that key already, it will be updated.
    public var createUserConversations: CreateUserConversation? {
      get {
        return (snapshot["createUserConversations"] as? Snapshot).flatMap { CreateUserConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createUserConversations")
      }
    }

    public struct CreateUserConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["UserConversations"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("associated", type: .list(.object(Associated.selections))),
        GraphQLField("conversation", type: .object(Conversation.selections)),
        GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(associated: [Associated?]? = nil, conversation: Conversation? = nil, conversationId: GraphQLID, user: User? = nil, userId: GraphQLID) {
        self.init(snapshot: ["__typename": "UserConversations", "associated": associated.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "conversation": conversation.flatMap { $0.snapshot }, "conversationId": conversationId, "user": user.flatMap { $0.snapshot }, "userId": userId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var associated: [Associated?]? {
        get {
          return (snapshot["associated"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Associated(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "associated")
        }
      }

      public var conversation: Conversation? {
        get {
          return (snapshot["conversation"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "conversation")
        }
      }

      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationId")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userId")
        }
      }

      public struct Associated: GraphQLSelectionSet {
        public static let possibleTypes = ["UserConversations"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("associated", type: .list(.object(Associated.selections))),
          GraphQLField("conversation", type: .object(Conversation.selections)),
          GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("user", type: .object(User.selections)),
          GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(associated: [Associated?]? = nil, conversation: Conversation? = nil, conversationId: GraphQLID, user: User? = nil, userId: GraphQLID) {
          self.init(snapshot: ["__typename": "UserConversations", "associated": associated.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "conversation": conversation.flatMap { $0.snapshot }, "conversationId": conversationId, "user": user.flatMap { $0.snapshot }, "userId": userId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var associated: [Associated?]? {
          get {
            return (snapshot["associated"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Associated(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "associated")
          }
        }

        public var conversation: Conversation? {
          get {
            return (snapshot["conversation"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversation")
          }
        }

        public var conversationId: GraphQLID {
          get {
            return snapshot["conversationId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "conversationId")
          }
        }

        public var user: User? {
          get {
            return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "user")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        public struct Associated: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConversations"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(conversationId: GraphQLID, userId: GraphQLID) {
            self.init(snapshot: ["__typename": "UserConversations", "conversationId": conversationId, "userId": userId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          public var userId: GraphQLID {
            get {
              return snapshot["userId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["Conversation"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .scalar(Int.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(createdAt: Int? = nil, id: GraphQLID, discoveryId: String) {
            self.init(snapshot: ["__typename": "Conversation", "createdAt": createdAt, "id": id, "discoveryId": discoveryId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The Conversation's timestamp.
          public var createdAt: Int? {
            get {
              return snapshot["createdAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// A unique identifier for the Conversation.
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          /// The Conversation's discoveryId. (formerly known as name)
          public var discoveryId: String {
            get {
              return snapshot["discoveryId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "discoveryId")
            }
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }
      }

      public struct Conversation: GraphQLSelectionSet {
        public static let possibleTypes = ["Conversation"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .scalar(Int.self)),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("latestMessage", type: .object(LatestMessage.selections)),
          GraphQLField("discovery", type: .object(Discovery.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(createdAt: Int? = nil, id: GraphQLID, discoveryId: String, messages: Message? = nil, latestMessage: LatestMessage? = nil, discovery: Discovery? = nil) {
          self.init(snapshot: ["__typename": "Conversation", "createdAt": createdAt, "id": id, "discoveryId": discoveryId, "messages": messages.flatMap { $0.snapshot }, "latestMessage": latestMessage.flatMap { $0.snapshot }, "discovery": discovery.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The Conversation's timestamp.
        public var createdAt: Int? {
          get {
            return snapshot["createdAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        /// A unique identifier for the Conversation.
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// The Conversation's discoveryId. (formerly known as name)
        public var discoveryId: String {
          get {
            return snapshot["discoveryId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "discoveryId")
          }
        }

        /// The Conversation's messages.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// Latest message of a conversation
        public var latestMessage: LatestMessage? {
          get {
            return (snapshot["latestMessage"] as? Snapshot).flatMap { LatestMessage(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "latestMessage")
          }
        }

        /// Discovery related to the conversation
        public var discovery: Discovery? {
          get {
            return (snapshot["discovery"] as? Snapshot).flatMap { Discovery(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "discovery")
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct LatestMessage: GraphQLSelectionSet {
          public static let possibleTypes = ["Message"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("content", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("createdAt", type: .scalar(Int.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("isSent", type: .scalar(Bool.self)),
            GraphQLField("sender", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, sender: String? = nil) {
            self.init(snapshot: ["__typename": "Message", "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "sender": sender])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The message content.
          public var content: String {
            get {
              return snapshot["content"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "content")
            }
          }

          /// The id of the Conversation this message belongs to. This is the table primary key.
          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          /// The message timestamp. This is also the table sort key.
          public var createdAt: Int? {
            get {
              return snapshot["createdAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// Generated id for a message -- read-only
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          /// Flag denoting if this message has been accepted by the server or not.
          public var isSent: Bool? {
            get {
              return snapshot["isSent"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isSent")
            }
          }

          public var sender: String? {
            get {
              return snapshot["sender"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "sender")
            }
          }
        }

        public struct Discovery: GraphQLSelectionSet {
          public static let possibleTypes = ["Discovery"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
            GraphQLField("active", type: .scalar(Bool.self)),
            GraphQLField("cognitoUserName", type: .scalar(String.self)),
            GraphQLField("description", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(Int.self)),
            GraphQLField("request_or_offer", type: .nonNull(.scalar(String.self))),
            GraphQLField("time", type: .scalar(Int.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("image_0", type: .scalar(String.self)),
            GraphQLField("image_1", type: .scalar(String.self)),
            GraphQLField("image_2", type: .scalar(String.self)),
            GraphQLField("image_3", type: .scalar(String.self)),
            GraphQLField("image_4", type: .scalar(String.self)),
            GraphQLField("image_5", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(discoveryId: String, active: Bool? = nil, cognitoUserName: String? = nil, description: String? = nil, price: Int? = nil, requestOrOffer: String, time: Int? = nil, title: String? = nil, image_0: String? = nil, image_1: String? = nil, image_2: String? = nil, image_3: String? = nil, image_4: String? = nil, image_5: String? = nil) {
            self.init(snapshot: ["__typename": "Discovery", "discoveryId": discoveryId, "active": active, "cognitoUserName": cognitoUserName, "description": description, "price": price, "request_or_offer": requestOrOffer, "time": time, "title": title, "image_0": image_0, "image_1": image_1, "image_2": image_2, "image_3": image_3, "image_4": image_4, "image_5": image_5])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// id of the discovery
          public var discoveryId: String {
            get {
              return snapshot["discoveryId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "discoveryId")
            }
          }

          /// Whether this discovery is on the network or not
          public var active: Bool? {
            get {
              return snapshot["active"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "active")
            }
          }

          /// Username of the owner, same thing as cognitoId
          public var cognitoUserName: String? {
            get {
              return snapshot["cognitoUserName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "cognitoUserName")
            }
          }

          /// Description of the discovery
          public var description: String? {
            get {
              return snapshot["description"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "description")
            }
          }

          /// Price of the discovery
          public var price: Int? {
            get {
              return snapshot["price"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          /// Is this a request or an offer
          public var requestOrOffer: String {
            get {
              return snapshot["request_or_offer"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "request_or_offer")
            }
          }

          /// When this discovery was created, seconds from epoch
          public var time: Int? {
            get {
              return snapshot["time"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "time")
            }
          }

          /// Title of the discovery
          public var title: String? {
            get {
              return snapshot["title"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "title")
            }
          }

          /// image 1
          public var image_0: String? {
            get {
              return snapshot["image_0"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_0")
            }
          }

          /// image 2
          public var image_1: String? {
            get {
              return snapshot["image_1"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_1")
            }
          }

          /// image 3
          public var image_2: String? {
            get {
              return snapshot["image_2"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_2")
            }
          }

          /// image 4
          public var image_3: String? {
            get {
              return snapshot["image_3"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_3")
            }
          }

          /// image 5
          public var image_4: String? {
            get {
              return snapshot["image_4"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_4")
            }
          }

          /// image 5
          public var image_5: String? {
            get {
              return snapshot["image_5"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_5")
            }
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class AllMessageQuery: GraphQLQuery {
  public static let operationString =
    "query AllMessage($after: String, $conversationId: ID!, $first: Int) {\n  allMessage(after: $after, conversationId: $conversationId, first: $first) {\n    __typename\n    author {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    content\n    conversationId\n    createdAt\n    id\n    isSent\n    recipient {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    sender\n  }\n}"

  public var after: String?
  public var conversationId: GraphQLID
  public var first: Int?

  public init(after: String? = nil, conversationId: GraphQLID, first: Int? = nil) {
    self.after = after
    self.conversationId = conversationId
    self.first = first
  }

  public var variables: GraphQLMap? {
    return ["after": after, "conversationId": conversationId, "first": first]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("allMessage", arguments: ["after": GraphQLVariable("after"), "conversationId": GraphQLVariable("conversationId"), "first": GraphQLVariable("first")], type: .list(.object(AllMessage.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(allMessage: [AllMessage?]? = nil) {
      self.init(snapshot: ["__typename": "Query", "allMessage": allMessage.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
    }

    /// Scan through all values of type 'Message'. Use the 'after' and 'before' arguments with the 'nextToken' returned by the 'MessageConnection' result to fetch pages.
    public var allMessage: [AllMessage?]? {
      get {
        return (snapshot["allMessage"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { AllMessage(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "allMessage")
      }
    }

    public struct AllMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("author", type: .object(Author.selections)),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .scalar(Int.self)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("isSent", type: .scalar(Bool.self)),
        GraphQLField("recipient", type: .object(Recipient.selections)),
        GraphQLField("sender", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(author: Author? = nil, content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, recipient: Recipient? = nil, sender: String? = nil) {
        self.init(snapshot: ["__typename": "Message", "author": author.flatMap { $0.snapshot }, "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "recipient": recipient.flatMap { $0.snapshot }, "sender": sender])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The author object. Note: `authorId` is only available because we list it in `extraAttributes` in `Conversation.messages`
      public var author: Author? {
        get {
          return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "author")
        }
      }

      /// The message content.
      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      /// The id of the Conversation this message belongs to. This is the table primary key.
      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationId")
        }
      }

      /// The message timestamp. This is also the table sort key.
      public var createdAt: Int? {
        get {
          return snapshot["createdAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      /// Generated id for a message -- read-only
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// Flag denoting if this message has been accepted by the server or not.
      public var isSent: Bool? {
        get {
          return snapshot["isSent"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isSent")
        }
      }

      public var recipient: Recipient? {
        get {
          return (snapshot["recipient"] as? Snapshot).flatMap { Recipient(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "recipient")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public struct Author: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct Recipient: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class AllMessageConnectionQuery: GraphQLQuery {
  public static let operationString =
    "query AllMessageConnection($after: String, $conversationId: ID!, $first: Int) {\n  allMessageConnection(after: $after, conversationId: $conversationId, first: $first) {\n    __typename\n    messages {\n      __typename\n      author {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n      content\n      conversationId\n      createdAt\n      id\n      isSent\n      recipient {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n      sender\n    }\n    nextToken\n  }\n}"

  public var after: String?
  public var conversationId: GraphQLID
  public var first: Int?

  public init(after: String? = nil, conversationId: GraphQLID, first: Int? = nil) {
    self.after = after
    self.conversationId = conversationId
    self.first = first
  }

  public var variables: GraphQLMap? {
    return ["after": after, "conversationId": conversationId, "first": first]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("allMessageConnection", arguments: ["after": GraphQLVariable("after"), "conversationId": GraphQLVariable("conversationId"), "first": GraphQLVariable("first")], type: .object(AllMessageConnection.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(allMessageConnection: AllMessageConnection? = nil) {
      self.init(snapshot: ["__typename": "Query", "allMessageConnection": allMessageConnection.flatMap { $0.snapshot }])
    }

    /// Scan through all values of type 'MessageConnection'. Use the 'after' and 'before' arguments with the 'nextToken' returned by the 'MessageConnectionConnection' result to fetch pages.
    public var allMessageConnection: AllMessageConnection? {
      get {
        return (snapshot["allMessageConnection"] as? Snapshot).flatMap { AllMessageConnection(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "allMessageConnection")
      }
    }

    public struct AllMessageConnection: GraphQLSelectionSet {
      public static let possibleTypes = ["MessageConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("messages", type: .list(.object(Message.selections))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(messages: [Message?]? = nil, nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "MessageConnection", "messages": messages.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var messages: [Message?]? {
        get {
          return (snapshot["messages"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Message(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "messages")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["Message"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("author", type: .object(Author.selections)),
          GraphQLField("content", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .scalar(Int.self)),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("isSent", type: .scalar(Bool.self)),
          GraphQLField("recipient", type: .object(Recipient.selections)),
          GraphQLField("sender", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(author: Author? = nil, content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, recipient: Recipient? = nil, sender: String? = nil) {
          self.init(snapshot: ["__typename": "Message", "author": author.flatMap { $0.snapshot }, "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "recipient": recipient.flatMap { $0.snapshot }, "sender": sender])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The author object. Note: `authorId` is only available because we list it in `extraAttributes` in `Conversation.messages`
        public var author: Author? {
          get {
            return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "author")
          }
        }

        /// The message content.
        public var content: String {
          get {
            return snapshot["content"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
          }
        }

        /// The id of the Conversation this message belongs to. This is the table primary key.
        public var conversationId: GraphQLID {
          get {
            return snapshot["conversationId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "conversationId")
          }
        }

        /// The message timestamp. This is also the table sort key.
        public var createdAt: Int? {
          get {
            return snapshot["createdAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        /// Generated id for a message -- read-only
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// Flag denoting if this message has been accepted by the server or not.
        public var isSent: Bool? {
          get {
            return snapshot["isSent"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "isSent")
          }
        }

        public var recipient: Recipient? {
          get {
            return (snapshot["recipient"] as? Snapshot).flatMap { Recipient(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "recipient")
          }
        }

        public var sender: String? {
          get {
            return snapshot["sender"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "sender")
          }
        }

        public struct Author: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }

        public struct Recipient: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }
      }
    }
  }
}

public final class AllMessageFromQuery: GraphQLQuery {
  public static let operationString =
    "query AllMessageFrom($after: String, $conversationId: ID!, $first: Int, $sender: String!) {\n  allMessageFrom(after: $after, conversationId: $conversationId, first: $first, sender: $sender) {\n    __typename\n    author {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    content\n    conversationId\n    createdAt\n    id\n    isSent\n    recipient {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    sender\n  }\n}"

  public var after: String?
  public var conversationId: GraphQLID
  public var first: Int?
  public var sender: String

  public init(after: String? = nil, conversationId: GraphQLID, first: Int? = nil, sender: String) {
    self.after = after
    self.conversationId = conversationId
    self.first = first
    self.sender = sender
  }

  public var variables: GraphQLMap? {
    return ["after": after, "conversationId": conversationId, "first": first, "sender": sender]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("allMessageFrom", arguments: ["after": GraphQLVariable("after"), "conversationId": GraphQLVariable("conversationId"), "first": GraphQLVariable("first"), "sender": GraphQLVariable("sender")], type: .list(.object(AllMessageFrom.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(allMessageFrom: [AllMessageFrom?]? = nil) {
      self.init(snapshot: ["__typename": "Query", "allMessageFrom": allMessageFrom.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
    }

    public var allMessageFrom: [AllMessageFrom?]? {
      get {
        return (snapshot["allMessageFrom"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { AllMessageFrom(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "allMessageFrom")
      }
    }

    public struct AllMessageFrom: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("author", type: .object(Author.selections)),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .scalar(Int.self)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("isSent", type: .scalar(Bool.self)),
        GraphQLField("recipient", type: .object(Recipient.selections)),
        GraphQLField("sender", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(author: Author? = nil, content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, recipient: Recipient? = nil, sender: String? = nil) {
        self.init(snapshot: ["__typename": "Message", "author": author.flatMap { $0.snapshot }, "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "recipient": recipient.flatMap { $0.snapshot }, "sender": sender])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The author object. Note: `authorId` is only available because we list it in `extraAttributes` in `Conversation.messages`
      public var author: Author? {
        get {
          return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "author")
        }
      }

      /// The message content.
      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      /// The id of the Conversation this message belongs to. This is the table primary key.
      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationId")
        }
      }

      /// The message timestamp. This is also the table sort key.
      public var createdAt: Int? {
        get {
          return snapshot["createdAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      /// Generated id for a message -- read-only
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// Flag denoting if this message has been accepted by the server or not.
      public var isSent: Bool? {
        get {
          return snapshot["isSent"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isSent")
        }
      }

      public var recipient: Recipient? {
        get {
          return (snapshot["recipient"] as? Snapshot).flatMap { Recipient(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "recipient")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public struct Author: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct Recipient: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class AllUserQuery: GraphQLQuery {
  public static let operationString =
    "query AllUser($after: String, $first: Int) {\n  allUser(after: $after, first: $first) {\n    __typename\n    userId\n    conversations {\n      __typename\n      nextToken\n      userConversations {\n        __typename\n        conversationId\n        userId\n      }\n    }\n    messages {\n      __typename\n      messages {\n        __typename\n        content\n        conversationId\n        createdAt\n        id\n        isSent\n        sender\n      }\n      nextToken\n    }\n    registered\n    firstName\n    lastName\n  }\n}"

  public var after: String?
  public var first: Int?

  public init(after: String? = nil, first: Int? = nil) {
    self.after = after
    self.first = first
  }

  public var variables: GraphQLMap? {
    return ["after": after, "first": first]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("allUser", arguments: ["after": GraphQLVariable("after"), "first": GraphQLVariable("first")], type: .list(.object(AllUser.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(allUser: [AllUser?]? = nil) {
      self.init(snapshot: ["__typename": "Query", "allUser": allUser.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
    }

    /// Scan through all values of type 'User'. Use the 'after' and 'before' arguments with the 'nextToken' returned by the 'UserConnection' result to fetch pages.
    public var allUser: [AllUser?]? {
      get {
        return (snapshot["allUser"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { AllUser(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "allUser")
      }
    }

    public struct AllUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("userId", type: .nonNull(.scalar(String.self))),
        GraphQLField("conversations", type: .object(Conversation.selections)),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("registered", type: .scalar(Bool.self)),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
        self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var userId: String {
        get {
          return snapshot["userId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "userId")
        }
      }

      /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
      public var conversations: Conversation? {
        get {
          return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
        }
      }

      /// Get a users messages by querying a GSI on the Messages table.
      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      /// is the user registered?
      public var registered: Bool? {
        get {
          return snapshot["registered"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "registered")
        }
      }

      /// First name of the user
      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      /// Last name of the user
      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public struct Conversation: GraphQLSelectionSet {
        public static let possibleTypes = ["UserConverstationsConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
          GraphQLField("userConversations", type: .list(.object(UserConversation.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil, userConversations: [UserConversation?]? = nil) {
          self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken, "userConversations": userConversations.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public var userConversations: [UserConversation?]? {
          get {
            return (snapshot["userConversations"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { UserConversation(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "userConversations")
          }
        }

        public struct UserConversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConversations"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(conversationId: GraphQLID, userId: GraphQLID) {
            self.init(snapshot: ["__typename": "UserConversations", "conversationId": conversationId, "userId": userId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          public var userId: GraphQLID {
            get {
              return snapshot["userId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["MessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("messages", type: .list(.object(Message.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(messages: [Message?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "MessageConnection", "messages": messages.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var messages: [Message?]? {
          get {
            return (snapshot["messages"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Message(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "messages")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["Message"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("content", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("createdAt", type: .scalar(Int.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("isSent", type: .scalar(Bool.self)),
            GraphQLField("sender", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, sender: String? = nil) {
            self.init(snapshot: ["__typename": "Message", "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "sender": sender])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The message content.
          public var content: String {
            get {
              return snapshot["content"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "content")
            }
          }

          /// The id of the Conversation this message belongs to. This is the table primary key.
          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          /// The message timestamp. This is also the table sort key.
          public var createdAt: Int? {
            get {
              return snapshot["createdAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// Generated id for a message -- read-only
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          /// Flag denoting if this message has been accepted by the server or not.
          public var isSent: Bool? {
            get {
              return snapshot["isSent"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isSent")
            }
          }

          public var sender: String? {
            get {
              return snapshot["sender"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "sender")
            }
          }
        }
      }
    }
  }
}

public final class MeQuery: GraphQLQuery {
  public static let operationString =
    "query Me {\n  me {\n    __typename\n    userId\n    conversations {\n      __typename\n      nextToken\n      userConversations {\n        __typename\n        conversationId\n        userId\n      }\n    }\n    messages {\n      __typename\n      messages {\n        __typename\n        content\n        conversationId\n        createdAt\n        id\n        isSent\n        sender\n      }\n      nextToken\n    }\n    registered\n    firstName\n    lastName\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("me", type: .object(Me.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(me: Me? = nil) {
      self.init(snapshot: ["__typename": "Query", "me": me.flatMap { $0.snapshot }])
    }

    /// Get my user.
    public var me: Me? {
      get {
        return (snapshot["me"] as? Snapshot).flatMap { Me(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "me")
      }
    }

    public struct Me: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("userId", type: .nonNull(.scalar(String.self))),
        GraphQLField("conversations", type: .object(Conversation.selections)),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("registered", type: .scalar(Bool.self)),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
        self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var userId: String {
        get {
          return snapshot["userId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "userId")
        }
      }

      /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
      public var conversations: Conversation? {
        get {
          return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
        }
      }

      /// Get a users messages by querying a GSI on the Messages table.
      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      /// is the user registered?
      public var registered: Bool? {
        get {
          return snapshot["registered"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "registered")
        }
      }

      /// First name of the user
      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      /// Last name of the user
      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public struct Conversation: GraphQLSelectionSet {
        public static let possibleTypes = ["UserConverstationsConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
          GraphQLField("userConversations", type: .list(.object(UserConversation.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil, userConversations: [UserConversation?]? = nil) {
          self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken, "userConversations": userConversations.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public var userConversations: [UserConversation?]? {
          get {
            return (snapshot["userConversations"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { UserConversation(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "userConversations")
          }
        }

        public struct UserConversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConversations"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(conversationId: GraphQLID, userId: GraphQLID) {
            self.init(snapshot: ["__typename": "UserConversations", "conversationId": conversationId, "userId": userId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          public var userId: GraphQLID {
            get {
              return snapshot["userId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["MessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("messages", type: .list(.object(Message.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(messages: [Message?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "MessageConnection", "messages": messages.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var messages: [Message?]? {
          get {
            return (snapshot["messages"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Message(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "messages")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["Message"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("content", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("createdAt", type: .scalar(Int.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("isSent", type: .scalar(Bool.self)),
            GraphQLField("sender", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, sender: String? = nil) {
            self.init(snapshot: ["__typename": "Message", "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "sender": sender])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The message content.
          public var content: String {
            get {
              return snapshot["content"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "content")
            }
          }

          /// The id of the Conversation this message belongs to. This is the table primary key.
          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          /// The message timestamp. This is also the table sort key.
          public var createdAt: Int? {
            get {
              return snapshot["createdAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// Generated id for a message -- read-only
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          /// Flag denoting if this message has been accepted by the server or not.
          public var isSent: Bool? {
            get {
              return snapshot["isSent"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isSent")
            }
          }

          public var sender: String? {
            get {
              return snapshot["sender"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "sender")
            }
          }
        }
      }
    }
  }
}

public final class ConversationFromIdQuery: GraphQLQuery {
  public static let operationString =
    "query ConversationFromId($conversationId: String!) {\n  conversationFromId(conversationId: $conversationId) {\n    __typename\n    createdAt\n    id\n    discoveryId\n    messages {\n      __typename\n      messages {\n        __typename\n        content\n        conversationId\n        createdAt\n        id\n        isSent\n        sender\n      }\n      nextToken\n    }\n    latestMessage {\n      __typename\n      author {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n      content\n      conversationId\n      createdAt\n      id\n      isSent\n      recipient {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n      sender\n    }\n    discovery {\n      __typename\n      discoveryId\n      active\n      cognitoUserName\n      description\n      price\n      request_or_offer\n      time\n      title\n      image_0\n      image_1\n      image_2\n      image_3\n      image_4\n      image_5\n      author {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n    }\n  }\n}"

  public var conversationId: String

  public init(conversationId: String) {
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("conversationFromId", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .object(ConversationFromId.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(conversationFromId: ConversationFromId? = nil) {
      self.init(snapshot: ["__typename": "Query", "conversationFromId": conversationFromId.flatMap { $0.snapshot }])
    }

    public var conversationFromId: ConversationFromId? {
      get {
        return (snapshot["conversationFromId"] as? Snapshot).flatMap { ConversationFromId(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "conversationFromId")
      }
    }

    public struct ConversationFromId: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .scalar(Int.self)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("latestMessage", type: .object(LatestMessage.selections)),
        GraphQLField("discovery", type: .object(Discovery.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(createdAt: Int? = nil, id: GraphQLID, discoveryId: String, messages: Message? = nil, latestMessage: LatestMessage? = nil, discovery: Discovery? = nil) {
        self.init(snapshot: ["__typename": "Conversation", "createdAt": createdAt, "id": id, "discoveryId": discoveryId, "messages": messages.flatMap { $0.snapshot }, "latestMessage": latestMessage.flatMap { $0.snapshot }, "discovery": discovery.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The Conversation's timestamp.
      public var createdAt: Int? {
        get {
          return snapshot["createdAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      /// A unique identifier for the Conversation.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// The Conversation's discoveryId. (formerly known as name)
      public var discoveryId: String {
        get {
          return snapshot["discoveryId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "discoveryId")
        }
      }

      /// The Conversation's messages.
      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      /// Latest message of a conversation
      public var latestMessage: LatestMessage? {
        get {
          return (snapshot["latestMessage"] as? Snapshot).flatMap { LatestMessage(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "latestMessage")
        }
      }

      /// Discovery related to the conversation
      public var discovery: Discovery? {
        get {
          return (snapshot["discovery"] as? Snapshot).flatMap { Discovery(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "discovery")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["MessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("messages", type: .list(.object(Message.selections))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(messages: [Message?]? = nil, nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "MessageConnection", "messages": messages.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var messages: [Message?]? {
          get {
            return (snapshot["messages"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Message(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "messages")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["Message"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("content", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("createdAt", type: .scalar(Int.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("isSent", type: .scalar(Bool.self)),
            GraphQLField("sender", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, sender: String? = nil) {
            self.init(snapshot: ["__typename": "Message", "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "sender": sender])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The message content.
          public var content: String {
            get {
              return snapshot["content"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "content")
            }
          }

          /// The id of the Conversation this message belongs to. This is the table primary key.
          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          /// The message timestamp. This is also the table sort key.
          public var createdAt: Int? {
            get {
              return snapshot["createdAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// Generated id for a message -- read-only
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          /// Flag denoting if this message has been accepted by the server or not.
          public var isSent: Bool? {
            get {
              return snapshot["isSent"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isSent")
            }
          }

          public var sender: String? {
            get {
              return snapshot["sender"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "sender")
            }
          }
        }
      }

      public struct LatestMessage: GraphQLSelectionSet {
        public static let possibleTypes = ["Message"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("author", type: .object(Author.selections)),
          GraphQLField("content", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .scalar(Int.self)),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("isSent", type: .scalar(Bool.self)),
          GraphQLField("recipient", type: .object(Recipient.selections)),
          GraphQLField("sender", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(author: Author? = nil, content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, recipient: Recipient? = nil, sender: String? = nil) {
          self.init(snapshot: ["__typename": "Message", "author": author.flatMap { $0.snapshot }, "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "recipient": recipient.flatMap { $0.snapshot }, "sender": sender])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The author object. Note: `authorId` is only available because we list it in `extraAttributes` in `Conversation.messages`
        public var author: Author? {
          get {
            return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "author")
          }
        }

        /// The message content.
        public var content: String {
          get {
            return snapshot["content"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
          }
        }

        /// The id of the Conversation this message belongs to. This is the table primary key.
        public var conversationId: GraphQLID {
          get {
            return snapshot["conversationId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "conversationId")
          }
        }

        /// The message timestamp. This is also the table sort key.
        public var createdAt: Int? {
          get {
            return snapshot["createdAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        /// Generated id for a message -- read-only
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// Flag denoting if this message has been accepted by the server or not.
        public var isSent: Bool? {
          get {
            return snapshot["isSent"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "isSent")
          }
        }

        public var recipient: Recipient? {
          get {
            return (snapshot["recipient"] as? Snapshot).flatMap { Recipient(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "recipient")
          }
        }

        public var sender: String? {
          get {
            return snapshot["sender"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "sender")
          }
        }

        public struct Author: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }

        public struct Recipient: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }
      }

      public struct Discovery: GraphQLSelectionSet {
        public static let possibleTypes = ["Discovery"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
          GraphQLField("active", type: .scalar(Bool.self)),
          GraphQLField("cognitoUserName", type: .scalar(String.self)),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("price", type: .scalar(Int.self)),
          GraphQLField("request_or_offer", type: .nonNull(.scalar(String.self))),
          GraphQLField("time", type: .scalar(Int.self)),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("image_0", type: .scalar(String.self)),
          GraphQLField("image_1", type: .scalar(String.self)),
          GraphQLField("image_2", type: .scalar(String.self)),
          GraphQLField("image_3", type: .scalar(String.self)),
          GraphQLField("image_4", type: .scalar(String.self)),
          GraphQLField("image_5", type: .scalar(String.self)),
          GraphQLField("author", type: .object(Author.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(discoveryId: String, active: Bool? = nil, cognitoUserName: String? = nil, description: String? = nil, price: Int? = nil, requestOrOffer: String, time: Int? = nil, title: String? = nil, image_0: String? = nil, image_1: String? = nil, image_2: String? = nil, image_3: String? = nil, image_4: String? = nil, image_5: String? = nil, author: Author? = nil) {
          self.init(snapshot: ["__typename": "Discovery", "discoveryId": discoveryId, "active": active, "cognitoUserName": cognitoUserName, "description": description, "price": price, "request_or_offer": requestOrOffer, "time": time, "title": title, "image_0": image_0, "image_1": image_1, "image_2": image_2, "image_3": image_3, "image_4": image_4, "image_5": image_5, "author": author.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// id of the discovery
        public var discoveryId: String {
          get {
            return snapshot["discoveryId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "discoveryId")
          }
        }

        /// Whether this discovery is on the network or not
        public var active: Bool? {
          get {
            return snapshot["active"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "active")
          }
        }

        /// Username of the owner, same thing as cognitoId
        public var cognitoUserName: String? {
          get {
            return snapshot["cognitoUserName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "cognitoUserName")
          }
        }

        /// Description of the discovery
        public var description: String? {
          get {
            return snapshot["description"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        /// Price of the discovery
        public var price: Int? {
          get {
            return snapshot["price"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "price")
          }
        }

        /// Is this a request or an offer
        public var requestOrOffer: String {
          get {
            return snapshot["request_or_offer"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "request_or_offer")
          }
        }

        /// When this discovery was created, seconds from epoch
        public var time: Int? {
          get {
            return snapshot["time"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "time")
          }
        }

        /// Title of the discovery
        public var title: String? {
          get {
            return snapshot["title"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        /// image 1
        public var image_0: String? {
          get {
            return snapshot["image_0"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_0")
          }
        }

        /// image 2
        public var image_1: String? {
          get {
            return snapshot["image_1"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_1")
          }
        }

        /// image 3
        public var image_2: String? {
          get {
            return snapshot["image_2"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_2")
          }
        }

        /// image 4
        public var image_3: String? {
          get {
            return snapshot["image_3"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_3")
          }
        }

        /// image 5
        public var image_4: String? {
          get {
            return snapshot["image_4"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_4")
          }
        }

        /// image 5
        public var image_5: String? {
          get {
            return snapshot["image_5"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "image_5")
          }
        }

        /// Author of this discovery
        public var author: Author? {
          get {
            return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "author")
          }
        }

        public struct Author: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }
      }
    }
  }
}

public final class AllAssociatedQuery: GraphQLQuery {
  public static let operationString =
    "query AllAssociated($conversationId: String!) {\n  allAssociated(conversationId: $conversationId) {\n    __typename\n    associated {\n      __typename\n      associated {\n        __typename\n        conversationId\n        userId\n      }\n      conversation {\n        __typename\n        createdAt\n        id\n        discoveryId\n      }\n      conversationId\n      user {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n      userId\n    }\n    conversation {\n      __typename\n      createdAt\n      id\n      discoveryId\n      messages {\n        __typename\n        nextToken\n      }\n      latestMessage {\n        __typename\n        content\n        conversationId\n        createdAt\n        id\n        isSent\n        sender\n      }\n      discovery {\n        __typename\n        discoveryId\n        active\n        cognitoUserName\n        description\n        price\n        request_or_offer\n        time\n        title\n        image_0\n        image_1\n        image_2\n        image_3\n        image_4\n        image_5\n      }\n    }\n    conversationId\n    user {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    userId\n  }\n}"

  public var conversationId: String

  public init(conversationId: String) {
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("allAssociated", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .list(.object(AllAssociated.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(allAssociated: [AllAssociated?]? = nil) {
      self.init(snapshot: ["__typename": "Query", "allAssociated": allAssociated.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
    }

    public var allAssociated: [AllAssociated?]? {
      get {
        return (snapshot["allAssociated"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { AllAssociated(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "allAssociated")
      }
    }

    public struct AllAssociated: GraphQLSelectionSet {
      public static let possibleTypes = ["UserConversations"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("associated", type: .list(.object(Associated.selections))),
        GraphQLField("conversation", type: .object(Conversation.selections)),
        GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(associated: [Associated?]? = nil, conversation: Conversation? = nil, conversationId: GraphQLID, user: User? = nil, userId: GraphQLID) {
        self.init(snapshot: ["__typename": "UserConversations", "associated": associated.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "conversation": conversation.flatMap { $0.snapshot }, "conversationId": conversationId, "user": user.flatMap { $0.snapshot }, "userId": userId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var associated: [Associated?]? {
        get {
          return (snapshot["associated"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Associated(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "associated")
        }
      }

      public var conversation: Conversation? {
        get {
          return (snapshot["conversation"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "conversation")
        }
      }

      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationId")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userId")
        }
      }

      public struct Associated: GraphQLSelectionSet {
        public static let possibleTypes = ["UserConversations"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("associated", type: .list(.object(Associated.selections))),
          GraphQLField("conversation", type: .object(Conversation.selections)),
          GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("user", type: .object(User.selections)),
          GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(associated: [Associated?]? = nil, conversation: Conversation? = nil, conversationId: GraphQLID, user: User? = nil, userId: GraphQLID) {
          self.init(snapshot: ["__typename": "UserConversations", "associated": associated.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "conversation": conversation.flatMap { $0.snapshot }, "conversationId": conversationId, "user": user.flatMap { $0.snapshot }, "userId": userId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var associated: [Associated?]? {
          get {
            return (snapshot["associated"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Associated(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "associated")
          }
        }

        public var conversation: Conversation? {
          get {
            return (snapshot["conversation"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversation")
          }
        }

        public var conversationId: GraphQLID {
          get {
            return snapshot["conversationId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "conversationId")
          }
        }

        public var user: User? {
          get {
            return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "user")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        public struct Associated: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConversations"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(conversationId: GraphQLID, userId: GraphQLID) {
            self.init(snapshot: ["__typename": "UserConversations", "conversationId": conversationId, "userId": userId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          public var userId: GraphQLID {
            get {
              return snapshot["userId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["Conversation"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .scalar(Int.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(createdAt: Int? = nil, id: GraphQLID, discoveryId: String) {
            self.init(snapshot: ["__typename": "Conversation", "createdAt": createdAt, "id": id, "discoveryId": discoveryId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The Conversation's timestamp.
          public var createdAt: Int? {
            get {
              return snapshot["createdAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// A unique identifier for the Conversation.
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          /// The Conversation's discoveryId. (formerly known as name)
          public var discoveryId: String {
            get {
              return snapshot["discoveryId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "discoveryId")
            }
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }
      }

      public struct Conversation: GraphQLSelectionSet {
        public static let possibleTypes = ["Conversation"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .scalar(Int.self)),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("latestMessage", type: .object(LatestMessage.selections)),
          GraphQLField("discovery", type: .object(Discovery.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(createdAt: Int? = nil, id: GraphQLID, discoveryId: String, messages: Message? = nil, latestMessage: LatestMessage? = nil, discovery: Discovery? = nil) {
          self.init(snapshot: ["__typename": "Conversation", "createdAt": createdAt, "id": id, "discoveryId": discoveryId, "messages": messages.flatMap { $0.snapshot }, "latestMessage": latestMessage.flatMap { $0.snapshot }, "discovery": discovery.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The Conversation's timestamp.
        public var createdAt: Int? {
          get {
            return snapshot["createdAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        /// A unique identifier for the Conversation.
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// The Conversation's discoveryId. (formerly known as name)
        public var discoveryId: String {
          get {
            return snapshot["discoveryId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "discoveryId")
          }
        }

        /// The Conversation's messages.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// Latest message of a conversation
        public var latestMessage: LatestMessage? {
          get {
            return (snapshot["latestMessage"] as? Snapshot).flatMap { LatestMessage(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "latestMessage")
          }
        }

        /// Discovery related to the conversation
        public var discovery: Discovery? {
          get {
            return (snapshot["discovery"] as? Snapshot).flatMap { Discovery(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "discovery")
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct LatestMessage: GraphQLSelectionSet {
          public static let possibleTypes = ["Message"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("content", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("createdAt", type: .scalar(Int.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("isSent", type: .scalar(Bool.self)),
            GraphQLField("sender", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, sender: String? = nil) {
            self.init(snapshot: ["__typename": "Message", "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "sender": sender])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The message content.
          public var content: String {
            get {
              return snapshot["content"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "content")
            }
          }

          /// The id of the Conversation this message belongs to. This is the table primary key.
          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          /// The message timestamp. This is also the table sort key.
          public var createdAt: Int? {
            get {
              return snapshot["createdAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// Generated id for a message -- read-only
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          /// Flag denoting if this message has been accepted by the server or not.
          public var isSent: Bool? {
            get {
              return snapshot["isSent"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isSent")
            }
          }

          public var sender: String? {
            get {
              return snapshot["sender"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "sender")
            }
          }
        }

        public struct Discovery: GraphQLSelectionSet {
          public static let possibleTypes = ["Discovery"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
            GraphQLField("active", type: .scalar(Bool.self)),
            GraphQLField("cognitoUserName", type: .scalar(String.self)),
            GraphQLField("description", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(Int.self)),
            GraphQLField("request_or_offer", type: .nonNull(.scalar(String.self))),
            GraphQLField("time", type: .scalar(Int.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("image_0", type: .scalar(String.self)),
            GraphQLField("image_1", type: .scalar(String.self)),
            GraphQLField("image_2", type: .scalar(String.self)),
            GraphQLField("image_3", type: .scalar(String.self)),
            GraphQLField("image_4", type: .scalar(String.self)),
            GraphQLField("image_5", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(discoveryId: String, active: Bool? = nil, cognitoUserName: String? = nil, description: String? = nil, price: Int? = nil, requestOrOffer: String, time: Int? = nil, title: String? = nil, image_0: String? = nil, image_1: String? = nil, image_2: String? = nil, image_3: String? = nil, image_4: String? = nil, image_5: String? = nil) {
            self.init(snapshot: ["__typename": "Discovery", "discoveryId": discoveryId, "active": active, "cognitoUserName": cognitoUserName, "description": description, "price": price, "request_or_offer": requestOrOffer, "time": time, "title": title, "image_0": image_0, "image_1": image_1, "image_2": image_2, "image_3": image_3, "image_4": image_4, "image_5": image_5])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// id of the discovery
          public var discoveryId: String {
            get {
              return snapshot["discoveryId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "discoveryId")
            }
          }

          /// Whether this discovery is on the network or not
          public var active: Bool? {
            get {
              return snapshot["active"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "active")
            }
          }

          /// Username of the owner, same thing as cognitoId
          public var cognitoUserName: String? {
            get {
              return snapshot["cognitoUserName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "cognitoUserName")
            }
          }

          /// Description of the discovery
          public var description: String? {
            get {
              return snapshot["description"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "description")
            }
          }

          /// Price of the discovery
          public var price: Int? {
            get {
              return snapshot["price"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          /// Is this a request or an offer
          public var requestOrOffer: String {
            get {
              return snapshot["request_or_offer"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "request_or_offer")
            }
          }

          /// When this discovery was created, seconds from epoch
          public var time: Int? {
            get {
              return snapshot["time"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "time")
            }
          }

          /// Title of the discovery
          public var title: String? {
            get {
              return snapshot["title"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "title")
            }
          }

          /// image 1
          public var image_0: String? {
            get {
              return snapshot["image_0"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_0")
            }
          }

          /// image 2
          public var image_1: String? {
            get {
              return snapshot["image_1"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_1")
            }
          }

          /// image 3
          public var image_2: String? {
            get {
              return snapshot["image_2"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_2")
            }
          }

          /// image 4
          public var image_3: String? {
            get {
              return snapshot["image_3"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_3")
            }
          }

          /// image 5
          public var image_4: String? {
            get {
              return snapshot["image_4"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_4")
            }
          }

          /// image 5
          public var image_5: String? {
            get {
              return snapshot["image_5"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_5")
            }
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class DiscoveryQuery: GraphQLQuery {
  public static let operationString =
    "query Discovery($discoveryId: String!) {\n  discovery(discoveryId: $discoveryId) {\n    __typename\n    discoveryId\n    active\n    cognitoUserName\n    description\n    price\n    request_or_offer\n    time\n    title\n    image_0\n    image_1\n    image_2\n    image_3\n    image_4\n    image_5\n    author {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n  }\n}"

  public var discoveryId: String

  public init(discoveryId: String) {
    self.discoveryId = discoveryId
  }

  public var variables: GraphQLMap? {
    return ["discoveryId": discoveryId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("discovery", arguments: ["discoveryId": GraphQLVariable("discoveryId")], type: .object(Discovery.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(discovery: Discovery? = nil) {
      self.init(snapshot: ["__typename": "Query", "discovery": discovery.flatMap { $0.snapshot }])
    }

    public var discovery: Discovery? {
      get {
        return (snapshot["discovery"] as? Snapshot).flatMap { Discovery(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "discovery")
      }
    }

    public struct Discovery: GraphQLSelectionSet {
      public static let possibleTypes = ["Discovery"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
        GraphQLField("active", type: .scalar(Bool.self)),
        GraphQLField("cognitoUserName", type: .scalar(String.self)),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("price", type: .scalar(Int.self)),
        GraphQLField("request_or_offer", type: .nonNull(.scalar(String.self))),
        GraphQLField("time", type: .scalar(Int.self)),
        GraphQLField("title", type: .scalar(String.self)),
        GraphQLField("image_0", type: .scalar(String.self)),
        GraphQLField("image_1", type: .scalar(String.self)),
        GraphQLField("image_2", type: .scalar(String.self)),
        GraphQLField("image_3", type: .scalar(String.self)),
        GraphQLField("image_4", type: .scalar(String.self)),
        GraphQLField("image_5", type: .scalar(String.self)),
        GraphQLField("author", type: .object(Author.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(discoveryId: String, active: Bool? = nil, cognitoUserName: String? = nil, description: String? = nil, price: Int? = nil, requestOrOffer: String, time: Int? = nil, title: String? = nil, image_0: String? = nil, image_1: String? = nil, image_2: String? = nil, image_3: String? = nil, image_4: String? = nil, image_5: String? = nil, author: Author? = nil) {
        self.init(snapshot: ["__typename": "Discovery", "discoveryId": discoveryId, "active": active, "cognitoUserName": cognitoUserName, "description": description, "price": price, "request_or_offer": requestOrOffer, "time": time, "title": title, "image_0": image_0, "image_1": image_1, "image_2": image_2, "image_3": image_3, "image_4": image_4, "image_5": image_5, "author": author.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// id of the discovery
      public var discoveryId: String {
        get {
          return snapshot["discoveryId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "discoveryId")
        }
      }

      /// Whether this discovery is on the network or not
      public var active: Bool? {
        get {
          return snapshot["active"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "active")
        }
      }

      /// Username of the owner, same thing as cognitoId
      public var cognitoUserName: String? {
        get {
          return snapshot["cognitoUserName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "cognitoUserName")
        }
      }

      /// Description of the discovery
      public var description: String? {
        get {
          return snapshot["description"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      /// Price of the discovery
      public var price: Int? {
        get {
          return snapshot["price"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "price")
        }
      }

      /// Is this a request or an offer
      public var requestOrOffer: String {
        get {
          return snapshot["request_or_offer"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "request_or_offer")
        }
      }

      /// When this discovery was created, seconds from epoch
      public var time: Int? {
        get {
          return snapshot["time"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "time")
        }
      }

      /// Title of the discovery
      public var title: String? {
        get {
          return snapshot["title"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      /// image 1
      public var image_0: String? {
        get {
          return snapshot["image_0"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "image_0")
        }
      }

      /// image 2
      public var image_1: String? {
        get {
          return snapshot["image_1"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "image_1")
        }
      }

      /// image 3
      public var image_2: String? {
        get {
          return snapshot["image_2"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "image_2")
        }
      }

      /// image 4
      public var image_3: String? {
        get {
          return snapshot["image_3"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "image_3")
        }
      }

      /// image 5
      public var image_4: String? {
        get {
          return snapshot["image_4"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "image_4")
        }
      }

      /// image 5
      public var image_5: String? {
        get {
          return snapshot["image_5"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "image_5")
        }
      }

      /// Author of this discovery
      public var author: Author? {
        get {
          return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "author")
        }
      }

      public struct Author: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class SubscribeToNewMessageSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription SubscribeToNewMessage($conversationId: ID!) {\n  subscribeToNewMessage(conversationId: $conversationId) {\n    __typename\n    author {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    content\n    conversationId\n    createdAt\n    id\n    isSent\n    recipient {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    sender\n  }\n}"

  public var conversationId: GraphQLID

  public init(conversationId: GraphQLID) {
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("subscribeToNewMessage", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .object(SubscribeToNewMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(subscribeToNewMessage: SubscribeToNewMessage? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "subscribeToNewMessage": subscribeToNewMessage.flatMap { $0.snapshot }])
    }

    /// Subscribes to all new messages in a given Conversation.
    public var subscribeToNewMessage: SubscribeToNewMessage? {
      get {
        return (snapshot["subscribeToNewMessage"] as? Snapshot).flatMap { SubscribeToNewMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "subscribeToNewMessage")
      }
    }

    public struct SubscribeToNewMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("author", type: .object(Author.selections)),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .scalar(Int.self)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("isSent", type: .scalar(Bool.self)),
        GraphQLField("recipient", type: .object(Recipient.selections)),
        GraphQLField("sender", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(author: Author? = nil, content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, recipient: Recipient? = nil, sender: String? = nil) {
        self.init(snapshot: ["__typename": "Message", "author": author.flatMap { $0.snapshot }, "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "recipient": recipient.flatMap { $0.snapshot }, "sender": sender])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The author object. Note: `authorId` is only available because we list it in `extraAttributes` in `Conversation.messages`
      public var author: Author? {
        get {
          return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "author")
        }
      }

      /// The message content.
      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      /// The id of the Conversation this message belongs to. This is the table primary key.
      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationId")
        }
      }

      /// The message timestamp. This is also the table sort key.
      public var createdAt: Int? {
        get {
          return snapshot["createdAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      /// Generated id for a message -- read-only
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// Flag denoting if this message has been accepted by the server or not.
      public var isSent: Bool? {
        get {
          return snapshot["isSent"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "isSent")
        }
      }

      public var recipient: Recipient? {
        get {
          return (snapshot["recipient"] as? Snapshot).flatMap { Recipient(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "recipient")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public struct Author: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }

      public struct Recipient: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}

public final class SubscribeToNewUCsSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription SubscribeToNewUCs($userId: ID!) {\n  subscribeToNewUCs(userId: $userId) {\n    __typename\n    associated {\n      __typename\n      associated {\n        __typename\n        conversationId\n        userId\n      }\n      conversation {\n        __typename\n        createdAt\n        id\n        discoveryId\n      }\n      conversationId\n      user {\n        __typename\n        userId\n        registered\n        firstName\n        lastName\n      }\n      userId\n    }\n    conversation {\n      __typename\n      createdAt\n      id\n      discoveryId\n      messages {\n        __typename\n        nextToken\n      }\n      latestMessage {\n        __typename\n        content\n        conversationId\n        createdAt\n        id\n        isSent\n        sender\n      }\n      discovery {\n        __typename\n        discoveryId\n        active\n        cognitoUserName\n        description\n        price\n        request_or_offer\n        time\n        title\n        image_0\n        image_1\n        image_2\n        image_3\n        image_4\n        image_5\n      }\n    }\n    conversationId\n    user {\n      __typename\n      userId\n      conversations {\n        __typename\n        nextToken\n      }\n      messages {\n        __typename\n        nextToken\n      }\n      registered\n      firstName\n      lastName\n    }\n    userId\n  }\n}"

  public var userId: GraphQLID

  public init(userId: GraphQLID) {
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("subscribeToNewUCs", arguments: ["userId": GraphQLVariable("userId")], type: .object(SubscribeToNewUc.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(subscribeToNewUCs: SubscribeToNewUc? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "subscribeToNewUCs": subscribeToNewUCs.flatMap { $0.snapshot }])
    }

    /// Subscribe to a convo, if someone replies to your discovery
    public var subscribeToNewUCs: SubscribeToNewUc? {
      get {
        return (snapshot["subscribeToNewUCs"] as? Snapshot).flatMap { SubscribeToNewUc(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "subscribeToNewUCs")
      }
    }

    public struct SubscribeToNewUc: GraphQLSelectionSet {
      public static let possibleTypes = ["UserConversations"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("associated", type: .list(.object(Associated.selections))),
        GraphQLField("conversation", type: .object(Conversation.selections)),
        GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(associated: [Associated?]? = nil, conversation: Conversation? = nil, conversationId: GraphQLID, user: User? = nil, userId: GraphQLID) {
        self.init(snapshot: ["__typename": "UserConversations", "associated": associated.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "conversation": conversation.flatMap { $0.snapshot }, "conversationId": conversationId, "user": user.flatMap { $0.snapshot }, "userId": userId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var associated: [Associated?]? {
        get {
          return (snapshot["associated"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Associated(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "associated")
        }
      }

      public var conversation: Conversation? {
        get {
          return (snapshot["conversation"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "conversation")
        }
      }

      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationId")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userId")
        }
      }

      public struct Associated: GraphQLSelectionSet {
        public static let possibleTypes = ["UserConversations"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("associated", type: .list(.object(Associated.selections))),
          GraphQLField("conversation", type: .object(Conversation.selections)),
          GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("user", type: .object(User.selections)),
          GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(associated: [Associated?]? = nil, conversation: Conversation? = nil, conversationId: GraphQLID, user: User? = nil, userId: GraphQLID) {
          self.init(snapshot: ["__typename": "UserConversations", "associated": associated.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "conversation": conversation.flatMap { $0.snapshot }, "conversationId": conversationId, "user": user.flatMap { $0.snapshot }, "userId": userId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var associated: [Associated?]? {
          get {
            return (snapshot["associated"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Associated(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "associated")
          }
        }

        public var conversation: Conversation? {
          get {
            return (snapshot["conversation"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversation")
          }
        }

        public var conversationId: GraphQLID {
          get {
            return snapshot["conversationId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "conversationId")
          }
        }

        public var user: User? {
          get {
            return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "user")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        public struct Associated: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConversations"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(conversationId: GraphQLID, userId: GraphQLID) {
            self.init(snapshot: ["__typename": "UserConversations", "conversationId": conversationId, "userId": userId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          public var userId: GraphQLID {
            get {
              return snapshot["userId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["Conversation"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .scalar(Int.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(createdAt: Int? = nil, id: GraphQLID, discoveryId: String) {
            self.init(snapshot: ["__typename": "Conversation", "createdAt": createdAt, "id": id, "discoveryId": discoveryId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The Conversation's timestamp.
          public var createdAt: Int? {
            get {
              return snapshot["createdAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// A unique identifier for the Conversation.
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          /// The Conversation's discoveryId. (formerly known as name)
          public var discoveryId: String {
            get {
              return snapshot["discoveryId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "discoveryId")
            }
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("registered", type: .scalar(Bool.self)),
            GraphQLField("firstName", type: .scalar(String.self)),
            GraphQLField("lastName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: String, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
            self.init(snapshot: ["__typename": "User", "userId": userId, "registered": registered, "firstName": firstName, "lastName": lastName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return snapshot["userId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          /// is the user registered?
          public var registered: Bool? {
            get {
              return snapshot["registered"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "registered")
            }
          }

          /// First name of the user
          public var firstName: String? {
            get {
              return snapshot["firstName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "firstName")
            }
          }

          /// Last name of the user
          public var lastName: String? {
            get {
              return snapshot["lastName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lastName")
            }
          }
        }
      }

      public struct Conversation: GraphQLSelectionSet {
        public static let possibleTypes = ["Conversation"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .scalar(Int.self)),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("latestMessage", type: .object(LatestMessage.selections)),
          GraphQLField("discovery", type: .object(Discovery.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(createdAt: Int? = nil, id: GraphQLID, discoveryId: String, messages: Message? = nil, latestMessage: LatestMessage? = nil, discovery: Discovery? = nil) {
          self.init(snapshot: ["__typename": "Conversation", "createdAt": createdAt, "id": id, "discoveryId": discoveryId, "messages": messages.flatMap { $0.snapshot }, "latestMessage": latestMessage.flatMap { $0.snapshot }, "discovery": discovery.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The Conversation's timestamp.
        public var createdAt: Int? {
          get {
            return snapshot["createdAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        /// A unique identifier for the Conversation.
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// The Conversation's discoveryId. (formerly known as name)
        public var discoveryId: String {
          get {
            return snapshot["discoveryId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "discoveryId")
          }
        }

        /// The Conversation's messages.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// Latest message of a conversation
        public var latestMessage: LatestMessage? {
          get {
            return (snapshot["latestMessage"] as? Snapshot).flatMap { LatestMessage(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "latestMessage")
          }
        }

        /// Discovery related to the conversation
        public var discovery: Discovery? {
          get {
            return (snapshot["discovery"] as? Snapshot).flatMap { Discovery(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "discovery")
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct LatestMessage: GraphQLSelectionSet {
          public static let possibleTypes = ["Message"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("content", type: .nonNull(.scalar(String.self))),
            GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("createdAt", type: .scalar(Int.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("isSent", type: .scalar(Bool.self)),
            GraphQLField("sender", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, sender: String? = nil) {
            self.init(snapshot: ["__typename": "Message", "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "sender": sender])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The message content.
          public var content: String {
            get {
              return snapshot["content"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "content")
            }
          }

          /// The id of the Conversation this message belongs to. This is the table primary key.
          public var conversationId: GraphQLID {
            get {
              return snapshot["conversationId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "conversationId")
            }
          }

          /// The message timestamp. This is also the table sort key.
          public var createdAt: Int? {
            get {
              return snapshot["createdAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// Generated id for a message -- read-only
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          /// Flag denoting if this message has been accepted by the server or not.
          public var isSent: Bool? {
            get {
              return snapshot["isSent"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isSent")
            }
          }

          public var sender: String? {
            get {
              return snapshot["sender"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "sender")
            }
          }
        }

        public struct Discovery: GraphQLSelectionSet {
          public static let possibleTypes = ["Discovery"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("discoveryId", type: .nonNull(.scalar(String.self))),
            GraphQLField("active", type: .scalar(Bool.self)),
            GraphQLField("cognitoUserName", type: .scalar(String.self)),
            GraphQLField("description", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(Int.self)),
            GraphQLField("request_or_offer", type: .nonNull(.scalar(String.self))),
            GraphQLField("time", type: .scalar(Int.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("image_0", type: .scalar(String.self)),
            GraphQLField("image_1", type: .scalar(String.self)),
            GraphQLField("image_2", type: .scalar(String.self)),
            GraphQLField("image_3", type: .scalar(String.self)),
            GraphQLField("image_4", type: .scalar(String.self)),
            GraphQLField("image_5", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(discoveryId: String, active: Bool? = nil, cognitoUserName: String? = nil, description: String? = nil, price: Int? = nil, requestOrOffer: String, time: Int? = nil, title: String? = nil, image_0: String? = nil, image_1: String? = nil, image_2: String? = nil, image_3: String? = nil, image_4: String? = nil, image_5: String? = nil) {
            self.init(snapshot: ["__typename": "Discovery", "discoveryId": discoveryId, "active": active, "cognitoUserName": cognitoUserName, "description": description, "price": price, "request_or_offer": requestOrOffer, "time": time, "title": title, "image_0": image_0, "image_1": image_1, "image_2": image_2, "image_3": image_3, "image_4": image_4, "image_5": image_5])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// id of the discovery
          public var discoveryId: String {
            get {
              return snapshot["discoveryId"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "discoveryId")
            }
          }

          /// Whether this discovery is on the network or not
          public var active: Bool? {
            get {
              return snapshot["active"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "active")
            }
          }

          /// Username of the owner, same thing as cognitoId
          public var cognitoUserName: String? {
            get {
              return snapshot["cognitoUserName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "cognitoUserName")
            }
          }

          /// Description of the discovery
          public var description: String? {
            get {
              return snapshot["description"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "description")
            }
          }

          /// Price of the discovery
          public var price: Int? {
            get {
              return snapshot["price"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          /// Is this a request or an offer
          public var requestOrOffer: String {
            get {
              return snapshot["request_or_offer"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "request_or_offer")
            }
          }

          /// When this discovery was created, seconds from epoch
          public var time: Int? {
            get {
              return snapshot["time"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "time")
            }
          }

          /// Title of the discovery
          public var title: String? {
            get {
              return snapshot["title"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "title")
            }
          }

          /// image 1
          public var image_0: String? {
            get {
              return snapshot["image_0"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_0")
            }
          }

          /// image 2
          public var image_1: String? {
            get {
              return snapshot["image_1"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_1")
            }
          }

          /// image 3
          public var image_2: String? {
            get {
              return snapshot["image_2"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_2")
            }
          }

          /// image 4
          public var image_3: String? {
            get {
              return snapshot["image_3"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_3")
            }
          }

          /// image 5
          public var image_4: String? {
            get {
              return snapshot["image_4"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_4")
            }
          }

          /// image 5
          public var image_5: String? {
            get {
              return snapshot["image_5"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "image_5")
            }
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(String.self))),
          GraphQLField("conversations", type: .object(Conversation.selections)),
          GraphQLField("messages", type: .object(Message.selections)),
          GraphQLField("registered", type: .scalar(Bool.self)),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: String, conversations: Conversation? = nil, messages: Message? = nil, registered: Bool? = nil, firstName: String? = nil, lastName: String? = nil) {
          self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "registered": registered, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return snapshot["userId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
        public var conversations: Conversation? {
          get {
            return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
          }
        }

        /// Get a users messages by querying a GSI on the Messages table.
        public var messages: Message? {
          get {
            return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "messages")
          }
        }

        /// is the user registered?
        public var registered: Bool? {
          get {
            return snapshot["registered"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "registered")
          }
        }

        /// First name of the user
        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        /// Last name of the user
        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public struct Conversation: GraphQLSelectionSet {
          public static let possibleTypes = ["UserConverstationsConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes = ["MessageConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil) {
            self.init(snapshot: ["__typename": "MessageConnection", "nextToken": nextToken])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }
        }
      }
    }
  }
}