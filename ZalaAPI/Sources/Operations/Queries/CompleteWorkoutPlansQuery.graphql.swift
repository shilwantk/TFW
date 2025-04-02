// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CompleteWorkoutPlansQuery: GraphQLQuery {
  public static let operationName: String = "CompleteWorkoutPlans"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CompleteWorkoutPlans($kinds: [String!]!) { me { __typename healthSnaps(kinds: $kinds) { __typename nodes { __typename id kind name beginAt } } } }"#
    ))

  public var kinds: [String]

  public init(kinds: [String]) {
    self.kinds = kinds
  }

  public var __variables: Variables? { ["kinds": kinds] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("me", Me?.self),
    ] }

    public var me: Me? { __data["me"] }

    /// Me
    ///
    /// Parent Type: `User`
    public struct Me: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("healthSnaps", HealthSnaps?.self, arguments: ["kinds": .variable("kinds")]),
      ] }

      public var healthSnaps: HealthSnaps? { __data["healthSnaps"] }

      /// Me.HealthSnaps
      ///
      /// Parent Type: `HealthSnapConnection`
      public struct HealthSnaps: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.HealthSnapConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Me.HealthSnaps.Node
        ///
        /// Parent Type: `HealthSnap`
        public struct Node: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.HealthSnap }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZalaAPI.ID?.self),
            .field("kind", String?.self),
            .field("name", String?.self),
            .field("beginAt", Int?.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          /// arbitrary string at the moment
          public var kind: String? { __data["kind"] }
          public var name: String? { __data["name"] }
          public var beginAt: Int? { __data["beginAt"] }
        }
      }
    }
  }
}
