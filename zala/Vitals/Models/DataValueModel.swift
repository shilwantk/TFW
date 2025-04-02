//
//  DataValueModel.swift
//  zala
//
//  Created by Kyle Carriedo on 5/25/24.
//

import Foundation
import ZalaAPI

extension DataValueModel {
    
    func formattedPeriod() -> String {
        guard let periodIso else { return "" }
        if periodIso.count > 1 {
            guard let startDateISO = periodIso.first else { return "" }
            guard let endDateISO = periodIso.last else { return "" }
            let endDate = Date.dateFromISO(dateString: endDateISO).formatted(date: .omitted, time: .shortened)
            let startDate = Date.dateFromISO(dateString: startDateISO).formatted(date: .omitted, time: .shortened)
            return "\(startDate) - \(endDate)"
        } else {
            guard let startDateISO = periodIso.first else { return "" }
            return Date.dateFromISO(dateString: startDateISO).formatted(date: .omitted, time: .shortened)
        }
    }
    
    func formattedCreated() -> String {
        guard let createdAtIso = self.createdAtIso else {
            return ""
        }
        let date = Date.dateFromISO(dateString: createdAtIso)
        if date.isToday() {
            return date.formatted(date: .omitted, time: .shortened)
        } else {
            return DateFormatter.monthDayAndTime(date: date)
        }
    }
}
