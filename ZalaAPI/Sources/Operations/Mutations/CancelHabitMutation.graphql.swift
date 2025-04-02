// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CancelHabitMutation: GraphQLMutation {
  public static let operationName: String = "CancelHabit"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CancelHabit($input: IDInput) { taskCancel(input: $input) { __typename success task { __typename id } } }"#
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
      .field("taskCancel", TaskCancel?.self, arguments: ["input": .variable("input")]),
    ] }

    public var taskCancel: TaskCancel? { __data["taskCancel"] }

    /// TaskCancel
    ///
    /// Parent Type: `TaskCancelPayload`
    public struct TaskCancel: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.TaskCancelPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool?.self),
        .field("task", Task?.self),
      ] }

      public var success: Bool? { __data["success"] }
      public var task: Task? { __data["task"] }

      /// TaskCancel.Task
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
