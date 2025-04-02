// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UserRequestPasswordResetMutation: GraphQLMutation {
  public static let operationName: String = "UserRequestPasswordReset"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UserRequestPasswordReset($email: String!, $org: ID) { userRequestPasswordReset(email: $email, org: $org) { __typename success errors { __typename ...ErrorModel } } }"#,
      fragments: [ErrorModel.self]
    ))

  public var email: String
  public var org: GraphQLNullable<ID>

  public init(
    email: String,
    org: GraphQLNullable<ID>
  ) {
    self.email = email
    self.org = org
  }

  public var __variables: Variables? { [
    "email": email,
    "org": org
  ] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("userRequestPasswordReset", UserRequestPasswordReset?.self, arguments: [
        "email": .variable("email"),
        "org": .variable("org")
      ]),
    ] }

    public var userRequestPasswordReset: UserRequestPasswordReset? { __data["userRequestPasswordReset"] }

    /// UserRequestPasswordReset
    ///
    /// Parent Type: `UserRequestPasswordResetPayload`
    public struct UserRequestPasswordReset: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserRequestPasswordResetPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool?.self),
        .field("errors", [Error_SelectionSet]?.self),
      ] }

      public var success: Bool? { __data["success"] }
      public var errors: [Error_SelectionSet]? { __data["errors"] }

      /// UserRequestPasswordReset.Error_SelectionSet
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
    }
  }
}
