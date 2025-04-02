// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct UserLoginInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    email: String,
    orgId: GraphQLNullable<ID> = nil,
    role: GraphQLNullable<String> = nil,
    password: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "email": email,
      "orgId": orgId,
      "role": role,
      "password": password
    ])
  }

  public var email: String {
    get { __data["email"] }
    set { __data["email"] = newValue }
  }

  public var orgId: GraphQLNullable<ID> {
    get { __data["orgId"] }
    set { __data["orgId"] = newValue }
  }

  public var role: GraphQLNullable<String> {
    get { __data["role"] }
    set { __data["role"] = newValue }
  }

  public var password: GraphQLNullable<String> {
    get { __data["password"] }
    set { __data["password"] = newValue }
  }
}
