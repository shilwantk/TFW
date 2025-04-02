// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct UserNotificationMarkReadInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<ID> = nil,
    user: GraphQLNullable<ID> = nil
  ) {
    __data = InputDict([
      "id": id,
      "user": user
    ])
  }

  /// ID of Notification to update
  public var id: GraphQLNullable<ID> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  /// ID of User that read the notification
  public var user: GraphQLNullable<ID> {
    get { __data["user"] }
    set { __data["user"] = newValue }
  }
}
