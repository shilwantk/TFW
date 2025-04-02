// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct ErrorModel: ZalaAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment ErrorModel on Error { __typename code message }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Error_Object }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("code", Int?.self),
    .field("message", String?.self),
  ] }

  public var code: Int? { __data["code"] }
  public var message: String? { __data["message"] }
}
