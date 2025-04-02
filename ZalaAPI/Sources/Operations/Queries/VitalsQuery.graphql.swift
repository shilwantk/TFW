// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class VitalsQuery: GraphQLQuery {
  public static let operationName: String = "Vitals"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Vitals($metrics: [String!]) { me { __typename latestData(metrics: $metrics) { __typename ...DataValueModel } } }"#,
      fragments: [AnswerModel.self, AnswerNoteModel.self, DataValueModel.self, DataValueSourceModel.self, MetricModel.self]
    ))

  public var metrics: GraphQLNullable<[String]>

  public init(metrics: GraphQLNullable<[String]>) {
    self.metrics = metrics
  }

  public var __variables: Variables? { ["metrics": metrics] }

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
        .field("latestData", [LatestDatum]?.self, arguments: ["metrics": .variable("metrics")]),
      ] }

      public var latestData: [LatestDatum]? { __data["latestData"] }

      /// Me.LatestDatum
      ///
      /// Parent Type: `DataValue`
      public struct LatestDatum: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.DataValue }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(DataValueModel.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var key: String? { __data["key"] }
        public var values: [String]? { __data["values"] }
        public var units: [String]? { __data["units"] }
        public var createdAtIso: String? { __data["createdAtIso"] }
        public var endAtIso: String? { __data["endAtIso"] }
        public var displayUnits: [String]? { __data["displayUnits"] }
        public var periodIso: [String]? { __data["periodIso"] }
        public var asAnswer: AsAnswer? { __data["asAnswer"] }
        public var metric: Metric? { __data["metric"] }
        public var source: Source? { __data["source"] }
        public var notes: [Note]? { __data["notes"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var dataValueModel: DataValueModel { _toFragment() }
        }

        public typealias AsAnswer = DataValueModel.AsAnswer

        public typealias Metric = DataValueModel.Metric

        public typealias Source = DataValueModel.Source

        public typealias Note = DataValueModel.Note
      }
    }
  }
}
