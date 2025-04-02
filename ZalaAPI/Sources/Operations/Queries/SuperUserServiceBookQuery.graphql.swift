// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SuperUserServiceBookQuery: GraphQLQuery {
  public static let operationName: String = "SuperUserServiceBookQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SuperUserServiceBookQuery($id: ID) { org(id: $id) { __typename id services { __typename id addresses { __typename id address } durationMins groupPrimary kind providers { __typename id attachments(labels: ["profile_picture"]) { __typename id label contentUrl } firstName lastName preferences { __typename id key value } } params supportsVirtual title } users(role: "provider") { __typename nodes { __typename id addresses { __typename ...AddressModel } } } } }"#,
      fragments: [AddressModel.self]
    ))

  public var id: GraphQLNullable<ID>

  public init(id: GraphQLNullable<ID>) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("org", Org?.self, arguments: ["id": .variable("id")]),
    ] }

    public var org: Org? { __data["org"] }

    /// Org
    ///
    /// Parent Type: `Organization`
    public struct Org: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Organization }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", ZalaAPI.ID?.self),
        .field("services", [Service]?.self),
        .field("users", Users?.self, arguments: ["role": "provider"]),
      ] }

      public var id: ZalaAPI.ID? { __data["id"] }
      public var services: [Service]? { __data["services"] }
      public var users: Users? { __data["users"] }

      /// Org.Service
      ///
      /// Parent Type: `Service`
      public struct Service: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Service }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
          .field("addresses", [Address].self),
          .field("durationMins", Int?.self),
          .field("groupPrimary", Bool?.self),
          .field("kind", String?.self),
          .field("providers", [Provider]?.self),
          .field("params", ZalaAPI.JSON?.self),
          .field("supportsVirtual", Bool?.self),
          .field("title", String?.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var addresses: [Address] { __data["addresses"] }
        public var durationMins: Int? { __data["durationMins"] }
        public var groupPrimary: Bool? { __data["groupPrimary"] }
        public var kind: String? { __data["kind"] }
        public var providers: [Provider]? { __data["providers"] }
        public var params: ZalaAPI.JSON? { __data["params"] }
        public var supportsVirtual: Bool? { __data["supportsVirtual"] }
        public var title: String? { __data["title"] }

        /// Org.Service.Address
        ///
        /// Parent Type: `AddressesStreet`
        public struct Address: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AddressesStreet }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZalaAPI.ID?.self),
            .field("address", String?.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var address: String? { __data["address"] }
        }

        /// Org.Service.Provider
        ///
        /// Parent Type: `Provider`
        public struct Provider: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Provider }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZalaAPI.ID?.self),
            .field("attachments", [Attachment]?.self, arguments: ["labels": ["profile_picture"]]),
            .field("firstName", String?.self),
            .field("lastName", String?.self),
            .field("preferences", [Preference]?.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var attachments: [Attachment]? { __data["attachments"] }
          public var firstName: String? { __data["firstName"] }
          public var lastName: String? { __data["lastName"] }
          /// User Preferences
          public var preferences: [Preference]? { __data["preferences"] }

          /// Org.Service.Provider.Attachment
          ///
          /// Parent Type: `Attachment`
          public struct Attachment: ZalaAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Attachment }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", ZalaAPI.ID?.self),
              .field("label", String?.self),
              .field("contentUrl", String?.self),
            ] }

            public var id: ZalaAPI.ID? { __data["id"] }
            public var label: String? { __data["label"] }
            public var contentUrl: String? { __data["contentUrl"] }
          }

          /// Org.Service.Provider.Preference
          ///
          /// Parent Type: `Preference`
          public struct Preference: ZalaAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Preference }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", ZalaAPI.ID?.self),
              .field("key", String?.self),
              .field("value", [String]?.self),
            ] }

            public var id: ZalaAPI.ID? { __data["id"] }
            public var key: String? { __data["key"] }
            public var value: [String]? { __data["value"] }
          }
        }
      }

      /// Org.Users
      ///
      /// Parent Type: `UserConnection`
      public struct Users: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Org.Users.Node
        ///
        /// Parent Type: `User`
        public struct Node: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZalaAPI.ID?.self),
            .field("addresses", [Address]?.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var addresses: [Address]? { __data["addresses"] }

          /// Org.Users.Node.Address
          ///
          /// Parent Type: `AddressesStreet`
          public struct Address: ZalaAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AddressesStreet }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(AddressModel.self),
            ] }

            public var id: ZalaAPI.ID? { __data["id"] }
            public var label: String? { __data["label"] }
            /// Street Address
            public var line1: String? { __data["line1"] }
            /// City, State ZIP
            public var line2: String? { __data["line2"] }
            public var state: String? { __data["state"] }
            public var city: String? { __data["city"] }
            public var zip: String? { __data["zip"] }
            public var address: String? { __data["address"] }
            /// City, State ZIP
            public var csz: String? { __data["csz"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var addressModel: AddressModel { _toFragment() }
            }
          }
        }
      }
    }
  }
}
