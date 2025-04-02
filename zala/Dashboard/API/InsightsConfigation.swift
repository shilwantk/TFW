//
//  InsightsConfigation.swift
//  zala
//
//  Created by Kyle Carriedo on 10/30/24.
//

import Foundation

struct InsightsConfigation: Hashable {
    var subtitle: String? = nil
    var isPrimary: Bool = false
    var insight: ZalaInsight
    //for workout
    var startDate: Date? = nil
    var endDate: Date? = nil
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(insight.key)
    }
    
    static func == (lhs: InsightsConfigation, rhs: InsightsConfigation) -> Bool {
        return lhs.insight.key == rhs.insight.key
    }
    
    func graphMsg(_ graphTime: GraphTime) -> String {
        if graphTime == .today {
            return "\(insight.title) based on today."
        } else {
            return "\(insight.title) total based on current week."
        }
    }
}
