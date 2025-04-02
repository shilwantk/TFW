// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct NotificationModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment NotificationModel on UserNotification { __typename id createdAtIso content subject readAtIso }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserNotification }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("createdAtIso", String?.self),
    .field("content", String?.self),
    .field("subject", String?.self),
    .field("readAtIso", ZalaAPI.ISO8601DateTime?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var createdAtIso: String? { __data["createdAtIso"] }
  public var content: String? { __data["content"] }
  public var subject: String? { __data["subject"] }
  public var readAtIso: ZalaAPI.ISO8601DateTime? { __data["readAtIso"] }
}
