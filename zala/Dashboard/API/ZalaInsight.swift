//
//  ZalaInsight.swift
//  zala
//
//  Created by Kyle Carriedo on 10/30/24.
//

import Foundation

enum InsightsKey {
    ///Heart Rate Variability (HRV)
    case hrv
    
    ///Resting Heart Rate (RHR)
    case rhr
        
    ///Sleep (HR)
    case sleep
    
    case workout
    
    case activeEnergy
    
    case `protocol`
    
    case none

    func displayData() -> (title: String, unit: String) {
        switch self {
        case .hrv: ("Heart Rate Variability", "ms")
        case .sleep: ("Sleep", "hr")
        case .workout: ("", "")
        case .activeEnergy: ("Active Energy", "cal")
        case .protocol: ("", "")
        case .none: ("", "")
        case .rhr: ("Resting Heart Rate", "ms")
            
        }
    }
}

struct ZalaInsight: Hashable {
    var key: InsightsKey
    var reading: String
    var msg: String
    var title: String
    var timestamp: Date
    var elevated: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    static func == (lhs: ZalaInsight, rhs: ZalaInsight) -> Bool {
        return lhs.key == rhs.key
    }
    
    func timeOnly() -> String{
        return DateFormatter.timeOnly(date: timestamp)
    }
    
    static func noChange(key: InsightsKey, title: String) -> ZalaInsight {
        return ZalaInsight(key: key,
                           reading: String(format: "%.0f", 0),
                           msg: "No \(title.lowercased()) data captured.",
                           title: title,
                           timestamp: Date.now,
                           elevated: false)
    }
}
