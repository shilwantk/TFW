// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CompleteHabitMutation: GraphQLMutation {
  public static let operationName: String = "CompleteHabit"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CompleteHabit($input: IDInput) { taskComplete(input: $input) { __typename success task { __typename id } } }"#
    ))

  public var input: GraphQLNullable<IDInput>

  public init(input: GraphQLNullable<IDInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("taskComplete", TaskComplete?.self, arguments: ["input": .variable("input")]),
    ] }

    public var taskComplete: TaskComplete? { __data["taskComplete"] }

    /// TaskComplete
    ///
    /// Parent Type: `TaskCompletePayload`
    public struct TaskComplete: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.TaskCompletePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool?.self),
        .field("task", Task?.self),
      ] }

      public var success: Bool? { __data["success"] }
      public var task: Task? { __data["task"] }

      /// TaskComplete.Task
      ///
      /// Parent Type: `Task`
      public struct Task: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Task }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
      }
    }
  }
}
