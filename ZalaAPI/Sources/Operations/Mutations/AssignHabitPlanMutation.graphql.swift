// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AssignHabitPlanMutation: GraphQLMutation {
  public static let operationName: String = "AssignHabitPlan"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation AssignHabitPlan($input: CarePlanAssignInput) { careplanAssign(input: $input) { __typename errors { __typename message } success carePlan { __typename id } } }"#
    ))

  public var input: GraphQLNullable<CarePlanAssignInput>

  public init(input: GraphQLNullable<CarePlanAssignInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("careplanAssign", CareplanAssign?.self, arguments: ["input": .variable("input")]),
    ] }

    public var careplanAssign: CareplanAssign? { __data["careplanAssign"] }

    /// CareplanAssign
    ///
    /// Parent Type: `CarePlanAssignPayload`
    public struct CareplanAssign: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlanAssignPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("errors", [Error_SelectionSet]?.self),
        .field("success", Bool?.self),
        .field("carePlan", CarePlan?.self),
      ] }

      public var errors: [Error_SelectionSet]? { __data["errors"] }
      public var success: Bool? { __data["success"] }
      public var carePlan: CarePlan? { __data["carePlan"] }

      /// CareplanAssign.Error_SelectionSet
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

      /// CareplanAssign.CarePlan
      ///
      /// Parent Type: `CarePlan`
      public struct CarePlan: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlan }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ZalaAPI.ID?.self),
        ] }

        public var id: ZalaAPI.ID? { __data["id"] }
      }
    }
  }
}
