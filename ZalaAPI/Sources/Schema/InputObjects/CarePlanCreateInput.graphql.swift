// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct CarePlanCreateInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<ID> = nil,
    name: GraphQLNullable<String> = nil,
    focus: GraphQLNullable<String> = nil,
    description: GraphQLNullable<String> = nil,
    requirements: GraphQLNullable<[String]> = nil,
    durationInDays: GraphQLNullable<Int> = nil,
    attachments: GraphQLNullable<[AttachmentInput]> = nil
  ) {
    __data = InputDict([
      "id": id,
      "name": name,
      "focus": focus,
      "description": description,
      "requirements": requirements,
      "durationInDays": durationInDays,
      "attachments": attachments
    ])
  }

  /// CarePlan.UUID (client-side UUID, or leave blank for server-side UUID)
  public var id: GraphQLNullable<ID> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var name: GraphQLNullable<String> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  public var focus: GraphQLNullable<String> {
    get { __data["focus"] }
    set { __data["focus"] = newValue }
  }

  public var description: GraphQLNullable<String> {
    get { __data["description"] }
    set { __data["description"] = newValue }
  }

  public var requirements: GraphQLNullable<[String]> {
    get { __data["requirements"] }
    set { __data["requirements"] = newValue }
  }

  /// Number of Days the CarePlan will last
  public var durationInDays: GraphQLNullable<Int> {
    get { __data["durationInDays"] }
    set { __data["durationInDays"] = newValue }
  }

  public var attachments: GraphQLNullable<[AttachmentInput]> {
    get { __data["attachments"] }
    set { __data["attachments"] = newValue }
  }
}
