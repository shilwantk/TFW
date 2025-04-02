// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ViewingRoutinesQuery: GraphQLQuery {
  public static let operationName: String = "ViewingRoutinesQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ViewingRoutinesQuery($id: ID, $user: ID, $order: String, $status: [String!], $labels: [String!], $taskStatus: String) { viewing(org: $id, user: $user) { __typename org { __typename id carePlans(order: $order, status: $status) { __typename ...MinCarePlan } } user { __typename id attachments(labels: $labels) { __typename ...AttachmentModel } firstName lastName } } }"#,
      fragments: [AttachmentModel.self, MinCarePlan.self]
    ))

  public var id: GraphQLNullable<ID>
  public var user: GraphQLNullable<ID>
  public var order: GraphQLNullable<String>
  public var status: GraphQLNullable<[String]>
  public var labels: GraphQLNullable<[String]>
  public var taskStatus: GraphQLNullable<String>

  public init(
    id: GraphQLNullable<ID>,
    user: GraphQLNullable<ID>,
    order: GraphQLNullable<String>,
    status: GraphQLNullable<[String]>,
    labels: GraphQLNullable<[String]>,
    taskStatus: GraphQLNullable<String>
  ) {
    self.id = id
    self.user = user
    self.order = order
    self.status = status
    self.labels = labels
    self.taskStatus = taskStatus
  }

  public var __variables: Variables? { [
    "id": id,
    "user": user,
    "order": order,
    "status": status,
    "labels": labels,
    "taskStatus": taskStatus
  ] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("viewing", Viewing?.self, arguments: [
        "org": .variable("id"),
        "user": .variable("user")
      ]),
    ] }

    public var viewing: Viewing? { __data["viewing"] }

    /// Viewing
    ///
    /// Parent Type: `Viewing`
    public struct Viewing: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Viewing }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("org", Org?.self),
        .field("user", User?.self),
      ] }

      public var org: Org? { __data["org"] }
      public var user: User? { __data["user"] }

      /// Viewing.Org
      ///
      /// Parent Type: `Organization`
      public struct Org: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Organization }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
          .field("carePlans", [CarePlan]?.self, arguments: [
            "order": .variable("order"),
            "status": .variable("status")
          ]),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var carePlans: [CarePlan]? { __data["carePlans"] }

        /// Viewing.Org.CarePlan
        ///
        /// Parent Type: `CarePlan`
        public struct CarePlan: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlan }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(MinCarePlan.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var name: String? { __data["name"] }
          public var description: String? { __data["description"] }
          public var status: String? { __data["status"] }
          public var focus: String? { __data["focus"] }
          public var endAtIso: String? { __data["endAtIso"] }
          public var createdAtIso: String? { __data["createdAtIso"] }
          public var periodDurationDays: Int? { __data["periodDurationDays"] }
          public var durationInDays: Int? { __data["durationInDays"] }
          public var organizationId: ZalaAPI.ID? { __data["organizationId"] }
          public var complianceScore: ComplianceScore? { __data["complianceScore"] }
          public var monitors: [Monitor]? { __data["monitors"] }
          public var attachments: [Attachment]? { __data["attachments"] }
          public var tasks: [Task]? { __data["tasks"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var minCarePlan: MinCarePlan { _toFragment() }
          }

          public typealias ComplianceScore = MinCarePlan.ComplianceScore

          public typealias Monitor = MinCarePlan.Monitor

          public typealias Attachment = MinCarePlan.Attachment

          public typealias Task = MinCarePlan.Task
        }
      }

      /// Viewing.User
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
          .field("firstName", String?.self),
          .field("lastName", String?.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var attachments: [Attachment]? { __data["attachments"] }
        public var firstName: String? { __data["firstName"] }
        public var lastName: String? { __data["lastName"] }

        /// Viewing.User.Attachment
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
}
