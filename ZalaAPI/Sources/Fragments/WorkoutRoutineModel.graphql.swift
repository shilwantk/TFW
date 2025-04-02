// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct WorkoutRoutineModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment WorkoutRoutineModel on WorkoutRoutine { __typename id title status duration creator { __typename id attachments(labels: ["profile_picture"]) { __typename ...AttachmentModel } fullName } plans { __typename nodes { __typename ...WorkoutPlanModel } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutRoutine }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("title", String?.self),
    .field("status", String?.self),
    .field("duration", Int?.self),
    .field("creator", Creator?.self),
    .field("plans", Plans?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var title: String? { __data["title"] }
  public var status: String? { __data["status"] }
  /// The number of days
  public var duration: Int? { __data["duration"] }
  public var creator: Creator? { __data["creator"] }
  public var plans: Plans? { __data["plans"] }

  /// Creator
  ///
  /// Parent Type: `User`
  public struct Creator: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", ZalaAPI.ID?.self),
      .field("attachments", [Attachment]?.self, arguments: ["labels": ["profile_picture"]]),
      .field("fullName", String?.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var attachments: [Attachment]? { __data["attachments"] }
    public var fullName: String? { __data["fullName"] }

    /// Creator.Attachment
    ///
    /// Parent Type: `Attachment`
    public struct Attachment: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Attachment }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(AttachmentModel.self),
      ] }

      public var id: ZalaAPI.ID? { __data["id"] }
      public var label: String? { __data["label"] }
      public var contentUrl: String? { __data["contentUrl"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var attachmentModel: AttachmentModel { _toFragment() }
      }
    }
  }

  /// Plans
  ///
  /// Parent Type: `WorkoutPlanConnection`
  public struct Plans: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutPlanConnection }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("nodes", [Node?]?.self),
    ] }

    /// A list of nodes.
    public var nodes: [Node?]? { __data["nodes"] }

    /// Plans.Node
    ///
    /// Parent Type: `WorkoutPlan`
    public struct Node: ZalaAPI.SelectionSet {
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
