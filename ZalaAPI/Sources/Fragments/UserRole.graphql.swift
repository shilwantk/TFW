// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct UserRole: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment UserRole on Role { __typename id name orgId role count org { __typename id name } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Role }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("name", String.self),
    .field("orgId", ZalaAPI.ID?.self),
    .field("role", String.self),
    .field("count", Int?.self),
    .field("org", Org?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var name: String { __data["name"] }
  public var orgId: ZalaAPI.ID? { __data["orgId"] }
  public var role: String { __data["role"] }
  public var count: Int? { __data["count"] }
  public var org: Org? { __data["org"] }

  /// Org
  ///
  /// Parent Type: `Organization`
  public struct Org: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Organization }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", ZalaAPI.ID?.self),
      .field("name", String?.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var name: String? { __data["name"] }
  }
}
