// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CreateVitalMutation: GraphQLMutation {
  public static let operationName: String = "CreateVital"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateVital($input: UserAddDataInput) { userAddData(input: $input) { __typename errors { __typename ...ErrorModel } user { __typename id } } }"#,
      fragments: [ErrorModel.self]
    ))

  public var input: GraphQLNullable<UserAddDataInput>

  public init(input: GraphQLNullable<UserAddDataInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("userAddData", UserAddData?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Creates HS for Logged in User; saves data to it; closes it
    public var userAddData: UserAddData? { __data["userAddData"] }

    /// UserAddData
    ///
    /// Parent Type: `UserAddDataPayload`
    public struct UserAddData: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserAddDataPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("errors", [Error_SelectionSet]?.self),
        .field("user", User?.self),
      ] }

      public var errors: [Error_SelectionSet]? { __data["errors"] }
      public var user: User? { __data["user"] }

      /// UserAddData.Error_SelectionSet
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

      /// UserAddData.User
      ///
      /// Parent Type: `User`
      public struct User: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
      }
    }
  }
}
