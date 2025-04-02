// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AddressesStreetInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    fullAddress: GraphQLNullable<String> = nil,
    street: GraphQLNullable<String> = nil,
    street2: GraphQLNullable<String> = nil,
    city: GraphQLNullable<String> = nil,
    state: GraphQLNullable<String> = nil,
    zip: GraphQLNullable<String> = nil,
    postalCode: GraphQLNullable<String> = nil,
    county: GraphQLNullable<String> = nil,
    country: GraphQLNullable<String> = nil,
    lat: GraphQLNullable<Double> = nil,
    lng: GraphQLNullable<Double> = nil,
    geocode: GraphQLNullable<Bool> = nil,
    label: GraphQLNullable<String> = nil,
    remove: GraphQLNullable<Bool> = nil
  ) {
    __data = InputDict([
      "fullAddress": fullAddress,
      "street": street,
      "street2": street2,
      "city": city,
      "state": state,
      "zip": zip,
      "postalCode": postalCode,
      "county": county,
      "country": country,
      "lat": lat,
      "lng": lng,
      "geocode": geocode,
      "label": label,
      "remove": remove
    ])
  }

  public var fullAddress: GraphQLNullable<String> {
    get { __data["fullAddress"] }
    set { __data["fullAddress"] = newValue }
  }

  public var street: GraphQLNullable<String> {
    get { __data["street"] }
    set { __data["street"] = newValue }
  }

  public var street2: GraphQLNullable<String> {
    get { __data["street2"] }
    set { __data["street2"] = newValue }
  }

  public var city: GraphQLNullable<String> {
    get { __data["city"] }
    set { __data["city"] = newValue }
  }

  public var state: GraphQLNullable<String> {
    get { __data["state"] }
    set { __data["state"] = newValue }
  }

  public var zip: GraphQLNullable<String> {
    get { __data["zip"] }
    set { __data["zip"] = newValue }
  }

  public var postalCode: GraphQLNullable<String> {
    get { __data["postalCode"] }
    set { __data["postalCode"] = newValue }
  }

  public var county: GraphQLNullable<String> {
    get { __data["county"] }
    set { __data["county"] = newValue }
  }

  public var country: GraphQLNullable<String> {
    get { __data["country"] }
    set { __data["country"] = newValue }
  }

  public var lat: GraphQLNullable<Double> {
    get { __data["lat"] }
    set { __data["lat"] = newValue }
  }

  public var lng: GraphQLNullable<Double> {
    get { __data["lng"] }
    set { __data["lng"] = newValue }
  }

  public var geocode: GraphQLNullable<Bool> {
    get { __data["geocode"] }
    set { __data["geocode"] = newValue }
  }

  /// default(main)
  public var label: GraphQLNullable<String> {
    get { __data["label"] }
    set { __data["label"] = newValue }
  }

  /// default(false)
  public var remove: GraphQLNullable<Bool> {
    get { __data["remove"] }
    set { __data["remove"] = newValue }
  }
}
