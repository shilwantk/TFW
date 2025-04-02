// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CreateAttachmentMutation: GraphQLMutation {
  public static let operationName: String = "CreateAttachment"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateAttachment($auth: String, $input: AttachmentCreateInput) { attachmentCreate(auth: $auth, input: $input) { __typename errors { __typename message } attachment { __typename ...AttachmentModel } } }"#,
      fragments: [AttachmentModel.self]
    ))

  public var auth: GraphQLNullable<String>
  public var input: GraphQLNullable<AttachmentCreateInput>

  public init(
    auth: GraphQLNullable<String>,
    input: GraphQLNullable<AttachmentCreateInput>
  ) {
    self.auth = auth
    self.input = input
  }

  public var __variables: Variables? { [
    "auth": auth,
    "input": input
  ] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("attachmentCreate", AttachmentCreate?.self, arguments: [
        "auth": .variable("auth"),
        "input": .variable("input")
      ]),
    ] }

    public var attachmentCreate: AttachmentCreate? { __data["attachmentCreate"] }

    /// AttachmentCreate
    ///
    /// Parent Type: `AttachmentCreatePayload`
    public struct AttachmentCreate: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AttachmentCreatePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("errors", [Error_SelectionSet]?.self),
        .field("attachment", Attachment?.self),
      ] }

      public var errors: [Error_SelectionSet]? { __data["errors"] }
      public var attachment: Attachment? { __data["attachment"] }

      /// AttachmentCreate.Error_SelectionSet
      ///
      /// Parent Type: `Error_Object`
      public struct Error_SelectionSet: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Error_Object }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("message", String?.self),
        ] }

        public var message: String? { __data["message"] }
      }

      /// AttachmentCreate.Attachment
      ///
      /// Parent Type: `Attachment`
      public struct Attachment: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Attachment }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(AttachmentModel.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var label: String? { __data["label"] }
        public var contentUrl: String? { __data["contentUrl"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var attachmentModel: AttachmentModel { _toFragment() }
        }
      }
    }
  }
}
