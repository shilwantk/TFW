// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct WorkoutRoutineUpdateInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: ID,
    title: GraphQLNullable<String> = nil,
    duration: GraphQLNullable<Int> = nil,
    action: GraphQLNullable<String> = nil,
    attachments: GraphQLNullable<[AttachmentInput]> = nil,
    focus: GraphQLNullable<String> = nil,
    description: GraphQLNullable<String> = nil,
    requirements: GraphQLNullable<[String]> = nil
  ) {
    __data = InputDict([
      "id": id,
      "title": title,
      "duration": duration,
      "action": action,
      "attachments": attachments,
      "focus": focus,
      "description": description,
      "requirements": requirements
    ])
  }

  public var id: ID {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var title: GraphQLNullable<String> {
    get { __data["title"] }
    set { __data["title"] = newValue }
  }

  public var duration: GraphQLNullable<Int> {
    get { __data["duration"] }
    set { __data["duration"] = newValue }
  }

  /// activate, deactivate, archive, cancel, complete
  public var action: GraphQLNullable<String> {
    get { __data["action"] }
    set { __data["action"] = newValue }
  }

  public var attachments: GraphQLNullable<[AttachmentInput]> {
    get { __data["attachments"] }
    set { __data["attachments"] = newValue }
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
}
