// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct AttachmentModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment AttachmentModel on Attachment { __typename id label contentUrl }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Attachment }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("label", String?.self),
    .field("contentUrl", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var label: String? { __data["label"] }
  public var contentUrl: String? { __data["contentUrl"] }
}
