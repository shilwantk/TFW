//
//  StripeCustomer.swift
//  zala
//
//  Created by Kyle Carriedo on 4/25/24.
//

import Foundation

struct StripeCustomer: Codable {
//    {
        var id: String // "cus_Nf8RbEzBu4RVC8",
//        "object": "customer",
//        "address": {
//            "city": "Miami",
//            "country": "United States",
//            "line1": "Test",
//            "line2": null,
//            "postal_code": "33716",
//            "state": "Test"
//        },
//        "balance": 0,
//        "created": 1680769654,
//        "currency": null,
//        "default_source": null,
//        "delinquent": false,
//        "description": null,
//        "discount": null,
        var email: String // "joey@misfitlabs.vc",
//        "invoice_prefix": "4283D129",
//        "invoice_settings": {
//            "custom_fields": null,
//            "default_payment_method": null,
//            "footer": null,
//            "rendering_options": null
//        },
//        "livemode": false,
//        "metadata": {},
        var name: String // "Joey Gutierrez",
        var phone: String? // "+1786123456",
//        "preferred_locales": [],
//        "shipping": null,
//        "tax_exempt": "none",
//        "test_clock": null
//    }
}
