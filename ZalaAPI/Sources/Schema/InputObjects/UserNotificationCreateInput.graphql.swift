// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct UserNotificationCreateInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    user: GraphQLNullable<ID> = nil,
    subject: String,
    content: String
  ) {
    __data = InputDict([
      "user": user,
      "subject": subject,
      "content": content
    ])
  }

  /// ID of User to send a specific notification to [Goes to everyone if set to nil]
  public var user: GraphQLNullable<ID> {
    get { __data["user"] }
    set { __data["user"] = newValue }
  }

  public var subject: String {
    get { __data["subject"] }
    set { __data["subject"] = newValue }
  }

  public var content: String {
    get { __data["content"] }
    set { __data["content"] = newValue }
  }
}
