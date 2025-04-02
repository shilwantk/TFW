// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct RoleInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    role: String,
    orgId: GraphQLNullable<ID> = nil
  ) {
    __data = InputDict([
      "role": role,
      "orgId": orgId
    ])
  }

  public var role: String {
    get { __data["role"] }
    set { __data["role"] = newValue }
  }

  public var orgId: GraphQLNullable<ID> {
    get { __data["orgId"] }
    set { __data["orgId"] = newValue }
  }
}
