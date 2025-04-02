// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class VitalsByTimeQuery: GraphQLQuery {
  public static let operationName: String = "VitalsByTime"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query VitalsByTime($metrics: [String!]!, $sinceEpoch: Int, $untilEpoch: Int, $order: String!, $first: Int, $after: String) { me { __typename dataValues( metrics: $metrics sinceEpoch: $sinceEpoch untilEpoch: $untilEpoch order: $order first: $first after: $after ) { __typename nodes { __typename ...DataValueModel } pageInfo { __typename ...PageInfoModel } } } }"#,
      fragments: [AnswerModel.self, AnswerNoteModel.self, DataValueModel.self, DataValueSourceModel.self, MetricModel.self, PageInfoModel.self]
    ))

  public var metrics: [String]
  public var sinceEpoch: GraphQLNullable<Int>
  public var untilEpoch: GraphQLNullable<Int>
  public var order: String
  public var first: GraphQLNullable<Int>
  public var after: GraphQLNullable<String>

  public init(
    metrics: [String],
    sinceEpoch: GraphQLNullable<Int>,
    untilEpoch: GraphQLNullable<Int>,
    order: String,
    first: GraphQLNullable<Int>,
    after: GraphQLNullable<String>
  ) {
    self.metrics = metrics
    self.sinceEpoch = sinceEpoch
    self.untilEpoch = untilEpoch
    self.order = order
    self.first = first
    self.after = after
  }

  public var __variables: Variables? { [
    "metrics": metrics,
    "sinceEpoch": sinceEpoch,
    "untilEpoch": untilEpoch,
    "order": order,
    "first": first,
    "after": after
  ] }

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
        .field("dataValues", DataValues?.self, arguments: [
          "metrics": .variable("metrics"),
          "sinceEpoch": .variable("sinceEpoch"),
          "untilEpoch": .variable("untilEpoch"),
          "order": .variable("order"),
          "first": .variable("first"),
          "after": .variable("after")
        ]),
      ] }

      public var dataValues: DataValues? { __data["dataValues"] }

      /// Me.DataValues
      ///
      /// Parent Type: `DataValueConnection`
      public struct DataValues: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.DataValueConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
          .field("pageInfo", PageInfo.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }
        /// Information to aid in pagination.
        public var pageInfo: PageInfo { __data["pageInfo"] }

        /// Me.DataValues.Node
        ///
        /// Parent Type: `DataValue`
        public struct Node: ZalaAPI.SelectionSet {
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

        /// Me.DataValues.PageInfo
        ///
        /// Parent Type: `PageInfo`
        public struct PageInfo: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.PageInfo }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(PageInfoModel.self),
          ] }

          /// When paginating forwards, are there more items?
          public var hasNextPage: Bool { __data["hasNextPage"] }
          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? { __data["endCursor"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var pageInfoModel: PageInfoModel { _toFragment() }
          }
        }
      }
    }
  }
}
