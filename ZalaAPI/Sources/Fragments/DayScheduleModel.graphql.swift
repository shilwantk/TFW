// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct DayScheduleModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment DayScheduleModel on ServiceDaySchedule { __typename id day dayName startTime endTime }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ServiceDaySchedule }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("day", Int?.self),
    .field("dayName", String?.self),
    .field("startTime", Int?.self),
    .field("endTime", Int?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var day: Int? { __data["day"] }
  public var dayName: String? { __data["dayName"] }
  public var startTime: Int? { __data["startTime"] }
  public var endTime: Int? { __data["endTime"] }
}
