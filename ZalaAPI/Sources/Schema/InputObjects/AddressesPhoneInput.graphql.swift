// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AddressesPhoneInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    number: String,
    label: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "number": number,
      "label": label
    ])
  }

  public var number: String {
    get { __data["number"] }
    set { __data["number"] = newValue }
  }

  /// default(main)
  public var label: GraphQLNullable<String> {
    get { __data["label"] }
    set { __data["label"] = newValue }
  }
}
