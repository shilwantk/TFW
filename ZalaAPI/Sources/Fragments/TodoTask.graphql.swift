// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct TodoTask: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment TodoTask on TaskInterval { __typename id beginAt endAt total compliance period task { __typename ...TaskModel } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.TaskInterval }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("beginAt", Int?.self),
    .field("endAt", Int?.self),
    .field("total", Double?.self),
    .field("compliance", Double?.self),
    .field("period", [Int]?.self),
    .field("task", Task?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var beginAt: Int? { __data["beginAt"] }
  public var endAt: Int? { __data["endAt"] }
  public var total: Double? { __data["total"] }
  public var compliance: Double? { __data["compliance"] }
  public var period: [Int]? { __data["period"] }
  public var task: Task? { __data["task"] }

  /// Task
  ///
  /// Parent Type: `Task`
  public struct Task: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Task }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(TaskModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    /// 1-28
    public var daysOfMonth: [Int]? { __data["daysOfMonth"] }
    /// sun,mon,tue,wed,thu,fri,sat
    public var daysOfWeek: [String]? { __data["daysOfWeek"] }
    /// day, week, month
    public var interval: String? { __data["interval"] }
    /// the Vital that the task operates on (activity.steps, vital.heart_rate)
    public var key: String? { __data["key"] }
    public var minValue: Double? { __data["minValue"] }
    public var maxValue: Double? { __data["maxValue"] }
    public var testType: String? { __data["testType"] }
    /// before, after, anytime
    public var mealInfo: String? { __data["mealInfo"] }
    public var data: [Double]? { __data["data"] }
    public var metric: Metric? { __data["metric"] }
    public var status: String? { __data["status"] }
    public var title: String? { __data["title"] }
    /// [morning, afternoon, evening] || anytime
    public var timeFrames: [String]? { __data["timeFrames"] }
    /// Units the data values are in
    public var unit: String? { __data["unit"] }
    public var compliance: Double? { __data["compliance"] }
    /// Description
    public var desc: String? { __data["desc"] }
    public var carePlan: CarePlan? { __data["carePlan"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var taskModel: TaskModel { _toFragment() }
    }

    public typealias Metric = TaskModel.Metric

    public typealias CarePlan = TaskModel.CarePlan
  }
}
