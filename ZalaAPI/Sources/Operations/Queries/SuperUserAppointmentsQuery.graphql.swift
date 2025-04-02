// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SuperUserAppointmentsQuery: GraphQLQuery {
  public static let operationName: String = "SuperUserAppointmentsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SuperUserAppointmentsQuery($ids: [ID!]) { organizations(ids: $ids) { __typename nodes { __typename id name services(ordering: "status") { __typename ...ServiceModel } } } }"#,
      fragments: [AttachmentModel.self, ServiceModel.self]
    ))

  public var ids: GraphQLNullable<[ID]>

  public init(ids: GraphQLNullable<[ID]>) {
    self.ids = ids
  }

  public var __variables: Variables? { ["ids": ids] }

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
          .field("services", [Service]?.self, arguments: ["ordering": "status"]),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var name: String? { __data["name"] }
        public var services: [Service]? { __data["services"] }

        /// Organizations.Node.Service
        ///
        /// Parent Type: `Service`
        public struct Service: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Service }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(ServiceModel.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var attachments: [Attachment]? { __data["attachments"] }
          public var desc: String? { __data["desc"] }
          public var groupPrimary: Bool? { __data["groupPrimary"] }
          public var kind: String? { __data["kind"] }
          public var organizationId: ZalaAPI.ID? { __data["organizationId"] }
          public var status: String? { __data["status"] }
          public var title: String? { __data["title"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var serviceModel: ServiceModel { _toFragment() }
          }

          public typealias Attachment = ServiceModel.Attachment
        }
      }
    }
  }
}
