// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct PreferenceModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment PreferenceModel on Preference { __typename id key value createdAtIso updatedAtIso }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Preference }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("key", String?.self),
    .field("value", [String]?.self),
    .field("createdAtIso", String?.self),
    .field("updatedAtIso", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var key: String? { __data["key"] }
  public var value: [String]? { __data["value"] }
  public var createdAtIso: String? { __data["createdAtIso"] }
  public var updatedAtIso: String? { __data["updatedAtIso"] }
}
