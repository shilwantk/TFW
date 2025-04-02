// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct AgreementModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment AgreementModel on Agreement { __typename id kind docMarkdown }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Agreement }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("kind", String?.self),
    .field("docMarkdown", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var kind: String? { __data["kind"] }
  public var docMarkdown: String? { __data["docMarkdown"] }
}
