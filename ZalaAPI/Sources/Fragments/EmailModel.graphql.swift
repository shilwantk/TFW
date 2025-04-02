// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct EmailModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment EmailModel on AddressesEmail { __typename id label address }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AddressesEmail }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("label", String?.self),
    .field("address", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var label: String? { __data["label"] }
  public var address: String? { __data["address"] }
}
