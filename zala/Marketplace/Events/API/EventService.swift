//
//  AppointmentService.swift
//  zala
//
//  Created by Kyle Carriedo on 4/17/24.
//

import Foundation
import Alamofire
import Combine
import SwiftUI
import ZalaAPI

struct EventbriteAddress: Codable {
    var address_1: String // "997 Florida A1A",
    var address_2: String // "",
    var city: String // "Jupiter",
    var region: String // "FL",
    var postal_code: String // "33477",
    var country: String // "US",
    var latitude: String // "26.9432961",
    var longitude: String // "-80.0812109",
    var localized_address_display: String // "997 Florida A1A, Jupiter, FL 33477",
    var localized_area_display: String // "Jupiter, FL",
    var localized_multi_line_address_display: [String] // [ "997 Florida A1A", "Jupiter, FL 33477" ]
    
    func cellFormat() -> String {
        let address = "\(address_1) \(address_2)"
        return "\(address)\n\(localized_area_display)"
    }
    
    func mapData() -> (street: String, csz: String, latitude: Double, longitude: Double)? {
        if let lat = Double(latitude), let lng = Double(longitude) {
            return (address_1, "\(city),\(region),\(postal_code)", lat, lng)
        } else {
            return nil
        }
    }
}

struct EventbriteVenune: Codable {
    var address: EventbriteAddress?
    var resource_uri: String // "https://www.eventbriteapi.com/v3/venues/120902069/",
    var id: String // "120902069",
    var age_restriction: String? // null,
    var capacity: Int? // null,
    var name: String // "997 Florida A1A",
    var latitude: String? // "26.9432961",
    var longitude: String? // "-80.0812109"
}

struct EventbriteTime: Codable {
    var timezone: String // "America/New_York",
    var local: String // "2022-10-29T09:00:00",
    var utc: String // "2022-10-29T13:00:00Z"
}

struct EventbriteImage: Codable {
    var url: String // "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F657167459%2F1229606603323%2F1%2Foriginal.20231212-071637?auto=format%2Ccompress&q=75&sharp=10&s=91323b31476b340ec7f89fb91f9f33fa",
    var width: Int //4850,
    var height: Int //3233
}

struct EventbriteTextHTML: Codable {
    var text: String
    var html: String
}

struct EventbriteLogo: Codable {
    var id: String // "657167459",
    var url: String?// "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F657167459%2F1229606603323%2F1%2Foriginal.20231212-071637?h=200&w=450&auto=format%2Ccompress&q=75&sharp=10&rect=0%2C404%2C4850%2C2425&s=d016ea1974d6b76e5bd09eaff8bab0f6",
    var aspect_ratio: String? // "2",
    var edge_color: String? // "#f0f2f2",
    var edge_color_set: Bool? // true
    var original: EventbriteImage?
}

struct EventbriteCurrency: Codable {
    var display: String // "$4.10",
    var currency: String // "USD",
    var value: Int // 410,
    var major_value: String // "4.10"
}
struct EventbriteTicket: Codable {
    var actual_cost: String? // null,
    var actual_fee: EventbriteCurrency? // EventBriteCurrency
    var cost: EventbriteCurrency? // EventBriteCurrency
    var fee: EventbriteCurrency? // EventBriteCurrency
    var tax: EventbriteCurrency? // EventBriteCurrency
    var resource_uri: String // "https://www.eventbriteapi.com/v3/events/451038065997/ticket_classes/767905919/",
    var display_name: String // "Race With A Rental Board or Kayak",
    var name: String // "Race With A Rental Board or Kayak",
    var description: String? // null,
    var sorting: Int // 2,
    var donation: Bool // false,
    var free: Bool // false,
    var minimum_quantity: Int // 1,
    var maximum_quantity: Int // 10,
    var maximum_quantity_per_order: Int // 0,
    var on_sale_status: String // "UNAVAILABLE",
    var has_pdf_ticket: Bool // true,
    var order_confirmation_message: String? // null,
    var delivery_methods: [String] // [  "electronic" ],
    var category: String // "admission",
    var sales_channels: [String] // [  "online",  "atd" ],
    var secondary_assignment_enabled: Bool // false,
    var event_id: String // "451038065997",
    var image_id: String? // null,
    var id: String // "767905919",
    var capacity: Int // 500,
    var quantity_total: Int // 500,
    var quantity_sold: Int // 19,
    var sales_start: String? // "2022-10-23T04:00:00Z",
    var sales_end: String? // "2022-10-30T01:00:00Z",
    var sales_end_relative: String? // null,
    var hidden: Bool // false,
    var hidden_currently: Bool // false,
    var include_fee: Bool // true,
    var split_fee: Bool // false,
    var hide_description: Bool // true,
    var hide_sale_dates: Bool // false,
    var ticket_parent_id: String? // null,
    var auto_hide: Bool // false,
    var payment_constraints: [String]? // []
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.actual_cost = try container.decodeIfPresent(String.self, forKey: .actual_cost)
        self.actual_fee = try container.decodeIfPresent(EventbriteCurrency.self, forKey: .actual_fee)
        self.cost = try container.decodeIfPresent(EventbriteCurrency.self, forKey: .cost)
        self.fee = try container.decodeIfPresent(EventbriteCurrency.self, forKey: .fee)
        self.tax = try container.decodeIfPresent(EventbriteCurrency.self, forKey: .tax)
        self.resource_uri = try container.decode(String.self, forKey: .resource_uri)
        self.display_name = try container.decode(String.self, forKey: .display_name)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.sorting = try container.decode(Int.self, forKey: .sorting)
        self.donation = try container.decode(Bool.self, forKey: .donation)
        self.free = try container.decode(Bool.self, forKey: .free)
        self.minimum_quantity = try container.decode(Int.self, forKey: .minimum_quantity)
        self.maximum_quantity = try container.decode(Int.self, forKey: .maximum_quantity)
        self.maximum_quantity_per_order = try container.decode(Int.self, forKey: .maximum_quantity_per_order)
        self.on_sale_status = try container.decode(String.self, forKey: .on_sale_status)
        self.has_pdf_ticket = try container.decode(Bool.self, forKey: .has_pdf_ticket)
        self.order_confirmation_message = try container.decodeIfPresent(String.self, forKey: .order_confirmation_message)
        self.delivery_methods = try container.decode([String].self, forKey: .delivery_methods)
        self.category = try container.decode(String.self, forKey: .category)
        self.sales_channels = try container.decode([String].self, forKey: .sales_channels)
        self.secondary_assignment_enabled = try container.decode(Bool.self, forKey: .secondary_assignment_enabled)
        self.event_id = try container.decode(String.self, forKey: .event_id)
        self.image_id = try container.decodeIfPresent(String.self, forKey: .image_id)
        self.id = try container.decode(String.self, forKey: .id)
        self.capacity = try container.decode(Int.self, forKey: .capacity)
        self.quantity_total = try container.decode(Int.self, forKey: .quantity_total)
        self.quantity_sold = try container.decode(Int.self, forKey: .quantity_sold)
        self.sales_start = try container.decodeIfPresent(String.self, forKey: .sales_start)
        self.sales_end = try container.decodeIfPresent(String.self, forKey: .sales_end)
        self.sales_end_relative = try container.decodeIfPresent(String.self, forKey: .sales_end_relative)
        self.hidden = try container.decode(Bool.self, forKey: .hidden)
        self.hidden_currently = try container.decode(Bool.self, forKey: .hidden_currently)
        self.include_fee = try container.decode(Bool.self, forKey: .include_fee)
        self.split_fee = try container.decode(Bool.self, forKey: .split_fee)
        self.hide_description = try container.decode(Bool.self, forKey: .hide_description)
        self.hide_sale_dates = try container.decode(Bool.self, forKey: .hide_sale_dates)
        self.ticket_parent_id = try container.decodeIfPresent(String.self, forKey: .ticket_parent_id)
        self.auto_hide = try container.decode(Bool.self, forKey: .auto_hide)
        self.payment_constraints = try container.decodeIfPresent([String].self, forKey: .payment_constraints)
    }
}

struct EventbriteEvent: Codable, Hashable {
        
    var name: EventbriteTextHTML?
    var description: EventbriteTextHTML?
    var url: String? // "https://www.eventbrite.com/e/sample-paddleboard-event-tickets-453525425757",
//    var start: EventbriteTime?
//    var end: EventbriteTime?
//    var organization_id: String? // "1229607580113",
//    var created: String? // "2022-10-28T01:21:53Z",
//    var changed: String? // "2023-12-13T00:30:23Z",
//    var published: String? // "2023-12-12T07:05:40Z",
//    var capacity: Int? // 50,
//    var capacity_is_custom: Bool? // false,
//    var status: String? // "completed",
//    var currency: String? // "USD",
//    var listed: Bool? // false,
//    var shareable: Bool? // false,
//    var invite_only: Bool? // false,
//    var password: String? // "zalabyio",
//    var online_event: Bool? // false,
//    var show_remaining: Bool? // false,
//    var tx_time_limit: Int?? // 1200,
//    var hide_start_date: Bool? // false,
//    var hide_end_date: Bool? // true,
//    var locale: String? // "en_US",
//    var is_locked: Bool? // false,
//    var privacy_setting: String? // "unlocked",
//    var is_series: Bool? // true,
//    var is_series_parent: Bool? // false,
//    var inventory_type: String? // "limited",
//    var is_reserved_seating: Bool? // false,
//    var show_pick_a_seat: Bool? // false,
//    var show_seatmap_thumbnail: Bool? // false,
//    var show_colors_in_seatmap_thumbnail: Bool? // false,
//    var source: String? // "coyote",
//    var is_free: Bool? // true,
//    var version: String?? // null,
//    var summary: String? // "This is a sample season pass for winter paddleboard 2022-2023 season.",
//    var logo_id: String? // "657167459",
//    var organizer_id: String? // "55661007623",
//    var venue_id: String?? // null,
//    var category_id: String?? // null,
//    var subcategory_id: String?? // null,
//    var format_id: String?? // null,
    var id: String // "453525425757",
//    var resource_uri: String? // "https://www.eventbriteapi.com/v3/events/453525425757/",
//    var is_externally_ticketed: Bool? // false,
//    var series_id: String? // "453525335487",
    var logo: EventbriteLogo?
    var venue: EventbriteVenune?
//    var ticket_classes: [EventbriteTicket]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EventbriteEvent, rhs: EventbriteEvent) -> Bool {
        lhs.id == rhs.id
    }
    
    func isLocation() -> Bool{
        return venue != nil
    }
    
    func formattedTitle() -> String {
        return name?.text ?? "No title"
    }
    
    func imageUrl() -> String? {
        return logo?.original?.url
    }
    
    func mapData() -> (street: String, csz: String, latitude: Double, longitude: Double)? {
        return venue?.address?.mapData()
    }    
}


protocol EventAPIProtocol {
    func fetchGlobalEvents() -> AnyPublisher<[EventbriteEvent], AFError>
}

struct EventServiceAPI: EventAPIProtocol {
    func fetchGlobalEvents() -> AnyPublisher<[EventbriteEvent], Alamofire.AFError> {
        let url = "\(Enviorment.eventApi)events"
        return AF.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type:[EventbriteEvent].self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

@Observable class EventService {
    private var subs: Set<AnyCancellable> = []
    private let networking: EventAPIProtocol = EventServiceAPI()
    var events: [EventbriteEvent] = []
    var isLoading: Bool = false
//https://zala-events-api.herokuapp.com/organizations/1229607580113/users?only_emails=kyle@misfitlabs.vc
    func globalEvents() {
        isLoading.toggle()
        networking.fetchGlobalEvents().sink { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .failure(_):
                self.isLoading.toggle()                
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.events = response
            self.isLoading.toggle()
        }
        .store(in: &subs)
        
    }
}
