// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AttachmentInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    label: String,
    base64: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "label": label,
      "base64": base64
    ])
  }

  public var label: String {
    get { __data["label"] }
    set { __data["label"] = newValue }
  }

  public var base64: GraphQLNullable<String> {
    get { __data["base64"] }
    set { __data["base64"] = newValue }
  }
}
