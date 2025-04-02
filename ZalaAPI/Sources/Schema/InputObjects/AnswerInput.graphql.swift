// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AnswerInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    key: String,
    data: GraphQLNullable<[String]> = nil,
    datum: GraphQLNullable<String> = nil,
    units: GraphQLNullable<[String]> = nil,
    unit: GraphQLNullable<String> = nil,
    beginEpoch: GraphQLNullable<Int> = nil,
    endEpoch: GraphQLNullable<Int> = nil,
    note: GraphQLNullable<AnswerNoteInput> = nil,
    source: GraphQLNullable<DataValueSourceInput> = nil
  ) {
    __data = InputDict([
      "key": key,
      "data": data,
      "datum": datum,
      "units": units,
      "unit": unit,
      "beginEpoch": beginEpoch,
      "endEpoch": endEpoch,
      "note": note,
      "source": source
    ])
  }

  public var key: String {
    get { __data["key"] }
    set { __data["key"] = newValue }
  }

  /// Use for multiple values, or single value in an array
  public var data: GraphQLNullable<[String]> {
    get { __data["data"] }
    set { __data["data"] = newValue }
  }

  /// Use for a single value
  public var datum: GraphQLNullable<String> {
    get { __data["datum"] }
    set { __data["datum"] = newValue }
  }

  public var units: GraphQLNullable<[String]> {
    get { __data["units"] }
    set { __data["units"] = newValue }
  }

  /// Use for a single unit
  public var unit: GraphQLNullable<String> {
    get { __data["unit"] }
    set { __data["unit"] = newValue }
  }

  public var beginEpoch: GraphQLNullable<Int> {
    get { __data["beginEpoch"] }
    set { __data["beginEpoch"] = newValue }
  }

  public var endEpoch: GraphQLNullable<Int> {
    get { __data["endEpoch"] }
    set { __data["endEpoch"] = newValue }
  }

  public var note: GraphQLNullable<AnswerNoteInput> {
    get { __data["note"] }
    set { __data["note"] = newValue }
  }

  public var source: GraphQLNullable<DataValueSourceInput> {
    get { __data["source"] }
    set { __data["source"] = newValue }
  }
}
