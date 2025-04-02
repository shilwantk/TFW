//
//  AppointmentGroup.swift
//  zala
//
//  Created by Kyle Carriedo on 5/4/24.
//
import Foundation
import SwiftUI
import ZalaAPI

struct AppointmentGroup:Hashable {
    var groupId: String
    var title: String
    var banner: String?
    var services: [MarketplaceAppointmentService]
    var types: Set<String> //In Person, Virtual, Travel
    var cost: [Int] //$150 - $500
    var durations: Set<Int>
    var desc: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    func formattedDuration() -> String {
        if durations.isEmpty {
            return "0"
        } else if durations.count == 1 {
            return "\(durations.first ?? 0)mins"
        } else {
            let array = Array(durations).sorted()
            return "\(array.first ?? 0)min - \(array.last ?? 0)min"
        }
    }
    
    func formattedCost() -> String {
        if cost.isEmpty {
            return "Free"
        } else if cost.count == 1, let price = cost.first {
            if price == 0 {
                return "Free"
            } else {
                return price.formattedAsCurrency() ?? "Free"
            }
        } else {
            let min = cost.first == 0 ? "Free" : cost.first?.formattedAsCurrency() ?? "Free"
            return "\(min) - \(cost.last?.formattedAsCurrency() ?? "Free")"
        }
    }
}
