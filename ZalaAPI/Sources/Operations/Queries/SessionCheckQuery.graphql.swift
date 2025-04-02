// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SessionCheckQuery: GraphQLQuery {
  public static let operationName: String = "SessionCheck"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SessionCheck { me { __typename id } }"#
    ))

  public init() {}

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
        .field("id", ZalaAPI.ID?.self),
      ] }

      public var id: ZalaAPI.ID? { __data["id"] }
    }
  }
}
