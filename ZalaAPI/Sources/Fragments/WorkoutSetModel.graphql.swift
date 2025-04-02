// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct WorkoutSetModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment WorkoutSetModel on WorkoutSet { __typename id rest status reps rpe distance weight time }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutSet }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("rest", String?.self),
    .field("status", String?.self),
    .field("reps", Int?.self),
    .field("rpe", Int?.self),
    .field("distance", String?.self),
    .field("weight", String?.self),
    .field("time", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var rest: String? { __data["rest"] }
  public var status: String? { __data["status"] }
  public var reps: Int? { __data["reps"] }
  /// Rate of Perceived Exertion (BORG Scale: 6-20)
  public var rpe: Int? { __data["rpe"] }
  public var distance: String? { __data["distance"] }
  public var weight: String? { __data["weight"] }
  public var time: String? { __data["time"] }
}
