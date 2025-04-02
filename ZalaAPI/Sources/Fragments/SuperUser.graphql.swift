// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct SuperUser: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment SuperUser on Provider { __typename id attachments(labels: $labels) { __typename ...AttachmentModel } firstName lastName preferences { __typename ...PreferenceModel } organizations { __typename id name roles { __typename ...UserRole } providers { __typename nodes { __typename id } } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Provider }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("attachments", [Attachment]?.self, arguments: ["labels": .variable("labels")]),
    .field("firstName", String?.self),
    .field("lastName", String?.self),
    .field("preferences", [Preference]?.self),
    .field("organizations", [Organization]?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var attachments: [Attachment]? { __data["attachments"] }
  public var firstName: String? { __data["firstName"] }
  public var lastName: String? { __data["lastName"] }
  /// User Preferences
  public var preferences: [Preference]? { __data["preferences"] }
  public var organizations: [Organization]? { __data["organizations"] }

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

  /// Organization
  ///
  /// Parent Type: `Organization`
  public struct Organization: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Organization }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", ZalaAPI.ID?.self),
      .field("name", String?.self),
      .field("roles", [Role]?.self),
      .field("providers", Providers?.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var name: String? { __data["name"] }
    public var roles: [Role]? { __data["roles"] }
    public var providers: Providers? { __data["providers"] }

    /// Organization.Role
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

    /// Organization.Providers
    ///
    /// Parent Type: `ProviderConnection`
    public struct Providers: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ProviderConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("nodes", [Node?]?.self),
      ] }

      /// A list of nodes.
      public var nodes: [Node?]? { __data["nodes"] }

      /// Organization.Providers.Node
      ///
      /// Parent Type: `Provider`
      public struct Node: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Provider }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
      }
    }
  }
}
