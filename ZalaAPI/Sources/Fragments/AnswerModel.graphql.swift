// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct AnswerModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment AnswerModel on Answer { __typename id key labels names units data }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Answer }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("key", String.self),
    .field("labels", [String]?.self),
    .field("names", [String]?.self),
    .field("units", [String]?.self),
    .field("data", [String]?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var key: String { __data["key"] }
  public var labels: [String]? { __data["labels"] }
  public var names: [String]? { __data["names"] }
  public var units: [String]? { __data["units"] }
  public var data: [String]? { __data["data"] }
}
