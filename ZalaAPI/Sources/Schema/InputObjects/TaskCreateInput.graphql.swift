// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct TaskCreateInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    carePlan: ID,
    key: String,
    title: GraphQLNullable<String> = nil,
    desc: GraphQLNullable<String> = nil,
    testType: GraphQLNullable<String> = nil,
    data: GraphQLNullable<[Double]> = nil,
    unit: GraphQLNullable<String> = nil,
    interval: GraphQLNullable<String> = nil,
    timeFrames: GraphQLNullable<[String]> = nil,
    mealInfo: GraphQLNullable<String> = nil,
    daysOfWeek: GraphQLNullable<[String]> = nil,
    daysOfMonth: GraphQLNullable<[Int]> = nil
  ) {
    __data = InputDict([
      "carePlan": carePlan,
      "key": key,
      "title": title,
      "desc": desc,
      "testType": testType,
      "data": data,
      "unit": unit,
      "interval": interval,
      "timeFrames": timeFrames,
      "mealInfo": mealInfo,
      "daysOfWeek": daysOfWeek,
      "daysOfMonth": daysOfMonth
    ])
  }

  /// CarePlan.UUID
  public var carePlan: ID {
    get { __data["carePlan"] }
    set { __data["carePlan"] = newValue }
  }

  public var key: String {
    get { __data["key"] }
    set { __data["key"] = newValue }
  }

  public var title: GraphQLNullable<String> {
    get { __data["title"] }
    set { __data["title"] = newValue }
  }

  public var desc: GraphQLNullable<String> {
    get { __data["desc"] }
    set { __data["desc"] = newValue }
  }

  /// at_least, at_most, maintain
  public var testType: GraphQLNullable<String> {
    get { __data["testType"] }
    set { __data["testType"] = newValue }
  }

  /// min_value, max_value - max is optional
  public var data: GraphQLNullable<[Double]> {
    get { __data["data"] }
    set { __data["data"] = newValue }
  }

  /// unit for values
  public var unit: GraphQLNullable<String> {
    get { __data["unit"] }
    set { __data["unit"] = newValue }
  }

  /// day, week, month
  public var interval: GraphQLNullable<String> {
    get { __data["interval"] }
    set { __data["interval"] = newValue }
  }

  /// [morning, afternoon, evening] || [anytime]
  public var timeFrames: GraphQLNullable<[String]> {
    get { __data["timeFrames"] }
    set { __data["timeFrames"] = newValue }
  }

  /// before, after, or anytime
  public var mealInfo: GraphQLNullable<String> {
    get { __data["mealInfo"] }
    set { __data["mealInfo"] = newValue }
  }

  /// [mon, tue, wed, thu, fri, sat, sun] || []
  public var daysOfWeek: GraphQLNullable<[String]> {
    get { __data["daysOfWeek"] }
    set { __data["daysOfWeek"] = newValue }
  }

  /// [1,15] - the days the task should trigger on
  public var daysOfMonth: GraphQLNullable<[Int]> {
    get { __data["daysOfMonth"] }
    set { __data["daysOfMonth"] = newValue }
  }
}
