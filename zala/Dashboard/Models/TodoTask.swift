//
//  TodoTask.swift
//  zala
//
//  Created by Kyle Carriedo on 5/8/24.
//

import Foundation
import Foundation
import ZalaAPI

enum TaskPeriod {
    case morning
    case noon
    case night
    case anytime
}

extension TodoTask {
    
    var periodType: TaskPeriod {
        guard period?.count == 2 else { return .anytime }
        guard let period else {return .anytime }
        let startTimestamp = period[0]
         // let endTimestamp = period[1]

         var calendar = Calendar.current
         calendar.timeZone = TimeZone(abbreviation: "GMT") ?? TimeZone(secondsFromGMT: 0)!

         let startDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
         let startHour = calendar.component(.hour, from: startDate)
        
        switch startHour {
        case 3..<12:
            return .morning
        case 12..<17:
            return .noon
        case 17..<24, 0..<3:
            return .night
        default:
            return .anytime
        }
    }
}


extension TodoTask {
    
    func isAll() -> Bool {
        return isAnyTime() &&
        isMorning() &&
        isNoon() &&
        isNight()
    }
    
    func isAnyTime() -> Bool {
        return self.task?.fragments.taskModel.isAnytime() ?? false
    }      
    
    func isMorning() -> Bool {
        return self.task?.fragments.taskModel.isMorning() ?? false
    }
    
    func isNoon() -> Bool {
        return self.task?.fragments.taskModel.isNoon() ?? false
    }
    
    func isNight() -> Bool {
        return self.task?.fragments.taskModel.isNight() ?? false
    }
    
    func task() -> TaskModel {
        return task!.fragments.taskModel
    }
    
    func planTitle() -> String {
        return task().carePlan?.name ?? "routine"
    }
    
    func formattedTitle() -> String {
        let category = task().title ?? ""
        let title = task().metric?.title ?? ""
        return "\(category) - \(title)"
    }
    
    func isComplete() -> Bool {
        return compliance ?? 0.0 > 0.0
    }
}
