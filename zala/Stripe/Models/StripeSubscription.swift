//
//  StripeSubscription.swift
//  zala
//
//  Created by Kyle Carriedo on 4/28/24.
//

import Foundation

struct StripePlanProduct: Codable {
    var id: String// "prod_PjlsB8Nx7BSLRe",
    var object: String// "product",
    var active: Bool// true,
    var created:  Int// 1710438280,
    var description: String// "Management and consulting for any musculoskeletal condition or surgical procedure.&nbsp; This package includes:<div>- Baseline assessment and deep dive conversation with Dr. Bourgeois</div><div>- Weekly face-to-face, or virtual meetings.</div><div>- Programming for your specific needs</div><div>- Daily monitoring from Dr. Bourgeois</div><div><br></div>",
    var images: [String]// [ "46"], //attachments
    var metadata: StripeProductMeta?
    var name: String? //"Injury Recovery and Beyond",
    var type:  String? //"service",
    var updated: Int// 1710438282,
    var url: String? // null
}


struct StripeSubscriptionPlan: Codable {
    var id: String // "price_1Nzjc0IUsgzTHJE0FcaHBiTx",
    var object: String // "plan",
    var active: Bool // true,
    var amount: Int // 500000,
    var created: Int // 1696958452,
    var currency: String // "usd",
    var interval: String // "month",
    var interval_count: Int //1,
    var product: StripePlanProduct
    var usage_type:  String //"licensed",
    var product_name:  String //"Gold",
    var next_billing_date:  Int //1716829037
    
    enum CodingKeys: CodingKey {
        case id
        case object
        case active
        case amount
        case created
        case currency
        case interval
        case interval_count
        case product
        case usage_type
        case product_name
        case next_billing_date
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.object = try container.decode(String.self, forKey: .object)
        self.active = try container.decode(Bool.self, forKey: .active)
        self.amount = try container.decode(Int.self, forKey: .amount)
        self.created = try container.decode(Int.self, forKey: .created)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.interval = try container.decode(String.self, forKey: .interval)
        self.interval_count = try container.decode(Int.self, forKey: .interval_count)
        self.product = try container.decode(StripePlanProduct.self, forKey: .product)
        self.usage_type = try container.decode(String.self, forKey: .usage_type)
        self.product_name = try container.decode(String.self, forKey: .product_name)
        self.next_billing_date = try container.decode(Int.self, forKey: .next_billing_date)    
    }
    
    func formattedPrice() -> String {
        return amount.formattedAsCurrency() ?? "Free"
    }
    
    func renewalDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(next_billing_date))
    }
    
    func formattedNextBill() -> String {
        let billDate = Date.dateStringFromDate(date: renewalDate(), dateStyle: .medium, timeStyle: .none, isRelative: true)
        let price = formattedPrice()        
        return "Next Bill: \(billDate) - \(price)"
    }
    
    
}

struct CancelStripeSubscription: Codable {
    var id: String // "sub_1PAEYrIUsgzTHJE0svMkvVBU",
    var status: String //"active",
}

struct StripeSubscription: Codable {
    var id: String // "sub_1PAEYrIUsgzTHJE0svMkvVBU",
    var object: String // "subscription",
    var billing_cycle_anchor: Int // 1714237037,
    var created: Int // 1714237037,
    var customer: String // "cus_PzspUGRQedEPTR",
    var default_payment_method: String // "pm_1PAEYqIUsgzTHJE0lE6S3dnq",
    var plan: StripeSubscriptionPlan
    var status: String //"active",
    var trial_end: Int? //null,
    var trial_start: Int? //
    
    enum CodingKeys: CodingKey {
        case id
        case object
        case billing_cycle_anchor
        case created
        case customer
        case default_payment_method
        case plan
        case status
        case trial_end
        case trial_start
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.object = try container.decode(String.self, forKey: .object)
        self.billing_cycle_anchor = try container.decode(Int.self, forKey: .billing_cycle_anchor)
        self.created = try container.decode(Int.self, forKey: .created)
        self.customer = try container.decode(String.self, forKey: .customer)
        self.default_payment_method = try container.decode(String.self, forKey: .default_payment_method)
        self.plan = try container.decode(StripeSubscriptionPlan.self, forKey: .plan)
        self.status = try container.decode(String.self, forKey: .status)
        self.trial_end = try container.decodeIfPresent(Int.self, forKey: .trial_end)
        self.trial_start = try container.decodeIfPresent(Int.self, forKey: .trial_start)
    }
    
    func superUserId() -> String? {
        return self.plan.product.metadata?.userId
    }
    
    var services: [String] {
        let stripeServices = self.plan.product.metadata?.services ?? ""
        return stripeServices.split(separator: ",").map { String($0) }
    }
}
