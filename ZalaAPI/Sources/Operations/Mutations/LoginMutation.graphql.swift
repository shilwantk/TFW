// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LoginMutation: GraphQLMutation {
  public static let operationName: String = "Login"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation Login($input: UserLoginInput!) { login(input: $input) { __typename errors { __typename ...ErrorModel } user { __typename ...MinUser } } }"#,
      fragments: [EmailModel.self, ErrorModel.self, MinUser.self, UserRole.self]
    ))

  public var input: UserLoginInput

  public init(input: UserLoginInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("login", Login?.self, arguments: ["input": .variable("input")]),
    ] }

    public var login: Login? { __data["login"] }

    /// Login
    ///
    /// Parent Type: `UserLoginPayload`
    public struct Login: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserLoginPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("errors", [Error_SelectionSet]?.self),
        .field("user", User?.self),
      ] }

      public var errors: [Error_SelectionSet]? { __data["errors"] }
      public var user: User? { __data["user"] }

      /// Login.Error_SelectionSet
      ///
      /// Parent Type: `Error_Object`
      public struct Error_SelectionSet: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Error_Object }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(ErrorModel.self),
        ] }

        public var code: Int? { __data["code"] }
        public var message: String? { __data["message"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var errorModel: ErrorModel { _toFragment() }
        }
      }

      /// Login.User
      ///
      /// Parent Type: `User`
      public struct User: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MinUser.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var firstName: String? { __data["firstName"] }
        public var fullName: String? { __data["fullName"] }
        public var token: String? { __data["token"] }
        public var emails: [Email]? { __data["emails"] }
        public var roleNames: [String]? { __data["roleNames"] }
        public var roles: [Role]? { __data["roles"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var minUser: MinUser { _toFragment() }
        }

        public typealias Email = MinUser.Email

        public typealias Role = MinUser.Role
      }
    }
  }
}
