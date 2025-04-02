// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class FetchPreferenceQuery: GraphQLQuery {
  public static let operationName: String = "FetchPreference"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchPreference($id: ID) { user(id: $id) { __typename preferences { __typename ...PreferenceModel } } }"#,
      fragments: [PreferenceModel.self]
    ))

  public var id: GraphQLNullable<ID>

  public init(id: GraphQLNullable<ID>) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["id": .variable("id")]),
    ] }

    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("preferences", [Preference]?.self),
      ] }

      /// Preferences
      public var preferences: [Preference]? { __data["preferences"] }

      /// User.Preference
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
  }
}
