// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct MinWorkoutRoutineModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment MinWorkoutRoutineModel on WorkoutRoutine { __typename id title status duration creator { __typename id attachments(labels: ["profile_picture"]) { __typename ...AttachmentModel } fullName } }"#
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
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var title: String? { __data["title"] }
  public var status: String? { __data["status"] }
  /// The number of days
  public var duration: Int? { __data["duration"] }
  public var creator: Creator? { __data["creator"] }

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
}
