// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct AnswerNoteModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment AnswerNoteModel on AnswerNote { __typename id body private subject subjectType }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AnswerNote }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("body", String.self),
    .field("private", Bool?.self),
    .field("subject", ZalaAPI.ID?.self),
    .field("subjectType", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var body: String { __data["body"] }
  public var `private`: Bool? { __data["private"] }
  public var subject: ZalaAPI.ID? { __data["subject"] }
  public var subjectType: String? { __data["subjectType"] }
}
