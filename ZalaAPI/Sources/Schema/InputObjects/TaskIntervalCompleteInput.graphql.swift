// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct TaskIntervalCompleteInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    interval: ID,
    compliance: GraphQLNullable<Double> = nil
  ) {
    __data = InputDict([
      "interval": interval,
      "compliance": compliance
    ])
  }

  /// Task Interval ID
  public var interval: ID {
    get { __data["interval"] }
    set { __data["interval"] = newValue }
  }

  /// Compliance % [default: 100.0]
  public var compliance: GraphQLNullable<Double> {
    get { __data["compliance"] }
    set { __data["compliance"] = newValue }
  }
}
