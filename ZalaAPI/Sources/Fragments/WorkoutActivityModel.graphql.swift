// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct WorkoutActivityModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment WorkoutActivityModel on WorkoutActivity { __typename id key name videoUrl uses categoryCode }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.WorkoutActivity }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("key", String?.self),
    .field("name", String?.self),
    .field("videoUrl", String?.self),
    .field("uses", [String]?.self),
    .field("categoryCode", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var key: String? { __data["key"] }
  public var name: String? { __data["name"] }
  public var videoUrl: String? { __data["videoUrl"] }
  public var uses: [String]? { __data["uses"] }
  public var categoryCode: String? { __data["categoryCode"] }
}
