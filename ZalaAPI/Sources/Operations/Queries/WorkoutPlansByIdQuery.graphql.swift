// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class WorkoutPlansByIdQuery: GraphQLQuery {
  public static let operationName: String = "WorkoutPlansById"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query WorkoutPlansById($id: ID) { me { __typename workoutPlan(id: $id) { __typename ...WorkoutPlanModel } } }"#,
      fragments: [AttachmentModel.self, WorkoutActivityModel.self, WorkoutPlanGroupActivityModel.self, WorkoutPlanGroupModel.self, WorkoutPlanModel.self, WorkoutSetModel.self]
    ))

  public var id: GraphQLNullable<ID>

  public init(id: GraphQLNullable<ID>) {
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
        .field("workoutPlan", WorkoutPlan?.self, arguments: ["id": .variable("id")]),
      ] }

      public var workoutPlan: WorkoutPlan? { __data["workoutPlan"] }

      /// Me.WorkoutPlan
      ///
      /// Parent Type: `WorkoutPlan`
      public struct WorkoutPlan: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutPlan }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(WorkoutPlanModel.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var status: String? { __data["status"] }
        public var title: String? { __data["title"] }
        /// Description of the workout plan
        public var desc: String? { __data["desc"] }
        public var frequency: String? { __data["frequency"] }
        public var groups: [Group]? { __data["groups"] }
        public var creator: Creator? { __data["creator"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var workoutPlanModel: WorkoutPlanModel { _toFragment() }
        }

        public typealias Group = WorkoutPlanModel.Group

        public typealias Creator = WorkoutPlanModel.Creator
      }
    }
  }
}
