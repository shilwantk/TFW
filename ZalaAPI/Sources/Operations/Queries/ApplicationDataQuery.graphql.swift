// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ApplicationDataQuery: GraphQLQuery {
  public static let operationName: String = "ApplicationData"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ApplicationData { application { __typename version } }"#
    ))

  public init() {}

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("application", Application?.self),
    ] }

    public var application: Application? { __data["application"] }

    /// Application
    ///
    /// Parent Type: `Application`
    public struct Application: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Application }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("version", String.self),
      ] }

      /// Return the current API version
      public var version: String { __data["version"] }
    }
  }
}
