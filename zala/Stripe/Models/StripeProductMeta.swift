//
//  StripeProductMeta.swift
//  zala
//
//  Created by Kyle Carriedo on 4/13/24.
//

import Foundation

struct StripeProductMeta: Codable {
    var archived: String? // "false",
    var category: String? // "subscription",
    var userId: String? // "018dec07-29e8-7293-a151-472a05d20143"
    var services: String? //"39,44,22"
    var pause: String? //"true"
    
    var isPaused: Bool {
        guard let pause else { return false }
        return pause.lowercased() == "true"
    }
    
    var isArchived: Bool {
        guard let archived else { return false }
        return archived.lowercased() == "true"
    }
    
    var totalAppointments: [String] {
        if let services {
            return services.split(separator: ",").map({String($0)})
        } else {
            return []
        }
    }
}
