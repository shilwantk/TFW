// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SuperUsersQuery: GraphQLQuery {
  public static let operationName: String = "SuperUsersQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SuperUsersQuery($id: ID, $labels: [String!]) { org(id: $id) { __typename children { __typename ...SuperUserOrg } } }"#,
      fragments: [AttachmentModel.self, PreferenceModel.self, SuperUser.self, SuperUserOrg.self, UserRole.self]
    ))

  public var id: GraphQLNullable<ID>
  public var labels: GraphQLNullable<[String]>

  public init(
    id: GraphQLNullable<ID>,
    labels: GraphQLNullable<[String]>
  ) {
    self.id = id
    self.labels = labels
  }

  public var __variables: Variables? { [
    "id": id,
    "labels": labels
  ] }

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
        .field("children", [Child]?.self),
      ] }

      public var children: [Child]? { __data["children"] }

      /// Org.Child
      ///
      /// Parent Type: `Organization`
      public struct Child: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Organization }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(SuperUserOrg.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var name: String? { __data["name"] }
        public var providers: Providers? { __data["providers"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var superUserOrg: SuperUserOrg { _toFragment() }
        }

        public typealias Providers = SuperUserOrg.Providers
      }
    }
  }
}
