// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct DataValueSourceInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    name: GraphQLNullable<String> = nil,
    identifier: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "name": name,
      "identifier": identifier
    ])
  }

  public var name: GraphQLNullable<String> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  public var identifier: GraphQLNullable<String> {
    get { __data["identifier"] }
    set { __data["identifier"] = newValue }
  }
}
