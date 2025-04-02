// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class WorkoutRoutineUpdateMutation: GraphQLMutation {
  public static let operationName: String = "WorkoutRoutineUpdate"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation WorkoutRoutineUpdate($input: WorkoutRoutineUpdateInput) { workoutRoutineUpdate(input: $input) { __typename success result { __typename ...WorkoutRoutineModel } } }"#,
      fragments: [AttachmentModel.self, WorkoutActivityModel.self, WorkoutPlanGroupActivityModel.self, WorkoutPlanGroupModel.self, WorkoutPlanModel.self, WorkoutRoutineModel.self, WorkoutSetModel.self]
    ))

  public var input: GraphQLNullable<WorkoutRoutineUpdateInput>

  public init(input: GraphQLNullable<WorkoutRoutineUpdateInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("workoutRoutineUpdate", WorkoutRoutineUpdate?.self, arguments: ["input": .variable("input")]),
    ] }

    public var workoutRoutineUpdate: WorkoutRoutineUpdate? { __data["workoutRoutineUpdate"] }

    /// WorkoutRoutineUpdate
    ///
    /// Parent Type: `WorkoutRoutineUpdatePayload`
    public struct WorkoutRoutineUpdate: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutRoutineUpdatePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool?.self),
        .field("result", Result?.self),
      ] }

      public var success: Bool? { __data["success"] }
      public var result: Result? { __data["result"] }

      /// WorkoutRoutineUpdate.Result
      ///
      /// Parent Type: `WorkoutRoutine`
      public struct Result: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutRoutine }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(WorkoutRoutineModel.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var title: String? { __data["title"] }
        public var status: String? { __data["status"] }
        /// The number of days
        public var duration: Int? { __data["duration"] }
        public var creator: Creator? { __data["creator"] }
        public var plans: Plans? { __data["plans"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var workoutRoutineModel: WorkoutRoutineModel { _toFragment() }
        }

        public typealias Creator = WorkoutRoutineModel.Creator

        public typealias Plans = WorkoutRoutineModel.Plans
      }
    }
  }
}
