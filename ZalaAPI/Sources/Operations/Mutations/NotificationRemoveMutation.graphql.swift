// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class NotificationRemoveMutation: GraphQLMutation {
  public static let operationName: String = "NotificationRemove"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation NotificationRemove($input: IDInput!) { notificationRemove(input: $input) { __typename success } }"#
    ))

  public var input: IDInput

  public init(input: IDInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("notificationRemove", NotificationRemove?.self, arguments: ["input": .variable("input")]),
    ] }

    public var notificationRemove: NotificationRemove? { __data["notificationRemove"] }

    /// NotificationRemove
    ///
    /// Parent Type: `UserNotificationRemovePayload`
    public struct NotificationRemove: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserNotificationRemovePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool?.self),
      ] }

      public var success: Bool? { __data["success"] }
    }
  }
}
