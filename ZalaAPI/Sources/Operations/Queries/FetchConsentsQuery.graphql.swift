// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class FetchConsentsQuery: GraphQLQuery {
  public static let operationName: String = "FetchConsents"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchConsents($org: ID!) { org(id: $org) { __typename assessments { __typename nodes { __typename ...AssessmentModel } } agreements { __typename nodes { __typename ...AgreementModel } } } }"#,
      fragments: [AgreementModel.self, AssessmentModel.self]
    ))

  public var org: ID

  public init(org: ID) {
    self.org = org
  }

  public var __variables: Variables? { ["org": org] }

  public struct Data: ZalaAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.ApplicationQueries }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("org", Org?.self, arguments: ["id": .variable("org")]),
    ] }

    public var org: Org? { __data["org"] }

    /// Org
    ///
    /// Parent Type: `Organization`
    public struct Org: ZalaAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Organization }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("assessments", Assessments?.self),
        .field("agreements", Agreements?.self),
      ] }

      public var assessments: Assessments? { __data["assessments"] }
      public var agreements: Agreements? { __data["agreements"] }

      /// Org.Assessments
      ///
      /// Parent Type: `AssessmentConnection`
      public struct Assessments: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AssessmentConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Org.Assessments.Node
        ///
        /// Parent Type: `Assessment`
        public struct Node: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Assessment }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(AssessmentModel.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var kind: String? { __data["kind"] }
          public var name: String? { __data["name"] }
          public var program: ZalaAPI.JSON? { __data["program"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var assessmentModel: AssessmentModel { _toFragment() }
          }
        }
      }

      /// Org.Agreements
      ///
      /// Parent Type: `AgreementConnection`
      public struct Agreements: ZalaAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.AgreementConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Org.Agreements.Node
        ///
        /// Parent Type: `Agreement`
        public struct Node: ZalaAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ZalaAPI.Objects.Agreement }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(AgreementModel.self),
          ] }

          public var id: ZalaAPI.ID? { __data["id"] }
          public var kind: String? { __data["kind"] }
          public var docMarkdown: String? { __data["docMarkdown"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var agreementModel: AgreementModel { _toFragment() }
          }
        }
      }
    }
  }
}
