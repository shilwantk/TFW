// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct DeviceModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment DeviceModel on Device { __typename id name kind deviceId createdAt updatedAt lastSentAt }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Device }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("name", String?.self),
    .field("kind", String?.self),
    .field("deviceId", String?.self),
    .field("createdAt", Int?.self),
    .field("updatedAt", Int?.self),
    .field("lastSentAt", Int?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var name: String? { __data["name"] }
  public var kind: String? { __data["kind"] }
  public var deviceId: String? { __data["deviceId"] }
  public var createdAt: Int? { __data["createdAt"] }
  public var updatedAt: Int? { __data["updatedAt"] }
  public var lastSentAt: Int? { __data["lastSentAt"] }
}
