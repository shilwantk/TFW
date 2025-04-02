// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct DataValueSourceModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment DataValueSourceModel on DataValueSource { __typename id identifier name }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.DataValueSource }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("identifier", String?.self),
    .field("name", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var identifier: String? { __data["identifier"] }
  public var name: String? { __data["name"] }
}
