// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AttachmentCreateInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    user: GraphQLNullable<ID> = nil,
    label: GraphQLNullable<String> = nil,
    base64: String
  ) {
    __data = InputDict([
      "user": user,
      "label": label,
      "base64": base64
    ])
  }

  public var user: GraphQLNullable<ID> {
    get { __data["user"] }
    set { __data["user"] = newValue }
  }

  public var label: GraphQLNullable<String> {
    get { __data["label"] }
    set { __data["label"] = newValue }
  }

  public var base64: String {
    get { __data["base64"] }
    set { __data["base64"] = newValue }
  }
}
