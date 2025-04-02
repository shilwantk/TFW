// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class DeviceUnregisterMutation: GraphQLMutation {
  public static let operationName: String = "DeviceUnregister"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation DeviceUnregister($input: DeviceUnregisterInput) { deviceUnregister(input: $input) { __typename result { __typename deviceId } errors { __typename message } } }"#
    ))

  public var input: GraphQLNullable<DeviceUnregisterInput>

  public init(input: GraphQLNullable<DeviceUnregisterInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("deviceUnregister", DeviceUnregister?.self, arguments: ["input": .variable("input")]),
    ] }

    public var deviceUnregister: DeviceUnregister? { __data["deviceUnregister"] }

    /// DeviceUnregister
    ///
    /// Parent Type: `DeviceUnregisterPayload`
    public struct DeviceUnregister: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.DeviceUnregisterPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("result", Result?.self),
        .field("errors", [Error_SelectionSet]?.self),
      ] }

      public var result: Result? { __data["result"] }
      public var errors: [Error_SelectionSet]? { __data["errors"] }

      /// DeviceUnregister.Result
      ///
      /// Parent Type: `Device`
      public struct Result: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Device }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("deviceId", String?.self),
        ] }

        public var deviceId: String? { __data["deviceId"] }
      }

      /// DeviceUnregister.Error_SelectionSet
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
    }
  }
}
