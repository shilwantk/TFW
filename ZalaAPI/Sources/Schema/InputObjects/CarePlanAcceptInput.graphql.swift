// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct CarePlanAcceptInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: ID,
    startDate: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "id": id,
      "startDate": startDate
    ])
  }

  /// CarePlan.UUID
  public var id: ID {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  /// Day to start the plan on. Default[today]
  public var startDate: GraphQLNullable<String> {
    get { __data["startDate"] }
    set { __data["startDate"] = newValue }
  }
}
