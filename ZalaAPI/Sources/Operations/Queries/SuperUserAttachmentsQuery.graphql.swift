// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SuperUserAttachmentsQuery: GraphQLQuery {
  public static let operationName: String = "SuperUserAttachments"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SuperUserAttachments($id: ID, $labels: [String!]) { user(id: $id) { __typename id attachments(labels: $labels) { __typename ...AttachmentModel } } }"#,
      fragments: [AttachmentModel.self]
    ))

  public var id: GraphQLNullable<ID>
  public var labels: GraphQLNullable<[String]>

  public init(
    id: GraphQLNullable<ID>,
    labels: GraphQLNullable<[String]>
  ) {
    self.id = id
    self.labels = labels
  }

  public var __variables: Variables? { [
    "id": id,
    "labels": labels
  ] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["id": .variable("id")]),
    ] }

    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", ZalaAPI.ID?.self),
        .field("attachments", [Attachment]?.self, arguments: ["labels": .variable("labels")]),
      ] }

      public var id: ZalaAPI.ID? { __data["id"] }
      public var attachments: [Attachment]? { __data["attachments"] }

      /// User.Attachment
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
