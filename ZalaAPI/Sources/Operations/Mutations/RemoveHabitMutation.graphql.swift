// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RemoveHabitMutation: GraphQLMutation {
  public static let operationName: String = "RemoveHabit"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation RemoveHabit($input: IDInput) { taskRemove(input: $input) { __typename success task { __typename id } } }"#
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
      .field("taskRemove", TaskRemove?.self, arguments: ["input": .variable("input")]),
    ] }

    public var taskRemove: TaskRemove? { __data["taskRemove"] }

    /// TaskRemove
    ///
    /// Parent Type: `TaskRemovePayload`
    public struct TaskRemove: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.TaskRemovePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool?.self),
        .field("task", Task?.self),
      ] }

      public var success: Bool? { __data["success"] }
      public var task: Task? { __data["task"] }

      /// TaskRemove.Task
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
