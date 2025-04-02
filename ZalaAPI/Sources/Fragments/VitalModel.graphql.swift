// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct VitalModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment VitalModel on DataValue { __typename id key values units createdAtIso endAtIso displayUnits periodIso period metric { __typename ...MetricModel } source { __typename ...DataValueSourceModel } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.DataValue }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ZalaAPI.ID?.self),
    .field("key", String?.self),
    .field("values", [String]?.self),
    .field("units", [String]?.self),
    .field("createdAtIso", String?.self),
    .field("endAtIso", String?.self),
    .field("displayUnits", [String]?.self),
    .field("periodIso", [String]?.self),
    .field("period", [Int]?.self),
    .field("metric", Metric?.self),
    .field("source", Source?.self),
  ] }

  public var id: ZalaAPI.ID? { __data["id"] }
  public var key: String? { __data["key"] }
  public var values: [String]? { __data["values"] }
  public var units: [String]? { __data["units"] }
  public var createdAtIso: String? { __data["createdAtIso"] }
  public var endAtIso: String? { __data["endAtIso"] }
  public var displayUnits: [String]? { __data["displayUnits"] }
  public var periodIso: [String]? { __data["periodIso"] }
  public var period: [Int]? { __data["period"] }
  public var metric: Metric? { __data["metric"] }
  public var source: Source? { __data["source"] }

  /// Metric
  ///
  /// Parent Type: `Metric`
  public struct Metric: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Metric }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(MetricModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var key: String { __data["key"] }
    public var labels: [String]? { __data["labels"] }
    public var names: [String]? { __data["names"] }
    public var title: String? { __data["title"] }
    public var storedAs: [String]? { __data["storedAs"] }
    public var units: [[String]]? { __data["units"] }
    public var cumulative: Bool? { __data["cumulative"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var metricModel: MetricModel { _toFragment() }
    }
  }

  /// Source
  ///
  /// Parent Type: `DataValueSource`
  public struct Source: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.DataValueSource }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(DataValueSourceModel.self),
    ] }

    public var id: ZalaAPI.ID? { __data["id"] }
    public var identifier: String? { __data["identifier"] }
    public var name: String? { __data["name"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var dataValueSourceModel: DataValueSourceModel { _toFragment() }
    }
  }
}
