// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SuperUserServiceBookSingleServiceQuery: GraphQLQuery {
  public static let operationName: String = "SuperUserServiceBookSingleServiceQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SuperUserServiceBookSingleServiceQuery($id: ID, $service: ID, $date: String, $provider: ID) { org(id: $id) { __typename id service(id: $service) { __typename id addresses { __typename id address } availableTimesIso(date: $date, providerId: $provider) attachments(labels: ["banner"]) { __typename id label contentUrl } durationMins daySchedules { __typename ...DayScheduleModel } kind title } users(role: "provider") { __typename nodes { __typename id addresses { __typename ...AddressModel } } } } }"#,
      fragments: [AddressModel.self, DayScheduleModel.self]
    ))

  public var id: GraphQLNullable<ID>
  public var service: GraphQLNullable<ID>
  public var date: GraphQLNullable<String>
  public var provider: GraphQLNullable<ID>

  public init(
    id: GraphQLNullable<ID>,
    service: GraphQLNullable<ID>,
    date: GraphQLNullable<String>,
    provider: GraphQLNullable<ID>
  ) {
    self.id = id
    self.service = service
    self.date = date
    self.provider = provider
  }

  public var __variables: Variables? { [
    "id": id,
    "service": service,
    "date": date,
    "provider": provider
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
        .field("id", ZalaAPI.ID?.self),
        .field("service", Service?.self, arguments: ["id": .variable("service")]),
        .field("users", Users?.self, arguments: ["role": "provider"]),
      ] }

      public var id: ZalaAPI.ID? { __data["id"] }
      public var service: Service? { __data["service"] }
      public var users: Users? { __data["users"] }

      /// Org.Service
      ///
      /// Parent Type: `Service`
      public struct Service: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Service }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
          .field("addresses", [Address].self),
          .field("availableTimesIso", [String]?.self, arguments: [
            "date": .variable("date"),
            "providerId": .variable("provider")
          ]),
          .field("attachments", [Attachment]?.self, arguments: ["labels": ["banner"]]),
          .field("durationMins", Int?.self),
          .field("daySchedules", [DaySchedule]?.self),
          .field("kind", String?.self),
          .field("title", String?.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var addresses: [Address] { __data["addresses"] }
        public var availableTimesIso: [String]? { __data["availableTimesIso"] }
        public var attachments: [Attachment]? { __data["attachments"] }
        public var durationMins: Int? { __data["durationMins"] }
        public var daySchedules: [DaySchedule]? { __data["daySchedules"] }
        public var kind: String? { __data["kind"] }
        public var title: String? { __data["title"] }

        /// Org.Service.Address
        ///
        /// Parent Type: `AddressesStreet`
        public struct Address: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AddressesStreet }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZalaAPI.ID?.self),
            .field("address", String?.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var address: String? { __data["address"] }
        }

        /// Org.Service.Attachment
        ///
        /// Parent Type: `Attachment`
        public struct Attachment: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Attachment }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZalaAPI.ID?.self),
            .field("label", String?.self),
            .field("contentUrl", String?.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var label: String? { __data["label"] }
          public var contentUrl: String? { __data["contentUrl"] }
        }

        /// Org.Service.DaySchedule
        ///
        /// Parent Type: `ServiceDaySchedule`
        public struct DaySchedule: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ServiceDaySchedule }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(DayScheduleModel.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var day: Int? { __data["day"] }
          public var dayName: String? { __data["dayName"] }
          public var startTime: Int? { __data["startTime"] }
          public var endTime: Int? { __data["endTime"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var dayScheduleModel: DayScheduleModel { _toFragment() }
          }
        }
      }

      /// Org.Users
      ///
      /// Parent Type: `UserConnection`
      public struct Users: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.UserConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Org.Users.Node
        ///
        /// Parent Type: `User`
        public struct Node: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZalaAPI.ID?.self),
            .field("addresses", [Address]?.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var addresses: [Address]? { __data["addresses"] }

          /// Org.Users.Node.Address
          ///
          /// Parent Type: `AddressesStreet`
          public struct Address: ZalaAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AddressesStreet }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(AddressModel.self),
            ] }

            public var id: ZalaAPI.ID? { __data["id"] }
            public var label: String? { __data["label"] }
            /// Street Address
            public var line1: String? { __data["line1"] }
            /// City, State ZIP
            public var line2: String? { __data["line2"] }
            public var state: String? { __data["state"] }
            public var city: String? { __data["city"] }
            public var zip: String? { __data["zip"] }
            public var address: String? { __data["address"] }
            /// City, State ZIP
            public var csz: String? { __data["csz"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var addressModel: AddressModel { _toFragment() }
            }
          }
        }
      }
    }
  }
}
