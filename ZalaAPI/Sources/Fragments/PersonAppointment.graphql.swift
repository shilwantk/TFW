// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct PersonAppointment: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment PersonAppointment on Appointment { __typename id kind params provider { __typename ...ProviderModel } scheduledAt scheduledAtIso service { __typename ...MarketplaceAppointmentService } status }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Appointment }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("kind", String?.self),
    .field("params", ZalaAPI.JSON.self),
    .field("provider", Provider?.self),
    .field("scheduledAt", Int?.self),
    .field("scheduledAtIso", ZalaAPI.ISO8601DateTime?.self),
    .field("service", Service?.self),
    .field("status", String?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var kind: String? { __data["kind"] }
  public var params: ZalaAPI.JSON { __data["params"] }
  public var provider: Provider? { __data["provider"] }
  public var scheduledAt: Int? { __data["scheduledAt"] }
  public var scheduledAtIso: ZalaAPI.ISO8601DateTime? { __data["scheduledAtIso"] }
  public var service: Service? { __data["service"] }
  public var status: String? { __data["status"] }

  /// Provider
  ///
  /// Parent Type: `User`
  public struct Provider: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.User }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(ProviderModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var attachments: [Attachment]? { __data["attachments"] }
    public var addresses: [Address]? { __data["addresses"] }
    public var firstName: String? { __data["firstName"] }
    public var lastName: String? { __data["lastName"] }
    /// Preferences
    public var preferences: [Preference]? { __data["preferences"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var providerModel: ProviderModel { _toFragment() }
    }

    public typealias Attachment = ProviderModel.Attachment

    public typealias Address = ProviderModel.Address

    public typealias Preference = ProviderModel.Preference
  }

  /// Service
  ///
  /// Parent Type: `Service`
  public struct Service: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Service }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(MarketplaceAppointmentService.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var attachments: [Attachment]? { __data["attachments"] }
    public var desc: String? { __data["desc"] }
    public var groupPrimary: Bool? { __data["groupPrimary"] }
    public var kind: String? { __data["kind"] }
    public var organizationId: ZalaAPI.ID? { __data["organizationId"] }
    public var status: String? { __data["status"] }
    public var title: String? { __data["title"] }
    public var durationMins: Int? { __data["durationMins"] }
    public var params: ZalaAPI.JSON? { __data["params"] }
    public var supportsVirtual: Bool? { __data["supportsVirtual"] }
    public var addresses: [Address] { __data["addresses"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var marketplaceAppointmentService: MarketplaceAppointmentService { _toFragment() }
    }

    public typealias Attachment = MarketplaceAppointmentService.Attachment

    public typealias Address = MarketplaceAppointmentService.Address
  }
}
