// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RoutineCompleteMutation: GraphQLMutation {
  public static let operationName: String = "RoutineCompleteMutation"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation RoutineCompleteMutation($input: IDInput) { careplanComplete(input: $input) { __typename errors { __typename message } success carePlan { __typename status } } }"#
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
      .field("careplanComplete", CareplanComplete?.self, arguments: ["input": .variable("input")]),
    ] }

    public var careplanComplete: CareplanComplete? { __data["careplanComplete"] }

    /// CareplanComplete
    ///
    /// Parent Type: `CarePlanCompletePayload`
    public struct CareplanComplete: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlanCompletePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("errors", [Error_SelectionSet]?.self),
        .field("success", Bool?.self),
        .field("carePlan", CarePlan?.self),
      ] }

      public var errors: [Error_SelectionSet]? { __data["errors"] }
      public var success: Bool? { __data["success"] }
      public var carePlan: CarePlan? { __data["carePlan"] }

      /// CareplanComplete.Error_SelectionSet
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

      /// CareplanComplete.CarePlan
      ///
      /// Parent Type: `CarePlan`
      public struct CarePlan: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlan }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("status", String?.self),
        ] }

        public var status: String? { __data["status"] }
      }
    }
  }
}
