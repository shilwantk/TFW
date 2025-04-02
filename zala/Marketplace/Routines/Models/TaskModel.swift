//
//  TaskModel.swift
//  zala
//
//  Created by Kyle Carriedo on 5/11/24.
//

import Foundation
import ZalaAPI
import SwiftUI

extension TaskModel: @retroactive Identifiable {
    enum TaskCategory: String {
        case fitness
        case measure
        case nutrition
        case photo
        case spiritual
        case supplement
        case sleep
        case social
        case environmental
        case breathing
        case mind
        case other
        case none
    }
    
    func fitness() -> [String] {
        return ["activeness", "activity", "distance", "endurance","flexibiilty","movement","power", "strength", "coordination"]
    }
    
    func nutrition() -> [String] {
        return ["calories", "diet"]
    }
    
    func measure() -> [String] {
        return ["body", "vital", "menstruation", "position"]
    }
    
    func mindBrainMental() -> [String] {
        return [ "stress", "cognitive", "mindfulness", "recovery"]
    }
    
    func documentPhoto() -> [String] {
        return ["document"]
    }
    
    func spiritual() -> [String] {
        return ["spiritual"]
    }
    
    func supplement() -> [String] {
        return ["medication"]
    }
    
    func sleep() -> [String] {
        return ["sleep", "rest"]
    }
    
    func social() -> [String] {
        return ["social"]
    }
    
    func breathing() -> [String] {
        return ["breathing","respiration"]
    }
    
    func environmental() -> [String] {
        return ["environmental"]
    }
    
    
    func taskMeta() -> (kind: TaskCategory, icon: Image) {
        let defaultKind = (TaskCategory.other, Image.training)
        guard let item = key?.split(separator: ".").first else { return defaultKind }
        let key = String(item)
        
        if fitness().contains(key) {
            return (.fitness, Image.training)
            
        } else if nutrition().contains(key) {
            return (.nutrition, Image.nutrition)
        }
        else if measure().contains(key) {
            return (.measure, Image.measure)
        }
        else if mindBrainMental().contains(key) {
            return (.mind, Image.brain)
        }
        else if documentPhoto().contains(key) {
            return (.photo, Image.photo)
        }
        else if spiritual().contains(key) {
            return (.spiritual, Image.spiritual)
        }
        else if sleep().contains(key) {
            return (.sleep, Image.sleep)
        }
        else if social().contains(key) {
            return (.social, Image.social)
        }
        else if breathing().contains(key) {
            return (.breathing, Image.breathing)
        }
        else if environmental().contains(key) {
            return (.environmental, Image.environmental)
        }
        else {
            return defaultKind
        }
    }
    
    func layout() -> TaskInputViewLayout {
        let kind = taskMeta().kind
        let isBloodPressure = self.key == "vital.blood_pressure"
        
        switch kind {
        case .fitness: return .singleValue
            
        case .measure: return isBloodPressure ? .doubleValue : .singleValue
            
        case .photo: return .singleValue
            
        case .supplement, .nutrition: return .startOnly
                        
        case .mind, .other, .spiritual, .sleep, .environmental, .breathing, .social: return .startAndEndTime
            
        case .none: return .startAndEndTime
            
        }
    }
    
    func formattedTestType() -> String {
        if isAtLeast() {
            return "at least"
        } else if isAtMost() {
            return "at most"
        } else if isBetween() {
            return "between"
        } else {
            return ""
        }
    }
    
    func isDaily() -> Bool {
        return self.interval == "day"
    }
    
    func isWeekly() -> Bool {
        return self.interval == "week"
    }
    
    func isMonthly() -> Bool {
        return self.interval == "month"
    }
    
    func isBetween() -> Bool {
        return self.testType == "maintain"
    }
    
    func isAtLeast() -> Bool {
        return self.testType == "at_least"
    }
    
    func isAtMost() -> Bool {
        return self.testType == "at_most"
    }
    
    func isPending() -> Bool {
        return self.status == "pending"
    }
    
    func isActive() -> Bool {
        return self.status == "active"
    }
    
    func isMorning() -> Bool {
        guard let times = self.timeFrames else {
            return false
        }
        return times.contains("morning")
    }
    
    func isNoon() -> Bool {
        guard let times = self.timeFrames else {
            return false
        }
        return times.contains("afternoon")
    }
    
    func isNight() -> Bool {
        guard let times = self.timeFrames else {
            return false
        }
        return times.contains("evening")
    }
    
    func isAnytime() -> Bool {
        guard let times = self.timeFrames else {
            return false
        }
        return times.contains("anytime")
    }
    
    func isCumliative() -> Bool {
        return self.metric?.cumulative ?? false
    }
    
    func snapTitle() -> String {
        if let title = metric?.title {
            return title
        } else {
            return title ?? self.formattedTitle()
        }
    }
    
    func formattedTitle() -> String {
        guard let mainTitle = title, let _ = self.key else {
            return "{MISSING TITLE AND KEY}"
        }
        if isHabit {
            return desc ?? ""
        } else {
            
            var titleString = ""
            
    //        let formattedTestType = self.formattedTestType()
            let formattedValues   = self.formattedValues()
            
    //        if !formattedTestType.isEmpty {
    //            titleString.append(" - \(formattedTestType.capitalized)")
    //        }
            
            if let metricTitle = self.metric?.title, !metricTitle.isEmpty {
                titleString = metricTitle.capitalized
            } else {
                titleString = mainTitle.capitalized
            }
            
            if !formattedValues.isEmpty {
                titleString.append(" - \(formattedValues)")
            }
            
            return titleString

        }
    }
    
    func formattedMeasureType() -> String {
        if let timeData = self.timeFrames, !timeData.isEmpty {
            let timeFrames = timeData.compactMap({$0.capitalized}).joined(separator: ",")
            return timeFrames
        } else if let meadData = self.mealInfo, !meadData.isEmpty {
            return self.mealInfo ?? ""
        } else {
            return ""
        }
    }
    
    func formattedFrequency() -> String {
        var titleString       = ""
        let formattedTestType = self.formattedTestType()
        let formattedValues   = self.formattedValues()
        
        if !formattedTestType.isEmpty {
            titleString.append(formattedTestType.capitalized)
        }
        
        if !formattedValues.isEmpty {
            titleString.append(" - \(formattedValues)")
        }
        
        if let info = self.mealInfo, info != "anytime" {
            titleString.append(" (\(info.capitalized) Meal)")
        }
        return titleString
    }
    func formattedSubTitleTimes() -> String {
        if isDaily() {
            return "Daily • \(self.formattedTimesPerDay()) • \(formattedMeasureType())"
        } else if isWeekly() {
            guard let dow = self.daysOfWeek else {
                return "{MISSING DOW}"
            }

            return dow.isEmpty  ? "Weekly"  : "Weekly \(self.formattedDaysOfTheWeek()) • \(self.formattedTimesPerDay()) • \(formattedMeasureType())"
        } else {
            guard let dom = self.daysOfMonth else {
                return "{MISSING DOM}"
            }
            return dom.isEmpty ? "Monthly" : "Monthly on \(self.formattedMonthlyDays()) • \(self.formattedTimesPerDay()) • \(formattedMeasureType())"
        }
    }
    
    var isHabit: Bool {
        carePlan?.owner?.id?.lowercased() == Network.shared.userId()?.lowercased()
    }
    
    func formattedSubTitle() -> String {
        return isHabit ? "\(carePlan?.name ?? "routine")" : "protocol - \(carePlan?.name ?? "routine")"
//        if isDaily() {
//            return "Daily • \(self.formattedTimesPerDay()) • \(formattedMeasureType())"
//        } else if isWeekly() {
//            guard let dow = self.daysOfWeek else {
//                return "{MISSING DOW}"
//            }
//
//            return dow.isEmpty  ? "Weekly"  : "Weekly \(self.formattedDaysOfTheWeek()) • \(self.formattedTimesPerDay()) • \(formattedMeasureType())"
//        } else {
//            guard let dom = self.daysOfMonth else {
//                return "{MISSING DOM}"
//            }
//            return dom.isEmpty ? "Monthly" : "Monthly on \(self.formattedMonthlyDays()) • \(self.formattedTimesPerDay()) • \(formattedMeasureType())"
//        }
    }
    
    func taskValue() -> Double {
        guard let allValues = self.data else { return 0.0 }
        if allValues.isEmpty { return 0.0 }
        if isBetween() {
            return allValues.last ?? 0.0
        } else if isAtMost() {
            return allValues.last ?? 0.0
        } else if isAtLeast() {
            return allValues.first ?? 0.0
        } else {
            return allValues.last ?? 0.0
        }        
    }
    
    func formattedValues() -> String {
        guard let allValues = self.data else { return "" }
        
        if allValues.isEmpty { return "" }
        
        if isBetween() {
            return "\(allValues[0]) - \(allValues[1]) \(self.unit ?? "")"
        } else {
            return "\(allValues[0]) \(self.unit ?? "")"
        }
    }
    
    func formattedMonthlyDays() -> String {
        guard let dow = self.daysOfWeek else {
            return "{MISSING DOW}"
        }
        
        return "(\(dow.map({String($0)}).map({$0}).joined(separator: "/")))"
    }
    func formattedDaysOfTheWeek() -> String {
        guard let dow = self.daysOfWeek else {
            return "{MISSING DOW}"
        }
        return "(\(dow.map({$0}).joined(separator: "/").capitalized))"
    }
    
    func formattedTimesPerDay() -> String {
        guard let timeFrames = self.timeFrames else {
            return "{MISSING TIMESFRAMES}"
        }
        return "\(timeFrames.count) times"
    }
    
    var score: Double {
        guard let scoreData = self.compliance?.rounded() else { return 0.0}
        let dataScore = (scoreData / 100.0)
        return dataScore
    }
}
