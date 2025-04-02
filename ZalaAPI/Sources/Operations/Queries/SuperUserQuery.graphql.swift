// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SuperUserQuery: GraphQLQuery {
  public static let operationName: String = "SuperUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SuperUser($id: ID, $labels: [String!]) { user(id: $id) { __typename ...UserModel } }"#,
      fragments: [AddressModel.self, AttachmentModel.self, EmailModel.self, PhoneNumberModel.self, PreferenceModel.self, UserModel.self, UserRole.self]
    ))

  public var id: GraphQLNullable<ID>
  public var labels: GraphQLNullable<[String]>

  public init(
    id: GraphQLNullable<ID>,
    labels: GraphQLNullable<[String]>
  ) {
    self.id = id
    self.labels = labels
  }

  public var __variables: Variables? { [
    "id": id,
    "labels": labels
  ] }

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
        .fragment(UserModel.self),
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

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var userModel: UserModel { _toFragment() }
      }

      public typealias Address = UserModel.Address

      public typealias Attachment = UserModel.Attachment

      public typealias Email = UserModel.Email

      public typealias Phone = UserModel.Phone

      public typealias Role = UserModel.Role

      public typealias Preference = UserModel.Preference
    }
  }
}
