// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MyAppointmentsQuery: GraphQLQuery {
  public static let operationName: String = "MyAppointments"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query MyAppointments($startEpoch: Int!, $endEpoch: Int!, $labels: [String!]) { me { __typename personAppointments( status: ["booked", "confirmed"] startEpoch: $startEpoch endEpoch: $endEpoch ordering: "scheduledAtIso" ) { __typename nodes { __typename ...PersonAppointment } } } }"#,
      fragments: [AddressModel.self, AttachmentModel.self, MarketplaceAppointmentService.self, PersonAppointment.self, PreferenceModel.self, ProviderModel.self]
    ))

  public var startEpoch: Int
  public var endEpoch: Int
  public var labels: GraphQLNullable<[String]>

  public init(
    startEpoch: Int,
    endEpoch: Int,
    labels: GraphQLNullable<[String]>
  ) {
    self.startEpoch = startEpoch
    self.endEpoch = endEpoch
    self.labels = labels
  }

  public var __variables: Variables? { [
    "startEpoch": startEpoch,
    "endEpoch": endEpoch,
    "labels": labels
  ] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("me", Me?.self),
    ] }

    public var me: Me? { __data["me"] }

    /// Me
    ///
    /// Parent Type: `User`
    public struct Me: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("personAppointments", PersonAppointments?.self, arguments: [
          "status": ["booked", "confirmed"],
          "startEpoch": .variable("startEpoch"),
          "endEpoch": .variable("endEpoch"),
          "ordering": "scheduledAtIso"
        ]),
      ] }

      public var personAppointments: PersonAppointments? { __data["personAppointments"] }

      /// Me.PersonAppointments
      ///
      /// Parent Type: `AppointmentConnection`
      public struct PersonAppointments: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AppointmentConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Me.PersonAppointments.Node
        ///
        /// Parent Type: `Appointment`
        public struct Node: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Appointment }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(PersonAppointment.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var kind: String? { __data["kind"] }
          public var params: ZalaAPI.JSON { __data["params"] }
          public var provider: Provider? { __data["provider"] }
          public var scheduledAt: Int? { __data["scheduledAt"] }
          public var scheduledAtIso: ZalaAPI.ISO8601DateTime? { __data["scheduledAtIso"] }
          public var service: Service? { __data["service"] }
          public var status: String? { __data["status"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var personAppointment: PersonAppointment { _toFragment() }
          }

          public typealias Provider = PersonAppointment.Provider

          public typealias Service = PersonAppointment.Service
        }
      }
    }
  }
}
