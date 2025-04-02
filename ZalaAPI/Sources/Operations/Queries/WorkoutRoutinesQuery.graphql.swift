// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class WorkoutRoutinesQuery: GraphQLQuery {
  public static let operationName: String = "WorkoutRoutines"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query WorkoutRoutines($status: String) { me { __typename workoutRoutines(status: $status) { __typename nodes { __typename ...WorkoutRoutineModel } } } }"#,
      fragments: [AttachmentModel.self, WorkoutActivityModel.self, WorkoutPlanGroupActivityModel.self, WorkoutPlanGroupModel.self, WorkoutPlanModel.self, WorkoutRoutineModel.self, WorkoutSetModel.self]
    ))

  public var status: GraphQLNullable<String>

  public init(status: GraphQLNullable<String>) {
    self.status = status
  }

  public var __variables: Variables? { ["status": status] }

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
        .field("workoutRoutines", WorkoutRoutines?.self, arguments: ["status": .variable("status")]),
      ] }

      public var workoutRoutines: WorkoutRoutines? { __data["workoutRoutines"] }

      /// Me.WorkoutRoutines
      ///
      /// Parent Type: `WorkoutRoutineConnection`
      public struct WorkoutRoutines: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutRoutineConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Me.WorkoutRoutines.Node
        ///
        /// Parent Type: `WorkoutRoutine`
        public struct Node: ZalaAPI.SelectionSet {
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
}
