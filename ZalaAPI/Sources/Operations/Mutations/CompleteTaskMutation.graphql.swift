// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CompleteTaskMutation: GraphQLMutation {
  public static let operationName: String = "CompleteTask"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CompleteTask($input: TaskIntervalCompleteInput) { taskIntervalComplete(input: $input) { __typename success result { __typename task { __typename key } } } }"#
    ))

  public var input: GraphQLNullable<TaskIntervalCompleteInput>

  public init(input: GraphQLNullable<TaskIntervalCompleteInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("taskIntervalComplete", TaskIntervalComplete?.self, arguments: ["input": .variable("input")]),
    ] }

    public var taskIntervalComplete: TaskIntervalComplete? { __data["taskIntervalComplete"] }

    /// TaskIntervalComplete
    ///
    /// Parent Type: `TaskIntervalCompletePayload`
    public struct TaskIntervalComplete: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.TaskIntervalCompletePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool?.self),
        .field("result", Result?.self),
      ] }

      public var success: Bool? { __data["success"] }
      public var result: Result? { __data["result"] }

      /// TaskIntervalComplete.Result
      ///
      /// Parent Type: `TaskInterval`
      public struct Result: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.TaskInterval }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("task", Task?.self),
        ] }

        public var task: Task? { __data["task"] }

        /// TaskIntervalComplete.Result.Task
        ///
        /// Parent Type: `Task`
        public struct Task: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Task }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("key", String?.self),
          ] }

          /// the Vital that the task operates on (activity.steps, vital.heart_rate)
          public var key: String? { __data["key"] }
        }
      }
    }
  }
}
