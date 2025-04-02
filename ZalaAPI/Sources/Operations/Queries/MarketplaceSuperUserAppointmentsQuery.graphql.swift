// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MarketplaceSuperUserAppointmentsQuery: GraphQLQuery {
  public static let operationName: String = "MarketplaceSuperUserAppointmentsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query MarketplaceSuperUserAppointmentsQuery($ids: [ID!], $status: [String!], $ordering: String!, $labels: [String!]) { organizations(ids: $ids) { __typename nodes { __typename id name services(status: $status, ordering: $ordering) { __typename ...MarketplaceAppointmentService } users(role: "provider") { __typename nodes { __typename id addresses { __typename ...AddressModel } } } } } }"#,
      fragments: [AddressModel.self, AttachmentModel.self, MarketplaceAppointmentService.self]
    ))

  public var ids: GraphQLNullable<[ID]>
  public var status: GraphQLNullable<[String]>
  public var ordering: String
  public var labels: GraphQLNullable<[String]>

  public init(
    ids: GraphQLNullable<[ID]>,
    status: GraphQLNullable<[String]>,
    ordering: String,
    labels: GraphQLNullable<[String]>
  ) {
    self.ids = ids
    self.status = status
    self.ordering = ordering
    self.labels = labels
  }

  public var __variables: Variables? { [
    "ids": ids,
    "status": status,
    "ordering": ordering,
    "labels": labels
  ] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("organizations", Organizations?.self, arguments: ["ids": .variable("ids")]),
    ] }

    public var organizations: Organizations? { __data["organizations"] }

    /// Organizations
    ///
    /// Parent Type: `OrganizationConnection`
    public struct Organizations: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.OrganizationConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("nodes", [Node?]?.self),
      ] }

      /// A list of nodes.
      public var nodes: [Node?]? { __data["nodes"] }

      /// Organizations.Node
      ///
      /// Parent Type: `Organization`
      public struct Node: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Organization }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
          .field("name", String?.self),
          .field("services", [Service]?.self, arguments: [
            "status": .variable("status"),
            "ordering": .variable("ordering")
          ]),
          .field("users", Users?.self, arguments: ["role": "provider"]),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var name: String? { __data["name"] }
        public var services: [Service]? { __data["services"] }
        public var users: Users? { __data["users"] }

        /// Organizations.Node.Service
        ///
        /// Parent Type: `Service`
        public struct Service: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Service }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(MarketplaceAppointmentService.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var attachments: [Attachment]? { __data["attachments"] }
          public var desc: String? { __data["desc"] }
          public var groupPrimary: Bool? { __data["groupPrimary"] }
          public var kind: String? { __data["kind"] }
          public var organizationId: ZalaAPI.ID? { __data["organizationId"] }
          public var status: String? { __data["status"] }
          public var title: String? { __data["title"] }
          public var durationMins: Int? { __data["durationMins"] }
          public var params: ZalaAPI.JSON? { __data["params"] }
          public var supportsVirtual: Bool? { __data["supportsVirtual"] }
          public var addresses: [Address] { __data["addresses"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var marketplaceAppointmentService: MarketplaceAppointmentService { _toFragment() }
          }

          public typealias Attachment = MarketplaceAppointmentService.Attachment

          public typealias Address = MarketplaceAppointmentService.Address
        }

        /// Organizations.Node.Users
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

          /// Organizations.Node.Users.Node
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

            /// Organizations.Node.Users.Node.Address
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
}
