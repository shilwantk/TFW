// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class NotificationMarkReadMutation: GraphQLMutation {
  public static let operationName: String = "NotificationMarkRead"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation NotificationMarkRead($input: UserNotificationMarkReadInput!) { notificationMarkRead(input: $input) { __typename success } }"#
    ))

  public var input: UserNotificationMarkReadInput

  public init(input: UserNotificationMarkReadInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("notificationMarkRead", NotificationMarkRead?.self, arguments: ["input": .variable("input")]),
    ] }

    public var notificationMarkRead: NotificationMarkRead? { __data["notificationMarkRead"] }

    /// NotificationMarkRead
    ///
    /// Parent Type: `UserNotificationMarkReadPayload`
    public struct NotificationMarkRead: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserNotificationMarkReadPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool?.self),
      ] }

      public var success: Bool? { __data["success"] }
    }
  }
}
