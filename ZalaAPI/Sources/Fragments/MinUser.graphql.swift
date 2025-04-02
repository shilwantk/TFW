// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct MinUser: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment MinUser on User { __typename id firstName fullName token emails { __typename ...EmailModel } roleNames roles { __typename ...UserRole } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("firstName", String?.self),
    .field("fullName", String?.self),
    .field("token", String?.self),
    .field("emails", [Email]?.self),
    .field("roleNames", [String]?.self),
    .field("roles", [Role]?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var firstName: String? { __data["firstName"] }
  public var fullName: String? { __data["fullName"] }
  public var token: String? { __data["token"] }
  public var emails: [Email]? { __data["emails"] }
  public var roleNames: [String]? { __data["roleNames"] }
  public var roles: [Role]? { __data["roles"] }

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
}
