//
//  StripeDefaultPrice.swift
//  zala
//
//  Created by Kyle Carriedo on 4/13/24.
//

import Foundation

struct StripeDefaultPrice: Codable {
    var id: String //"price_1OuIKaIUsgzTHJE0B1XubX1Q",
    var object: String //"price",
    var active: Bool? //true,
    var billingScheme: String? //"per_unit",
    var created: Int? //1710438280,
    var currency: String? //"usd",
    var livemode: Bool? //true,
    var nickname: String? //null,
    var product: String //"prod_PjlsB8Nx7BSLRe",
    var type: String? // "recurring",
    var unitAmount: Int? // 150000,
    var unitAmountDecimal: String? // "150000"
    
    enum CodingKeys: String, CodingKey  {
        case id
        case object
        case active
        case billingScheme = "billing_scheme"
        case created
        case currency
        case livemode
        case nickname
        case product
        case type
        case unitAmount = "unit_amount"
        case unitAmountDecimal = "unit_amount_decimal"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.object = try container.decode(String.self, forKey: .object)
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active)
        self.billingScheme = try container.decodeIfPresent(String.self, forKey: .billingScheme)
        self.created = try container.decodeIfPresent(Int.self, forKey: .created)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.livemode = try container.decodeIfPresent(Bool.self, forKey: .livemode)
        self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
        self.product = try container.decode(String.self, forKey: .product)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.unitAmount = try container.decodeIfPresent(Int.self, forKey: .unitAmount)
        self.unitAmountDecimal = try container.decodeIfPresent(String.self, forKey: .unitAmountDecimal)
    }
}
