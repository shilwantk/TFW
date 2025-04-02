// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AddressesEmailInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    address: String,
    label: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "address": address,
      "label": label
    ])
  }

  public var address: String {
    get { __data["address"] }
    set { __data["address"] = newValue }
  }

  /// default(main)
  public var label: GraphQLNullable<String> {
    get { __data["label"] }
    set { __data["label"] = newValue }
  }
}
