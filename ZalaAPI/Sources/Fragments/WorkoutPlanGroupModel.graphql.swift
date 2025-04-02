// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct WorkoutPlanGroupModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment WorkoutPlanGroupModel on WorkoutPlanGroup { __typename id title position status activityLinks { __typename ...WorkoutPlanGroupActivityModel } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutPlanGroup }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("title", String?.self),
    .field("position", Int?.self),
    .field("status", String?.self),
    .field("activityLinks", [ActivityLink]?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var title: String? { __data["title"] }
  public var position: Int? { __data["position"] }
  public var status: String? { __data["status"] }
  public var activityLinks: [ActivityLink]? { __data["activityLinks"] }

  /// ActivityLink
  ///
  /// Parent Type: `WorkoutPlanGroupActivity`
  public struct ActivityLink: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutPlanGroupActivity }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(WorkoutPlanGroupActivityModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var position: Int? { __data["position"] }
    public var starred: Bool? { __data["starred"] }
    public var activity: Activity? { __data["activity"] }
    public var sets: [Set]? { __data["sets"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var workoutPlanGroupActivityModel: WorkoutPlanGroupActivityModel { _toFragment() }
    }

    public typealias Activity = WorkoutPlanGroupActivityModel.Activity

    public typealias Set = WorkoutPlanGroupActivityModel.Set
  }
}
