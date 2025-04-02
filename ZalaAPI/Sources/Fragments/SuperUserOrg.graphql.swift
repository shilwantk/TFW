// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct SuperUserOrg: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment SuperUserOrg on Organization { __typename id name providers { __typename nodes { __typename ...SuperUser } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Organization }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("name", String?.self),
    .field("providers", Providers?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var name: String? { __data["name"] }
  public var providers: Providers? { __data["providers"] }

  /// Providers
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

    /// Providers.Node
    ///
    /// Parent Type: `Provider`
    public struct Node: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Provider }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(SuperUser.self),
      ] }

      public var id: ZalaAPI.ID? { __data["id"] }
      public var attachments: [Attachment]? { __data["attachments"] }
      public var firstName: String? { __data["firstName"] }
      public var lastName: String? { __data["lastName"] }
      /// User Preferences
      public var preferences: [Preference]? { __data["preferences"] }
      public var organizations: [Organization]? { __data["organizations"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var superUser: SuperUser { _toFragment() }
      }

      public typealias Attachment = SuperUser.Attachment

      public typealias Preference = SuperUser.Preference

      public typealias Organization = SuperUser.Organization
    }
  }
}
