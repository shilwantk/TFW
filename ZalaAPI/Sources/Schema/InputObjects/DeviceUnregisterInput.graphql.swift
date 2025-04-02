// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct DeviceUnregisterInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    deviceId: String
  ) {
    __data = InputDict([
      "deviceId": deviceId
    ])
  }

  public var deviceId: String {
    get { __data["deviceId"] }
    set { __data["deviceId"] = newValue }
  }
}
