//
//  StripeProduct.swift
//  zala
//
//  Created by Kyle Carriedo on 4/13/24.
//

import Foundation

struct StripeAddress: Codable {
    var line1: String // "Test",
    var city: String // "Miami",
    var state: String // "Test",
    var postal_code: String // "33716",
    var country: String = "United States" // "United States"
    
    func toJson() -> [String: String] {
        return [
            "line1" : line1,
            "city" : city,
            "state" : state,
            "postal_code" : postal_code,
            "country" : country
        ]
    }
}
struct StripeProduct: Codable, Hashable {
    static func == (lhs: StripeProduct, rhs: StripeProduct) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String// "prod_PjlsB8Nx7BSLRe",
    var object: String// "product",
    var active: Bool// true,
    var created:  Int// 1710438280,
    var defaultPrice: StripeDefaultPrice?
    var description: String// "Management and consulting for any musculoskeletal condition or surgical procedure.&nbsp; This package includes:<div>- Baseline assessment and deep dive conversation with Dr. Bourgeois</div><div>- Weekly face-to-face, or virtual meetings.</div><div>- Programming for your specific needs</div><div>- Daily monitoring from Dr. Bourgeois</div><div><br></div>",
    var images: [String]// [ "46"], //attachments
    var metadata: StripeProductMeta?
    var name: String? //"Injury Recovery and Beyond",
    var type:  String? //"service",
    var updated: Int// 1710438282,
    var url: String? // null
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case active
        case created
        case defaultPrice = "default_price"
        case description
        case images
        case metadata
        case name
        case type
        case updated
        case url
    }
    
    
//    static let previewProduct = StripeProduct(id: "", object: "", active: true, created: 0, description: "", images: [], updated: 0)
    
    func formattedPrice() -> String {
        guard let unitAmount = defaultPrice?.unitAmount else { return "Free"}
        if unitAmount > 0 {
            return unitAmount.formattedAsCurrency() ?? "Free"
        } else {
            return "Free"
        }
    }
    
    var appointmentCount: Int {
        metadata?.totalAppointments.count ?? 0
    }
    
    var appointments: [String] {
        metadata?.totalAppointments ?? []
    }
    
    var isPaused: Bool {
        metadata?.isPaused ?? false
    }
    
    var isArchived: Bool {
        metadata?.isArchived ?? false
    }
    
    var isZalaFree: Bool {
        self.name?.lowercased() == "zala free"
    }
    
    var isValid: Bool {
        !isPaused && !isArchived
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.object = try container.decode(String.self, forKey: .object)
        self.active = try container.decode(Bool.self, forKey: .active)
        self.created = try container.decode(Int.self, forKey: .created)
        self.defaultPrice = try container.decodeIfPresent(StripeDefaultPrice.self, forKey: .defaultPrice)
        self.description = try container.decode(String.self, forKey: .description)
        self.images = try container.decode([String].self, forKey: .images)
        self.metadata = try container.decodeIfPresent(StripeProductMeta.self, forKey: .metadata)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.updated = try container.decode(Int.self, forKey: .updated)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
    }
}
