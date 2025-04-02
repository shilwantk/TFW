// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CreateHabitMutation: GraphQLMutation {
  public static let operationName: String = "CreateHabit"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateHabit($input: TaskCreateInput) { taskCreate(input: $input) { __typename errors { __typename message } success task { __typename id } } }"#
    ))

  public var input: GraphQLNullable<TaskCreateInput>

  public init(input: GraphQLNullable<TaskCreateInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("taskCreate", TaskCreate?.self, arguments: ["input": .variable("input")]),
    ] }

    public var taskCreate: TaskCreate? { __data["taskCreate"] }

    /// TaskCreate
    ///
    /// Parent Type: `TaskCreatePayload`
    public struct TaskCreate: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.TaskCreatePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("errors", [Error_SelectionSet]?.self),
        .field("success", Bool?.self),
        .field("task", Task?.self),
      ] }

      public var errors: [Error_SelectionSet]? { __data["errors"] }
      public var success: Bool? { __data["success"] }
      public var task: Task? { __data["task"] }

      /// TaskCreate.Error_SelectionSet
      ///
      /// Parent Type: `Error_Object`
      public struct Error_SelectionSet: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Error_Object }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("message", String?.self),
        ] }

        public var message: String? { __data["message"] }
      }

      /// TaskCreate.Task
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
