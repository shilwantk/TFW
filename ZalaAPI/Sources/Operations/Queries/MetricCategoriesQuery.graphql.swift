// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MetricCategoriesQuery: GraphQLQuery {
  public static let operationName: String = "MetricCategories"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query MetricCategories { application { __typename metricCategories } }"#
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
        .field("metricCategories", [String]?.self),
      ] }

      public var metricCategories: [String]? { __data["metricCategories"] }
    }
  }
}
