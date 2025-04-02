// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct UserAddDataInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    user: GraphQLNullable<ID> = nil,
    kind: GraphQLNullable<String> = nil,
    name: GraphQLNullable<String> = nil,
    beginEpoch: GraphQLNullable<Int> = nil,
    data: GraphQLNullable<[AnswerInput]> = nil
  ) {
    __data = InputDict([
      "user": user,
      "kind": kind,
      "name": name,
      "beginEpoch": beginEpoch,
      "data": data
    ])
  }

  /// User to add data to [default: viewing || current]
  public var user: GraphQLNullable<ID> {
    get { __data["user"] }
    set { __data["user"] = newValue }
  }

  /// The kind of HS to create for this data
  public var kind: GraphQLNullable<String> {
    get { __data["kind"] }
    set { __data["kind"] = newValue }
  }

  /// Name for the auto-created HealthSnap
  public var name: GraphQLNullable<String> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  public var beginEpoch: GraphQLNullable<Int> {
    get { __data["beginEpoch"] }
    set { __data["beginEpoch"] = newValue }
  }

  public var data: GraphQLNullable<[AnswerInput]> {
    get { __data["data"] }
    set { __data["data"] = newValue }
  }
}
