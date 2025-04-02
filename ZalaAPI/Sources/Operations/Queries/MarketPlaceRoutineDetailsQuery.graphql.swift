// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MarketPlaceRoutineDetailsQuery: GraphQLQuery {
  public static let operationName: String = "MarketPlaceRoutineDetailsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query MarketPlaceRoutineDetailsQuery($id: ID, $ids: [ID!], $labels: [String!], $taskStatus: String) { org(id: $id) { __typename carePlans(ids: $ids) { __typename ...MarketPlaceRoutine } } }"#,
      fragments: [AttachmentModel.self, MarketPlaceRoutine.self, TaskModel.self]
    ))

  public var id: GraphQLNullable<ID>
  public var ids: GraphQLNullable<[ID]>
  public var labels: GraphQLNullable<[String]>
  public var taskStatus: GraphQLNullable<String>

  public init(
    id: GraphQLNullable<ID>,
    ids: GraphQLNullable<[ID]>,
    labels: GraphQLNullable<[String]>,
    taskStatus: GraphQLNullable<String>
  ) {
    self.id = id
    self.ids = ids
    self.labels = labels
    self.taskStatus = taskStatus
  }

  public var __variables: Variables? { [
    "id": id,
    "ids": ids,
    "labels": labels,
    "taskStatus": taskStatus
  ] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("org", Org?.self, arguments: ["id": .variable("id")]),
    ] }

    public var org: Org? { __data["org"] }

    /// Org
    ///
    /// Parent Type: `Organization`
    public struct Org: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Organization }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("carePlans", [CarePlan]?.self, arguments: ["ids": .variable("ids")]),
      ] }

      public var carePlans: [CarePlan]? { __data["carePlans"] }

      /// Org.CarePlan
      ///
      /// Parent Type: `CarePlan`
      public struct CarePlan: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlan }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MarketPlaceRoutine.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var attachments: [Attachment]? { __data["attachments"] }
        public var focus: String? { __data["focus"] }
        public var description: String? { __data["description"] }
        public var durationInDays: Int? { __data["durationInDays"] }
        public var name: String? { __data["name"] }
        public var requirements: [String]? { __data["requirements"] }
        public var monitors: [Monitor]? { __data["monitors"] }
        public var tasks: [Task]? { __data["tasks"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var marketPlaceRoutine: MarketPlaceRoutine { _toFragment() }
        }

        public typealias Attachment = MarketPlaceRoutine.Attachment

        public typealias Monitor = MarketPlaceRoutine.Monitor

        public typealias Task = MarketPlaceRoutine.Task
      }
    }
  }
}
