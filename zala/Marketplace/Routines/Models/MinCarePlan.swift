//
//  MinCarePlan.swift
//  zala
//
//  Created by Kyle Carriedo on 5/15/24.
//

import Foundation
import ZalaAPI


extension MinCarePlan {
    func numberOfDaysRemaining() -> Int {
        guard let endDateString = self.endAtIso else {
            return 0
        }
        let endDate = Date.dateFromISO(dateString: endDateString)
        return Date.daysBetween(start: Date(), end: endDate)
    }
    
    func isHabitPlan() -> Bool {
        return self.name?.lowercased() == "zala habit"
    }
    
    var score: Double {
        guard let data = self.complianceScore?.raw else { return 0.0 }
        let scoreData = (Double(data) ?? 0.0).rounded()
        let scorePercent = (scoreData / 100)
        return scorePercent
    }
    
    var formattedScore: String {
        guard let data = self.complianceScore?.raw else { return "0%" }
        let scoreData = (Double(data) ?? 0.0).rounded()
        return "\(Int(scoreData))%"
    }
}
