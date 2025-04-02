// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AccountQuery: GraphQLQuery {
  public static let operationName: String = "AccountQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query AccountQuery($labels: [String!]) { me { __typename ...Account personAppointments( status: ["booked", "pending", "completed", "confirmed"] ordering: "scheduledAtIso" ) { __typename nodes { __typename ...PersonAppointment } } } }"#,
      fragments: [Account.self, AddressModel.self, AttachmentModel.self, EmailModel.self, MarketplaceAppointmentService.self, PersonAppointment.self, PhoneNumberModel.self, PreferenceModel.self, ProviderModel.self, UserRole.self]
    ))

  public var labels: GraphQLNullable<[String]>

  public init(labels: GraphQLNullable<[String]>) {
    self.labels = labels
  }

  public var __variables: Variables? { ["labels": labels] }

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
          "status": ["booked", "pending", "completed", "confirmed"],
          "ordering": "scheduledAtIso"
        ]),
        .fragment(Account.self),
      ] }

      public var personAppointments: PersonAppointments? { __data["personAppointments"] }
      public var id: ZalaAPI.ID? { __data["id"] }
      public var addresses: [Address]? { __data["addresses"] }
      public var attachments: [Attachment]? { __data["attachments"] }
      public var emails: [Email]? { __data["emails"] }
      public var phones: [Phone]? { __data["phones"] }
      public var roles: [Role]? { __data["roles"] }
      public var firstName: String? { __data["firstName"] }
      public var lastName: String? { __data["lastName"] }
      public var fullName: String? { __data["fullName"] }
      public var initials: String? { __data["initials"] }
      /// Date of Birth
      public var dob: String? { __data["dob"] }
      /// Preferences
      public var preferences: [Preference]? { __data["preferences"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var account: Account { _toFragment() }
      }

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

      public typealias Address = Account.Address

      public typealias Attachment = Account.Attachment

      public typealias Email = Account.Email

      public typealias Phone = Account.Phone

      public typealias Role = Account.Role

      public typealias Preference = Account.Preference
    }
  }
}
