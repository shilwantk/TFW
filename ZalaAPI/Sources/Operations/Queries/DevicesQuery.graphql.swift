// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class DevicesQuery: GraphQLQuery {
  public static let operationName: String = "Devices"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Devices($status: String) { me { __typename devices(status: $status) { __typename ...DeviceModel } } }"#,
      fragments: [DeviceModel.self]
    ))

  public var status: GraphQLNullable<String>

  public init(status: GraphQLNullable<String>) {
    self.status = status
  }

  public var __variables: Variables? { ["status": status] }

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
        .field("devices", [Device]?.self, arguments: ["status": .variable("status")]),
      ] }

      public var devices: [Device]? { __data["devices"] }

      /// Me.Device
      ///
      /// Parent Type: `Device`
      public struct Device: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Device }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(DeviceModel.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
        public var name: String? { __data["name"] }
        public var kind: String? { __data["kind"] }
        public var deviceId: String? { __data["deviceId"] }
        public var createdAt: Int? { __data["createdAt"] }
        public var updatedAt: Int? { __data["updatedAt"] }
        public var lastSentAt: Int? { __data["lastSentAt"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var deviceModel: DeviceModel { _toFragment() }
        }
      }
    }
  }
}
