// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TaskVitalsQuery: GraphQLQuery {
  public static let operationName: String = "TaskVitals"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query TaskVitals($metrics: [String!]!, $sinceEpoch: Int, $untilEpoch: Int) { me { __typename dataValues(metrics: $metrics, sinceEpoch: $sinceEpoch, untilEpoch: $untilEpoch) { __typename nodes { __typename id key values beginAt displayUnits notes { __typename ...AnswerNoteModel } } } } }"#,
      fragments: [AnswerNoteModel.self]
    ))

  public var metrics: [String]
  public var sinceEpoch: GraphQLNullable<Int>
  public var untilEpoch: GraphQLNullable<Int>

  public init(
    metrics: [String],
    sinceEpoch: GraphQLNullable<Int>,
    untilEpoch: GraphQLNullable<Int>
  ) {
    self.metrics = metrics
    self.sinceEpoch = sinceEpoch
    self.untilEpoch = untilEpoch
  }

  public var __variables: Variables? { [
    "metrics": metrics,
    "sinceEpoch": sinceEpoch,
    "untilEpoch": untilEpoch
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
          "untilEpoch": .variable("untilEpoch")
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
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Me.DataValues.Node
        ///
        /// Parent Type: `DataValue`
        public struct Node: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.DataValue }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZalaAPI.ID?.self),
            .field("key", String?.self),
            .field("values", [String]?.self),
            .field("beginAt", Int?.self),
            .field("displayUnits", [String]?.self),
            .field("notes", [Note]?.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var key: String? { __data["key"] }
          public var values: [String]? { __data["values"] }
          public var beginAt: Int? { __data["beginAt"] }
          public var displayUnits: [String]? { __data["displayUnits"] }
          public var notes: [Note]? { __data["notes"] }

          /// Me.DataValues.Node.Note
          ///
          /// Parent Type: `AnswerNote`
          public struct Note: ZalaAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AnswerNote }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(AnswerNoteModel.self),
            ] }

            public var id: ZalaAPI.ID? { __data["id"] }
            public var body: String { __data["body"] }
            public var `private`: Bool? { __data["private"] }
            public var subject: ZalaAPI.ID? { __data["subject"] }
            public var subjectType: String? { __data["subjectType"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var answerNoteModel: AnswerNoteModel { _toFragment() }
            }
          }
        }
      }
    }
  }
}
