// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class StartHabitPlanMutation: GraphQLMutation {
  public static let operationName: String = "StartHabitPlan"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation StartHabitPlan($input: CarePlanAcceptInput) { careplanAccept(input: $input) { __typename carePlan { __typename id } } }"#
    ))

  public var input: GraphQLNullable<CarePlanAcceptInput>

  public init(input: GraphQLNullable<CarePlanAcceptInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("careplanAccept", CareplanAccept?.self, arguments: ["input": .variable("input")]),
    ] }

    public var careplanAccept: CareplanAccept? { __data["careplanAccept"] }

    /// CareplanAccept
    ///
    /// Parent Type: `CarePlanAcceptPayload`
    public struct CareplanAccept: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlanAcceptPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("carePlan", CarePlan?.self),
      ] }

      public var carePlan: CarePlan? { __data["carePlan"] }

      /// CareplanAccept.CarePlan
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
