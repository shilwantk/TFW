// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct PhoneNumberModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment PhoneNumberModel on AddressesPhone { __typename id label number }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AddressesPhone }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("label", String?.self),
    .field("number", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var label: String? { __data["label"] }
  public var number: String? { __data["number"] }
}
