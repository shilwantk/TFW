// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct MarketPlaceRoutine: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment MarketPlaceRoutine on CarePlan { __typename id attachments(labels: $labels) { __typename ...AttachmentModel } focus description durationInDays name requirements monitors { __typename id metric } tasks(status: $taskStatus) { __typename ...TaskModel } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlan }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("attachments", [Attachment]?.self, arguments: ["labels": .variable("labels")]),
    .field("focus", String?.self),
    .field("description", String?.self),
    .field("durationInDays", Int?.self),
    .field("name", String?.self),
    .field("requirements", [String]?.self),
    .field("monitors", [Monitor]?.self),
    .field("tasks", [Task]?.self, arguments: ["status": .variable("taskStatus")]),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var attachments: [Attachment]? { __data["attachments"] }
  public var focus: String? { __data["focus"] }
  public var description: String? { __data["description"] }
  public var durationInDays: Int? { __data["durationInDays"] }
  public var name: String? { __data["name"] }
  public var requirements: [String]? { __data["requirements"] }
  public var monitors: [Monitor]? { __data["monitors"] }
  public var tasks: [Task]? { __data["tasks"] }

  /// Attachment
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

  /// Monitor
  ///
  /// Parent Type: `MetricMonitor`
  public struct Monitor: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.MetricMonitor }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", ZalaAPI.ID?.self),
      .field("metric", String?.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var metric: String? { __data["metric"] }
  }

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
