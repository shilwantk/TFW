// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct TaskModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment TaskModel on Task { __typename id daysOfMonth daysOfWeek interval key minValue maxValue testType mealInfo data metric { __typename id key title cumulative units } status title timeFrames unit compliance desc carePlan { __typename id name owner { __typename id attachments(labels: ["profile_picture"]) { __typename ...AttachmentModel } fullName } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Task }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("daysOfMonth", [Int]?.self),
    .field("daysOfWeek", [String]?.self),
    .field("interval", String?.self),
    .field("key", String?.self),
    .field("minValue", Double?.self),
    .field("maxValue", Double?.self),
    .field("testType", String?.self),
    .field("mealInfo", String?.self),
    .field("data", [Double]?.self),
    .field("metric", Metric?.self),
    .field("status", String?.self),
    .field("title", String?.self),
    .field("timeFrames", [String]?.self),
    .field("unit", String?.self),
    .field("compliance", Double?.self),
    .field("desc", String?.self),
    .field("carePlan", CarePlan?.self),
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

  /// Metric
  ///
  /// Parent Type: `Metric`
  public struct Metric: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Metric }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", ZalaAPI.ID?.self),
      .field("key", String.self),
      .field("title", String?.self),
      .field("cumulative", Bool?.self),
      .field("units", [[String]]?.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var key: String { __data["key"] }
    public var title: String? { __data["title"] }
    public var cumulative: Bool? { __data["cumulative"] }
    public var units: [[String]]? { __data["units"] }
  }

  /// CarePlan
  ///
  /// Parent Type: `CarePlan`
  public struct CarePlan: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlan }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", ZalaAPI.ID?.self),
      .field("name", String?.self),
      .field("owner", Owner?.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var name: String? { __data["name"] }
    public var owner: Owner? { __data["owner"] }

    /// CarePlan.Owner
    ///
    /// Parent Type: `User`
    public struct Owner: ZalaAPI.SelectionSet {
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

      /// CarePlan.Owner.Attachment
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
}
