// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct PageInfoModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment PageInfoModel on PageInfo { __typename hasNextPage endCursor }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.PageInfo }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("hasNextPage", Bool.self),
    .field("endCursor", String?.self),
  ] }

  /// When paginating forwards, are there more items?
  public var hasNextPage: Bool { __data["hasNextPage"] }
  /// When paginating forwards, the cursor to continue.
  public var endCursor: String? { __data["endCursor"] }
}
