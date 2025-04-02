// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class NotificationCreateMutation: GraphQLMutation {
  public static let operationName: String = "NotificationCreateMutation"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation NotificationCreateMutation($input: UserNotificationCreateInput!) { notificationCreate(input: $input) { __typename errors { __typename message } success } }"#
    ))

  public var input: UserNotificationCreateInput

  public init(input: UserNotificationCreateInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("notificationCreate", NotificationCreate?.self, arguments: ["input": .variable("input")]),
    ] }

    public var notificationCreate: NotificationCreate? { __data["notificationCreate"] }

    /// NotificationCreate
    ///
    /// Parent Type: `UserNotificationCreatePayload`
    public struct NotificationCreate: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserNotificationCreatePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("errors", [Error_SelectionSet]?.self),
        .field("success", Bool?.self),
      ] }

      public var errors: [Error_SelectionSet]? { __data["errors"] }
      public var success: Bool? { __data["success"] }

      /// NotificationCreate.Error_SelectionSet
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
    }
  }
}
