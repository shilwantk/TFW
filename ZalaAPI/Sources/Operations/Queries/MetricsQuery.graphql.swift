// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MetricsQuery: GraphQLQuery {
  public static let operationName: String = "Metrics"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Metrics { application { __typename metricCategories metrics { __typename ...MetricModel } } }"#,
      fragments: [MetricModel.self]
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
        .field("metrics", [Metric]?.self),
      ] }

      public var metricCategories: [String]? { __data["metricCategories"] }
      public var metrics: [Metric]? { __data["metrics"] }

      /// Application.Metric
      ///
      /// Parent Type: `Metric`
      public struct Metric: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Metric }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MetricModel.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var key: String { __data["key"] }
        public var labels: [String]? { __data["labels"] }
        public var names: [String]? { __data["names"] }
        public var title: String? { __data["title"] }
        public var storedAs: [String]? { __data["storedAs"] }
        public var units: [[String]]? { __data["units"] }
        public var cumulative: Bool? { __data["cumulative"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var metricModel: MetricModel { _toFragment() }
        }
      }
    }
  }
}
