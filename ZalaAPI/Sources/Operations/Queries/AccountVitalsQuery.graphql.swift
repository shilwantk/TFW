// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AccountVitalsQuery: GraphQLQuery {
  public static let operationName: String = "AccountVitalsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query AccountVitalsQuery($id: ID, $metrics: [String!]!, $sinceEpoch: Int, $untilEpoch: Int) { user(id: $id) { __typename id dataValues(metrics: $metrics, sinceEpoch: $sinceEpoch, untilEpoch: $untilEpoch) { __typename nodes { __typename ...VitalModel } } } }"#,
      fragments: [DataValueSourceModel.self, MetricModel.self, VitalModel.self]
    ))

  public var id: GraphQLNullable<ID>
  public var metrics: [String]
  public var sinceEpoch: GraphQLNullable<Int>
  public var untilEpoch: GraphQLNullable<Int>

  public init(
    id: GraphQLNullable<ID>,
    metrics: [String],
    sinceEpoch: GraphQLNullable<Int>,
    untilEpoch: GraphQLNullable<Int>
  ) {
    self.id = id
    self.metrics = metrics
    self.sinceEpoch = sinceEpoch
    self.untilEpoch = untilEpoch
  }

  public var __variables: Variables? { [
    "id": id,
    "metrics": metrics,
    "sinceEpoch": sinceEpoch,
    "untilEpoch": untilEpoch
  ] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["id": .variable("id")]),
    ] }

    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", ZalaAPI.ID?.self),
        .field("dataValues", DataValues?.self, arguments: [
          "metrics": .variable("metrics"),
          "sinceEpoch": .variable("sinceEpoch"),
          "untilEpoch": .variable("untilEpoch")
        ]),
      ] }

      public var id: ZalaAPI.ID? { __data["id"] }
      public var dataValues: DataValues? { __data["dataValues"] }

      /// User.DataValues
      ///
      /// Parent Type: `DataValueConnection`
      public struct DataValues: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.DataValueConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// User.DataValues.Node
        ///
        /// Parent Type: `DataValue`
        public struct Node: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.DataValue }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(VitalModel.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var key: String? { __data["key"] }
          public var values: [String]? { __data["values"] }
          public var units: [String]? { __data["units"] }
          public var createdAtIso: String? { __data["createdAtIso"] }
          public var endAtIso: String? { __data["endAtIso"] }
          public var displayUnits: [String]? { __data["displayUnits"] }
          public var periodIso: [String]? { __data["periodIso"] }
          public var period: [Int]? { __data["period"] }
          public var metric: Metric? { __data["metric"] }
          public var source: Source? { __data["source"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var vitalModel: VitalModel { _toFragment() }
          }

          public typealias Metric = VitalModel.Metric

          public typealias Source = VitalModel.Source
        }
      }
    }
  }
}
