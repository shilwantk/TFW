// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AnswerNoteInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    body: GraphQLNullable<String> = nil,
    author: GraphQLNullable<ID> = nil,
    `private`: GraphQLNullable<Bool> = nil
  ) {
    __data = InputDict([
      "body": body,
      "author": author,
      "private": `private`
    ])
  }

  public var body: GraphQLNullable<String> {
    get { __data["body"] }
    set { __data["body"] = newValue }
  }

  public var author: GraphQLNullable<ID> {
    get { __data["author"] }
    set { __data["author"] = newValue }
  }

  public var `private`: GraphQLNullable<Bool> {
    get { __data["private"] }
    set { __data["private"] = newValue }
  }
}
