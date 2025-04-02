// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct AddressModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment AddressModel on AddressesStreet { __typename id label line1 line2 state city zip address csz }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AddressesStreet }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("label", String?.self),
    .field("line1", String?.self),
    .field("line2", String?.self),
    .field("state", String?.self),
    .field("city", String?.self),
    .field("zip", String?.self),
    .field("address", String?.self),
    .field("csz", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var label: String? { __data["label"] }
  /// Street Address
  public var line1: String? { __data["line1"] }
  /// City, State ZIP
  public var line2: String? { __data["line2"] }
  public var state: String? { __data["state"] }
  public var city: String? { __data["city"] }
  public var zip: String? { __data["zip"] }
  public var address: String? { __data["address"] }
  /// City, State ZIP
  public var csz: String? { __data["csz"] }
}
