// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class DeleteAttachmentMutation: GraphQLMutation {
  public static let operationName: String = "DeleteAttachment"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation DeleteAttachment($input: IDInput) { attachmentRemove(input: $input) { __typename success } }"#
    ))

  public var input: GraphQLNullable<IDInput>

  public init(input: GraphQLNullable<IDInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("attachmentRemove", AttachmentRemove?.self, arguments: ["input": .variable("input")]),
    ] }

    public var attachmentRemove: AttachmentRemove? { __data["attachmentRemove"] }

    /// AttachmentRemove
    ///
    /// Parent Type: `AttachmentRemovePayload`
    public struct AttachmentRemove: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AttachmentRemovePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool?.self),
      ] }

      public var success: Bool? { __data["success"] }
    }
  }
}
