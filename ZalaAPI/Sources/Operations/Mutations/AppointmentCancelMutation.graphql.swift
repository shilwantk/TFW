// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AppointmentCancelMutation: GraphQLMutation {
  public static let operationName: String = "AppointmentCancel"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation AppointmentCancel($input: IDInput) { apptCancel(input: $input) { __typename success } }"#
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
      .field("apptCancel", ApptCancel?.self, arguments: ["input": .variable("input")]),
    ] }

    public var apptCancel: ApptCancel? { __data["apptCancel"] }

    /// ApptCancel
    ///
    /// Parent Type: `AppointmentCancelPayload`
    public struct ApptCancel: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AppointmentCancelPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool?.self),
      ] }

      public var success: Bool? { __data["success"] }
    }
  }
}
