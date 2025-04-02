// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class NotificationsQuery: GraphQLQuery {
  public static let operationName: String = "NotificationsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query NotificationsQuery { me { __typename id notifications { __typename nodes { __typename ...NotificationModel } } } }"#,
      fragments: [NotificationModel.self]
    ))

  public init() {}

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("me", Me?.self),
    ] }

    public var me: Me? { __data["me"] }

    /// Me
    ///
    /// Parent Type: `User`
    public struct Me: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", ZalaAPI.ID?.self),
        .field("notifications", Notifications?.self),
      ] }

      public var id: ZalaAPI.ID? { __data["id"] }
      public var notifications: Notifications? { __data["notifications"] }

      /// Me.Notifications
      ///
      /// Parent Type: `UserNotificationConnection`
      public struct Notifications: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserNotificationConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Me.Notifications.Node
        ///
        /// Parent Type: `UserNotification`
        public struct Node: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserNotification }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(NotificationModel.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var createdAtIso: String? { __data["createdAtIso"] }
          public var content: String? { __data["content"] }
          public var subject: String? { __data["subject"] }
          public var readAtIso: ZalaAPI.ISO8601DateTime? { __data["readAtIso"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var notificationModel: NotificationModel { _toFragment() }
          }
        }
      }
    }
  }
}
