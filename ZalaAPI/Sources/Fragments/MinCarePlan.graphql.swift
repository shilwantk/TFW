// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct MinCarePlan: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment MinCarePlan on CarePlan { __typename id name description status focus endAtIso createdAtIso periodDurationDays durationInDays organizationId complianceScore { __typename percent raw } monitors { __typename id } attachments(labels: $labels) { __typename ...AttachmentModel } tasks(status: $taskStatus) { __typename id } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlan }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("name", String?.self),
    .field("description", String?.self),
    .field("status", String?.self),
    .field("focus", String?.self),
    .field("endAtIso", String?.self),
    .field("createdAtIso", String?.self),
    .field("periodDurationDays", Int?.self),
    .field("durationInDays", Int?.self),
    .field("organizationId", ZalaAPI.ID?.self),
    .field("complianceScore", ComplianceScore?.self),
    .field("monitors", [Monitor]?.self),
    .field("attachments", [Attachment]?.self, arguments: ["labels": .variable("labels")]),
    .field("tasks", [Task]?.self, arguments: ["status": .variable("taskStatus")]),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var name: String? { __data["name"] }
  public var description: String? { __data["description"] }
  public var status: String? { __data["status"] }
  public var focus: String? { __data["focus"] }
  public var endAtIso: String? { __data["endAtIso"] }
  public var createdAtIso: String? { __data["createdAtIso"] }
  public var periodDurationDays: Int? { __data["periodDurationDays"] }
  public var durationInDays: Int? { __data["durationInDays"] }
  public var organizationId: ZalaAPI.ID? { __data["organizationId"] }
  public var complianceScore: ComplianceScore? { __data["complianceScore"] }
  public var monitors: [Monitor]? { __data["monitors"] }
  public var attachments: [Attachment]? { __data["attachments"] }
  public var tasks: [Task]? { __data["tasks"] }

  /// ComplianceScore
  ///
  /// Parent Type: `ComplianceScore`
  public struct ComplianceScore: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ComplianceScore }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("percent", String?.self),
      .field("raw", String?.self),
    ] }

    public var percent: String? { __data["percent"] }
    public var raw: String? { __data["raw"] }
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
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
  }

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

  /// Task
  ///
  /// Parent Type: `Task`
  public struct Task: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Task }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", ZalaAPI.ID?.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
  }
}
