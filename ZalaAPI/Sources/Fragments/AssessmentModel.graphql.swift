// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct AssessmentModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment AssessmentModel on Assessment { __typename id kind name program }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Assessment }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("kind", String?.self),
    .field("name", String?.self),
    .field("program", ZalaAPI.JSON?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var kind: String? { __data["kind"] }
  public var name: String? { __data["name"] }
  public var program: ZalaAPI.JSON? { __data["program"] }
}
