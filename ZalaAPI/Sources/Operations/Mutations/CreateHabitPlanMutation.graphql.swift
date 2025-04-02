// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CreateHabitPlanMutation: GraphQLMutation {
  public static let operationName: String = "CreateHabitPlan"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateHabitPlan($id: ID!, $input: CarePlanCreateInput) { careplanCreate(orgId: $id, input: $input) { __typename errors { __typename message } carePlan { __typename id } } }"#
    ))

  public var id: ID
  public var input: GraphQLNullable<CarePlanCreateInput>

  public init(
    id: ID,
    input: GraphQLNullable<CarePlanCreateInput>
  ) {
    self.id = id
    self.input = input
  }

  public var __variables: Variables? { [
    "id": id,
    "input": input
  ] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationMutations }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("careplanCreate", CareplanCreate?.self, arguments: [
        "orgId": .variable("id"),
        "input": .variable("input")
      ]),
    ] }

    public var careplanCreate: CareplanCreate? { __data["careplanCreate"] }

    /// CareplanCreate
    ///
    /// Parent Type: `CarePlanCreatePayload`
    public struct CareplanCreate: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.CarePlanCreatePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("errors", [Error_SelectionSet]?.self),
        .field("carePlan", CarePlan?.self),
      ] }

      public var errors: [Error_SelectionSet]? { __data["errors"] }
      public var carePlan: CarePlan? { __data["carePlan"] }

      /// CareplanCreate.Error_SelectionSet
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

      /// CareplanCreate.CarePlan
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
