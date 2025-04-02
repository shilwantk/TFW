// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct WorkoutPlanModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment WorkoutPlanModel on WorkoutPlan { __typename id status title desc frequency groups { __typename ...WorkoutPlanGroupModel } creator { __typename id fullName initials attachments(labels: ["profile_picture"]) { __typename ...AttachmentModel } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutPlan }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("status", String?.self),
    .field("title", String?.self),
    .field("desc", String?.self),
    .field("frequency", String?.self),
    .field("groups", [Group]?.self),
    .field("creator", Creator?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var status: String? { __data["status"] }
  public var title: String? { __data["title"] }
  /// Description of the workout plan
  public var desc: String? { __data["desc"] }
  public var frequency: String? { __data["frequency"] }
  public var groups: [Group]? { __data["groups"] }
  public var creator: Creator? { __data["creator"] }

  /// Group
  ///
  /// Parent Type: `WorkoutPlanGroup`
  public struct Group: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutPlanGroup }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(WorkoutPlanGroupModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var title: String? { __data["title"] }
    public var position: Int? { __data["position"] }
    public var status: String? { __data["status"] }
    public var activityLinks: [ActivityLink]? { __data["activityLinks"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var workoutPlanGroupModel: WorkoutPlanGroupModel { _toFragment() }
    }

    public typealias ActivityLink = WorkoutPlanGroupModel.ActivityLink
  }

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
      .field("fullName", String?.self),
      .field("initials", String?.self),
      .field("attachments", [Attachment]?.self, arguments: ["labels": ["profile_picture"]]),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var fullName: String? { __data["fullName"] }
    public var initials: String? { __data["initials"] }
    public var attachments: [Attachment]? { __data["attachments"] }

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
}
