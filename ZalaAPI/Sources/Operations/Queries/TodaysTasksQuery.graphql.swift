// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TodaysTasksQuery: GraphQLQuery {
  public static let operationName: String = "TodaysTasks"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query TodaysTasks($date: String) { me { __typename tasksTodo { __typename id key timeFrames dayIntervals(date: $date) { __typename ...TodoTask } } } }"#,
      fragments: [AttachmentModel.self, TaskModel.self, TodoTask.self]
    ))

  public var date: GraphQLNullable<String>

  public init(date: GraphQLNullable<String>) {
    self.date = date
  }

  public var __variables: Variables? { ["date": date] }

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
        .field("tasksTodo", [TasksTodo]?.self),
      ] }

      public var tasksTodo: [TasksTodo]? { __data["tasksTodo"] }

      /// Me.TasksTodo
      ///
      /// Parent Type: `Task`
      public struct TasksTodo: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Task }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
          .field("key", String?.self),
          .field("timeFrames", [String]?.self),
          .field("dayIntervals", [DayInterval]?.self, arguments: ["date": .variable("date")]),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        /// the Vital that the task operates on (activity.steps, vital.heart_rate)
        public var key: String? { __data["key"] }
        /// [morning, afternoon, evening] || anytime
        public var timeFrames: [String]? { __data["timeFrames"] }
        public var dayIntervals: [DayInterval]? { __data["dayIntervals"] }

        /// Me.TasksTodo.DayInterval
        ///
        /// Parent Type: `TaskInterval`
        public struct DayInterval: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.TaskInterval }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(TodoTask.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var beginAt: Int? { __data["beginAt"] }
          public var endAt: Int? { __data["endAt"] }
          public var total: Double? { __data["total"] }
          public var compliance: Double? { __data["compliance"] }
          public var period: [Int]? { __data["period"] }
          public var task: Task? { __data["task"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var todoTask: TodoTask { _toFragment() }
          }

          public typealias Task = TodoTask.Task
        }
      }
    }
  }
}
