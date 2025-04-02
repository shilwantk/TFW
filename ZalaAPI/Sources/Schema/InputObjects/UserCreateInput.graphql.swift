// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct UserCreateInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<ID> = nil,
    firstName: String,
    middleName: GraphQLNullable<String> = nil,
    lastName: String,
    dob: String,
    ssn: GraphQLNullable<String> = nil,
    mainLanguage: GraphQLNullable<String> = nil,
    profileColor: GraphQLNullable<String> = nil,
    gender: GraphQLNullable<String> = nil,
    encryptedSsn: GraphQLNullable<String> = nil,
    orgId: GraphQLNullable<ID> = nil,
    roles: GraphQLNullable<[RoleInput]> = nil,
    phones: GraphQLNullable<[AddressesPhoneInput]> = nil,
    emails: GraphQLNullable<[AddressesEmailInput]> = nil,
    addresses: GraphQLNullable<[AddressesStreetInput]> = nil,
    attachments: GraphQLNullable<[AttachmentInput]> = nil,
    password: GraphQLNullable<String> = nil,
    disabilities: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "id": id,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "dob": dob,
      "ssn": ssn,
      "mainLanguage": mainLanguage,
      "profileColor": profileColor,
      "gender": gender,
      "encryptedSsn": encryptedSsn,
      "orgId": orgId,
      "roles": roles,
      "phones": phones,
      "emails": emails,
      "addresses": addresses,
      "attachments": attachments,
      "password": password,
      "disabilities": disabilities
    ])
  }

  public var id: GraphQLNullable<ID> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var firstName: String {
    get { __data["firstName"] }
    set { __data["firstName"] = newValue }
  }

  public var middleName: GraphQLNullable<String> {
    get { __data["middleName"] }
    set { __data["middleName"] = newValue }
  }

  public var lastName: String {
    get { __data["lastName"] }
    set { __data["lastName"] = newValue }
  }

  /// Date of Birth
  public var dob: String {
    get { __data["dob"] }
    set { __data["dob"] = newValue }
  }

  /// Last 4 of SSN
  public var ssn: GraphQLNullable<String> {
    get { __data["ssn"] }
    set { __data["ssn"] = newValue }
  }

  /// Default(en)
  public var mainLanguage: GraphQLNullable<String> {
    get { __data["mainLanguage"] }
    set { __data["mainLanguage"] = newValue }
  }

  public var profileColor: GraphQLNullable<String> {
    get { __data["profileColor"] }
    set { __data["profileColor"] = newValue }
  }

  public var gender: GraphQLNullable<String> {
    get { __data["gender"] }
    set { __data["gender"] = newValue }
  }

  public var encryptedSsn: GraphQLNullable<String> {
    get { __data["encryptedSsn"] }
    set { __data["encryptedSsn"] = newValue }
  }

  public var orgId: GraphQLNullable<ID> {
    get { __data["orgId"] }
    set { __data["orgId"] = newValue }
  }

  public var roles: GraphQLNullable<[RoleInput]> {
    get { __data["roles"] }
    set { __data["roles"] = newValue }
  }

  public var phones: GraphQLNullable<[AddressesPhoneInput]> {
    get { __data["phones"] }
    set { __data["phones"] = newValue }
  }

  public var emails: GraphQLNullable<[AddressesEmailInput]> {
    get { __data["emails"] }
    set { __data["emails"] = newValue }
  }

  public var addresses: GraphQLNullable<[AddressesStreetInput]> {
    get { __data["addresses"] }
    set { __data["addresses"] = newValue }
  }

  public var attachments: GraphQLNullable<[AttachmentInput]> {
    get { __data["attachments"] }
    set { __data["attachments"] = newValue }
  }

  public var password: GraphQLNullable<String> {
    get { __data["password"] }
    set { __data["password"] = newValue }
  }

  public var disabilities: GraphQLNullable<String> {
    get { __data["disabilities"] }
    set { __data["disabilities"] = newValue }
  }
}
