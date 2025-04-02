// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UpdateUserMutation: GraphQLMutation {
  public static let operationName: String = "UpdateUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdateUser($input: UserUpdateInput, $labels: [String!]) { userUpdate(input: $input) { __typename user { __typename ...Account } } }"#,
      fragments: [Account.self, AddressModel.self, AttachmentModel.self, EmailModel.self, PhoneNumberModel.self, PreferenceModel.self, UserRole.self]
    ))

  public var input: GraphQLNullable<UserUpdateInput>
  public var labels: GraphQLNullable<[String]>

  public init(
    input: GraphQLNullable<UserUpdateInput>,
    labels: GraphQLNullable<[String]>
  ) {
    self.input = input
    self.labels = labels
  }

  public var __variables: Variables? { [
    "input": input,
    "labels": labels
  ] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("userUpdate", UserUpdate?.self, arguments: ["input": .variable("input")]),
    ] }

    public var userUpdate: UserUpdate? { __data["userUpdate"] }

    /// UserUpdate
    ///
    /// Parent Type: `UserUpdatePayload`
    public struct UserUpdate: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserUpdatePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("user", User?.self),
      ] }

      public var user: User? { __data["user"] }

      /// UserUpdate.User
      ///
      /// Parent Type: `User`
      public struct User: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(Account.self),
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

          public var account: Account { _toFragment() }
        }

        public typealias Address = Account.Address

        public typealias Attachment = Account.Attachment

        public typealias Email = Account.Email

        public typealias Phone = Account.Phone

        public typealias Role = Account.Role

        public typealias Preference = Account.Preference
      }
    }
  }
}
