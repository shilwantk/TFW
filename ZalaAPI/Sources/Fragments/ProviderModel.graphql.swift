// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct ProviderModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment ProviderModel on User { __typename id attachments(labels: $labels) { __typename ...AttachmentModel } addresses { __typename ...AddressModel } firstName lastName preferences { __typename ...PreferenceModel } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("attachments", [Attachment]?.self, arguments: ["labels": .variable("labels")]),
    .field("addresses", [Address]?.self),
    .field("firstName", String?.self),
    .field("lastName", String?.self),
    .field("preferences", [Preference]?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var attachments: [Attachment]? { __data["attachments"] }
  public var addresses: [Address]? { __data["addresses"] }
  public var firstName: String? { __data["firstName"] }
  public var lastName: String? { __data["lastName"] }
  /// Preferences
  public var preferences: [Preference]? { __data["preferences"] }

  /// Attachment
  ///
  /// Parent Type: `Attachment`
  public struct Attachment: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Attachment }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(AttachmentModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var label: String? { __data["label"] }
    public var contentUrl: String? { __data["contentUrl"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var attachmentModel: AttachmentModel { _toFragment() }
    }
  }

  /// Address
  ///
  /// Parent Type: `AddressesStreet`
  public struct Address: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AddressesStreet }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(AddressModel.self),
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

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var addressModel: AddressModel { _toFragment() }
    }
  }

  /// Preference
  ///
  /// Parent Type: `Preference`
  public struct Preference: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Preference }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(PreferenceModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var key: String? { __data["key"] }
    public var value: [String]? { __data["value"] }
    public var createdAtIso: String? { __data["createdAtIso"] }
    public var updatedAtIso: String? { __data["updatedAtIso"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var preferenceModel: PreferenceModel { _toFragment() }
    }
  }
}
