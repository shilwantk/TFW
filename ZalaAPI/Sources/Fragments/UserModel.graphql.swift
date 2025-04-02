// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct UserModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment UserModel on User { __typename id addresses { __typename ...AddressModel } attachments(labels: $labels) { __typename ...AttachmentModel } emails { __typename ...EmailModel } phones { __typename ...PhoneNumberModel } roles { __typename ...UserRole } firstName lastName fullName initials dob preferences { __typename ...PreferenceModel } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("addresses", [Address]?.self),
    .field("attachments", [Attachment]?.self, arguments: ["labels": .variable("labels")]),
    .field("emails", [Email]?.self),
    .field("phones", [Phone]?.self),
    .field("roles", [Role]?.self),
    .field("firstName", String?.self),
    .field("lastName", String?.self),
    .field("fullName", String?.self),
    .field("initials", String?.self),
    .field("dob", String?.self),
    .field("preferences", [Preference]?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var addresses: [Address]? { __data["addresses"] }
  public var attachments: [Attachment]? { __data["attachments"] }
  public var emails: [Email]? { __data["emails"] }
  public var phones: [Phone]? { __data["phones"] }
  public var roles: [Role]? { __data["roles"] }
  public var firstName: String? { __data["firstName"] }
  public var lastName: String? { __data["lastName"] }
  public var fullName: String? { __data["fullName"] }
  public var initials: String? { __data["initials"] }
  /// Date of Birth
  public var dob: String? { __data["dob"] }
  /// Preferences
  public var preferences: [Preference]? { __data["preferences"] }

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

  /// Email
  ///
  /// Parent Type: `AddressesEmail`
  public struct Email: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AddressesEmail }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(EmailModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var label: String? { __data["label"] }
    public var address: String? { __data["address"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var emailModel: EmailModel { _toFragment() }
    }
  }

  /// Phone
  ///
  /// Parent Type: `AddressesPhone`
  public struct Phone: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AddressesPhone }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(PhoneNumberModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var label: String? { __data["label"] }
    public var number: String? { __data["number"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var phoneNumberModel: PhoneNumberModel { _toFragment() }
    }
  }

  /// Role
  ///
  /// Parent Type: `Role`
  public struct Role: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Role }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(UserRole.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var name: String { __data["name"] }
    public var orgId: ZalaAPI.ID? { __data["orgId"] }
    public var role: String { __data["role"] }
    public var count: Int? { __data["count"] }
    public var org: Org? { __data["org"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var userRole: UserRole { _toFragment() }
    }

    public typealias Org = UserRole.Org
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
