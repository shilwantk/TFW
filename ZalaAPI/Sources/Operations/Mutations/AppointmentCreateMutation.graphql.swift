// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AppointmentCreateMutation: GraphQLMutation {
  public static let operationName: String = "AppointmentCreateMutation"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation AppointmentCreateMutation($input: AppointmentCreateInput) { apptCreate(input: $input) { __typename errors { __typename message } appointment { __typename id params provider { __typename id } } } }"#
    ))

  public var input: GraphQLNullable<AppointmentCreateInput>

  public init(input: GraphQLNullable<AppointmentCreateInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("apptCreate", ApptCreate?.self, arguments: ["input": .variable("input")]),
    ] }

    public var apptCreate: ApptCreate? { __data["apptCreate"] }

    /// ApptCreate
    ///
    /// Parent Type: `AppointmentCreatePayload`
    public struct ApptCreate: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AppointmentCreatePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("errors", [Error_SelectionSet]?.self),
        .field("appointment", Appointment?.self),
      ] }

      public var errors: [Error_SelectionSet]? { __data["errors"] }
      public var appointment: Appointment? { __data["appointment"] }

      /// ApptCreate.Error_SelectionSet
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

      /// ApptCreate.Appointment
      ///
      /// Parent Type: `Appointment`
      public struct Appointment: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Appointment }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
          .field("params", ZalaAPI.JSON.self),
          .field("provider", Provider?.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var params: ZalaAPI.JSON { __data["params"] }
        public var provider: Provider? { __data["provider"] }

        /// ApptCreate.Appointment.Provider
        ///
        /// Parent Type: `User`
        public struct Provider: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ZalaAPI.ID?.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
        }
      }
    }
  }
}
