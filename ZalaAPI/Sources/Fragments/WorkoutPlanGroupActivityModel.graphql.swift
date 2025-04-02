// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct WorkoutPlanGroupActivityModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment WorkoutPlanGroupActivityModel on WorkoutPlanGroupActivity { __typename id position starred activity { __typename ...WorkoutActivityModel } sets { __typename ...WorkoutSetModel } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutPlanGroupActivity }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("position", Int?.self),
    .field("starred", Bool?.self),
    .field("activity", Activity?.self),
    .field("sets", [Set]?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var position: Int? { __data["position"] }
  public var starred: Bool? { __data["starred"] }
  public var activity: Activity? { __data["activity"] }
  public var sets: [Set]? { __data["sets"] }

  /// Activity
  ///
  /// Parent Type: `WorkoutActivity`
  public struct Activity: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutActivity }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(WorkoutActivityModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var key: String? { __data["key"] }
    public var name: String? { __data["name"] }
    public var videoUrl: String? { __data["videoUrl"] }
    public var uses: [String]? { __data["uses"] }
    public var categoryCode: String? { __data["categoryCode"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var workoutActivityModel: WorkoutActivityModel { _toFragment() }
    }
  }

  /// Set
  ///
  /// Parent Type: `WorkoutSet`
  public struct Set: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutSet }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(WorkoutSetModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var rest: String? { __data["rest"] }
    public var status: String? { __data["status"] }
    public var reps: Int? { __data["reps"] }
    /// Rate of Perceived Exertion (BORG Scale: 6-20)
    public var rpe: Int? { __data["rpe"] }
    public var distance: String? { __data["distance"] }
    public var weight: String? { __data["weight"] }
    public var time: String? { __data["time"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var workoutSetModel: WorkoutSetModel { _toFragment() }
    }
  }
}
