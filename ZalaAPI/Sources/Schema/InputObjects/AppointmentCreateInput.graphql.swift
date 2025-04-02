// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AppointmentCreateInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    org: GraphQLNullable<ID> = nil,
    service: ID,
    kind: String,
    person: ID,
    startEpoch: Int,
    endEpoch: Int,
    provider: GraphQLNullable<ID> = nil,
    room: GraphQLNullable<ID> = nil,
    reason: GraphQLNullable<String> = nil,
    priority: GraphQLNullable<Int> = nil,
    existingPx: GraphQLNullable<Bool> = nil,
    meetingUrl: GraphQLNullable<String> = nil,
    meetingId: GraphQLNullable<ID> = nil,
    source: GraphQLNullable<String> = nil,
    mobileCheckinRequested: GraphQLNullable<Bool> = nil,
    params: GraphQLNullable<JSON> = nil
  ) {
    __data = InputDict([
      "org": org,
      "service": service,
      "kind": kind,
      "person": person,
      "startEpoch": startEpoch,
      "endEpoch": endEpoch,
      "provider": provider,
      "room": room,
      "reason": reason,
      "priority": priority,
      "existingPx": existingPx,
      "meetingUrl": meetingUrl,
      "meetingId": meetingId,
      "source": source,
      "mobileCheckinRequested": mobileCheckinRequested,
      "params": params
    ])
  }

  public var org: GraphQLNullable<ID> {
    get { __data["org"] }
    set { __data["org"] = newValue }
  }

  public var service: ID {
    get { __data["service"] }
    set { __data["service"] = newValue }
  }

  public var kind: String {
    get { __data["kind"] }
    set { __data["kind"] = newValue }
  }

  public var person: ID {
    get { __data["person"] }
    set { __data["person"] = newValue }
  }

  public var startEpoch: Int {
    get { __data["startEpoch"] }
    set { __data["startEpoch"] = newValue }
  }

  public var endEpoch: Int {
    get { __data["endEpoch"] }
    set { __data["endEpoch"] = newValue }
  }

  public var provider: GraphQLNullable<ID> {
    get { __data["provider"] }
    set { __data["provider"] = newValue }
  }

  public var room: GraphQLNullable<ID> {
    get { __data["room"] }
    set { __data["room"] = newValue }
  }

  public var reason: GraphQLNullable<String> {
    get { __data["reason"] }
    set { __data["reason"] = newValue }
  }

  public var priority: GraphQLNullable<Int> {
    get { __data["priority"] }
    set { __data["priority"] = newValue }
  }

  public var existingPx: GraphQLNullable<Bool> {
    get { __data["existingPx"] }
    set { __data["existingPx"] = newValue }
  }

  public var meetingUrl: GraphQLNullable<String> {
    get { __data["meetingUrl"] }
    set { __data["meetingUrl"] = newValue }
  }

  public var meetingId: GraphQLNullable<ID> {
    get { __data["meetingId"] }
    set { __data["meetingId"] = newValue }
  }

  public var source: GraphQLNullable<String> {
    get { __data["source"] }
    set { __data["source"] = newValue }
  }

  public var mobileCheckinRequested: GraphQLNullable<Bool> {
    get { __data["mobileCheckinRequested"] }
    set { __data["mobileCheckinRequested"] = newValue }
  }

  /// JSON object of misc data to store on the appointment
  public var params: GraphQLNullable<JSON> {
    get { __data["params"] }
    set { __data["params"] = newValue }
  }
}
