// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct ServiceModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment ServiceModel on Service { __typename id attachments(labels: ["banner"]) { __typename ...AttachmentModel } desc groupPrimary kind organizationId status title }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Service }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("attachments", [Attachment]?.self, arguments: ["labels": ["banner"]]),
    .field("desc", String?.self),
    .field("groupPrimary", Bool?.self),
    .field("kind", String?.self),
    .field("organizationId", ZalaAPI.ID?.self),
    .field("status", String?.self),
    .field("title", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var attachments: [Attachment]? { __data["attachments"] }
  public var desc: String? { __data["desc"] }
  public var groupPrimary: Bool? { __data["groupPrimary"] }
  public var kind: String? { __data["kind"] }
  public var organizationId: ZalaAPI.ID? { __data["organizationId"] }
  public var status: String? { __data["status"] }
  public var title: String? { __data["title"] }

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
}
