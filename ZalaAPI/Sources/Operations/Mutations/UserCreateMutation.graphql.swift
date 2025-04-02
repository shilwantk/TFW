// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UserCreateMutation: GraphQLMutation {
  public static let operationName: String = "UserCreateMutation"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UserCreateMutation($input: UserCreateInput) { userCreate(input: $input) { __typename errors { __typename message } user { __typename id firstName lastName token } } }"#
    ))

  public var input: GraphQLNullable<UserCreateInput>

  public init(input: GraphQLNullable<UserCreateInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("userCreate", UserCreate?.self, arguments: ["input": .variable("input")]),
    ] }

    public var userCreate: UserCreate? { __data["userCreate"] }

    /// UserCreate
    ///
    /// Parent Type: `UserCreatePayload`
    public struct UserCreate: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserCreatePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("errors", [Error_SelectionSet]?.self),
        .field("user", User?.self),
      ] }

      public var errors: [Error_SelectionSet]? { __data["errors"] }
      public var user: User? { __data["user"] }

      /// UserCreate.Error_SelectionSet
      ///
      /// Parent Type: `Error_Object`
      public struct Error_SelectionSet: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Error_Object }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("message", String?.self),
        ] }

        public var message: String? { __data["message"] }
      }

      /// UserCreate.User
      ///
      /// Parent Type: `User`
      public struct User: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
          .field("firstName", String?.self),
          .field("lastName", String?.self),
          .field("token", String?.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var firstName: String? { __data["firstName"] }
        public var lastName: String? { __data["lastName"] }
        public var token: String? { __data["token"] }
      }
    }
  }
}
