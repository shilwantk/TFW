// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class WorkoutRoutineByIdQuery: GraphQLQuery {
  public static let operationName: String = "WorkoutRoutineById"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query WorkoutRoutineById($id: ID!) { me { __typename workoutRoutine(id: $id) { __typename ...WorkoutRoutineModel } } }"#,
      fragments: [AttachmentModel.self, WorkoutActivityModel.self, WorkoutPlanGroupActivityModel.self, WorkoutPlanGroupModel.self, WorkoutPlanModel.self, WorkoutRoutineModel.self, WorkoutSetModel.self]
    ))

  public var id: ID

  public init(id: ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

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
        .field("workoutRoutine", WorkoutRoutine?.self, arguments: ["id": .variable("id")]),
      ] }

      public var workoutRoutine: WorkoutRoutine? { __data["workoutRoutine"] }

      /// Me.WorkoutRoutine
      ///
      /// Parent Type: `WorkoutRoutine`
      public struct WorkoutRoutine: ZalaAPI.SelectionSet {
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
