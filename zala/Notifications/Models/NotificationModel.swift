//
//  NotificationModel.swift
//  zala
//
//  Created by Kyle Carriedo on 5/5/24.
//
import Foundation
import ZalaAPI
import SwiftUI


extension NotificationModel {
    
    func msg() -> String? {
        guard let json = dictionary() else { return self.content ?? "" }
        if json["conversationId"] != nil {
            return "You have a new message."
        } else {
            return json["title"] as? String
        }
    }
    
    func routineId() -> String? {
        guard let json = dictionary() else { return nil }
        return json["routineId"] as? String
    }
    
    func workoutId() -> String? {
        guard let json = dictionary() else { return nil }
        return json["workoutId"] as? String
    }
    
    func apptId() -> String? {
        guard let json = dictionary() else { return nil }
        return json["apptId"] as? String
    }
    
    func conversationId() -> Int? {
        guard let json = dictionary() else { return nil }
        return json["conversationId"] as? Int
    }
    
    func dictionary() -> [String: Any]? {
        guard let content else { return nil }
        return content.toDictionary()
    }
    
    func isUnread() -> Bool {
        return readAtIso == nil
    }
    
    func isRead() -> Bool {
        return !isUnread()
    }
    
    func msgColor() -> Color {
        if isAccecpted() {
            return Theme.shared.zalaGreen
        } else if isDenied() {
            return Theme.shared.orange
        } else {
            return .white
        }
    }
    
    func isAccecpted() -> Bool {
        guard let subject = msg() else { return false }
        return subject.lowercased().contains("accepted")
    }
    
    func isDenied() -> Bool {
        guard let subject = msg() else { return false }
        return subject.lowercased().contains("cancelled") || subject.lowercased().contains("declined")
    }
    
    func formattedDate() -> String {
        guard let createdAtIso else { return "" }
        guard let date = DateFormatter.dateFromMultipleFormats(fromString: createdAtIso) else { return "" }
        if Calendar.autoupdatingCurrent.isDateInToday(date) {
            return DateFormatter.timeOnly(date: date)
        } else {
            return DateFormatter.monthDay(date: date)
        }
    }
    
}
