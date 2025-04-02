// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct CarePlanAssignInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: ID,
    user: ID,
    inviteMessage: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "id": id,
      "user": user,
      "inviteMessage": inviteMessage
    ])
  }

  /// CarePlan.UUID
  public var id: ID {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  /// ID of user to assign to
  public var user: ID {
    get { __data["user"] }
    set { __data["user"] = newValue }
  }

  /// Optional Invite Message
  public var inviteMessage: GraphQLNullable<String> {
    get { __data["inviteMessage"] }
    set { __data["inviteMessage"] = newValue }
  }
}
