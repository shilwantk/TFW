// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct DeviceRegisterInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    user: ID,
    deviceId: String,
    kind: String,
    name: GraphQLNullable<String> = nil,
    production: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "user": user,
      "deviceId": deviceId,
      "kind": kind,
      "name": name,
      "production": production
    ])
  }

  public var user: ID {
    get { __data["user"] }
    set { __data["user"] = newValue }
  }

  public var deviceId: String {
    get { __data["deviceId"] }
    set { __data["deviceId"] = newValue }
  }

  /// ios or android
  public var kind: String {
    get { __data["kind"] }
    set { __data["kind"] = newValue }
  }

  public var name: GraphQLNullable<String> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  /// String[1, 0, true, false] default[true]
  public var production: GraphQLNullable<String> {
    get { __data["production"] }
    set { __data["production"] = newValue }
  }
}
