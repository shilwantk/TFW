//
//  WorkoutService.swift
//  zala
//
//  Created by Kyle Carriedo on 12/7/24.
//

import Foundation
import SwiftUI
import ZalaAPI

@Observable class WorkoutService {
    
    //    var workoutRoutines: [MinWorkoutRoutineModel] = []
    var workoutRoutines: [WorkoutRoutineModel] = []
    var workoutPlans: [WorkoutPlanModel] = []
    var anytimePlans: [WorkoutPlanModel] = []
    var morningPlans: [WorkoutPlanModel] = []
    var noonPlans: [WorkoutPlanModel] = []
    var nightPlans: [WorkoutPlanModel] = []
    var inviteRoutine: WorkoutRoutineModel? = nil
    
    var allLookup: [String: Bool] = [:]
    var morningLookup: [String: Bool] = [:]
    var noonLookup: [String: Bool] = [:]
    var nightLookup: [String: Bool] = [:]
    
    //
    func invitedRoutines(id: String, handler: @escaping (_ plan: WorkoutRoutineModel?) -> Void) {
        Network.shared.apollo.fetch(query: WorkoutRoutineByIdQuery(id: id),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                
                let inviteRoutine = result.data?.me?.workoutRoutine?.fragments.workoutRoutineModel
                self.inviteRoutine = inviteRoutine
                
                handler(inviteRoutine)
            case .failure(_):
                handler(nil)                
            }
        }
    }
    
    func myWorkoutRoutines(status: WorkoutStatus) {
        Network.shared.apollo.fetch(query: WorkoutRoutinesQuery(status: .some(status.rawValue)),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                let workouts = result.data?.me?.workoutRoutines?.nodes?.compactMap({$0?.fragments.workoutRoutineModel}) ?? []
                self.workoutRoutines = workouts
            case .failure(_):
                break
            }
        }
    }
    
    func planBy(_ id: String, handler: @escaping (_ plan: WorkoutPlanModel?) -> Void) {
        Network.shared.apollo.fetch(query: WorkoutPlansByIdQuery(id: .some(id))) { response in
            switch response {
            case .success(let result):
                let model = result.data?.me?.workoutPlan?.fragments.workoutPlanModel
                handler(model)
            
            case .failure(_):
                handler(nil)
            }
        }
    }
    
    func plansBy(_ status: WorkoutStatus = .active, _ date: Date) {
        cleanUp()
        Network.shared.apollo.fetch(query: WorkoutPlansQuery(status: .some(status.rawValue)),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                let plans = result.data?.me?.workoutPlans?.nodes?.compactMap({$0?.fragments.workoutPlanModel}) ?? []
                let ids = plans.compactMap { "\(Constants.WORKOUT)_\($0.id ?? "")" }
                self.fetchCompletedWorkouts(planIds: ids, date: date) { complete in
                    self.workoutPlans = plans.filter { plan in
                        if let schedule = plan.schedule {
                            let matchingSchedule = date.matches(schedule: schedule)
                            if matchingSchedule {
                                if schedule.isAnytime() {
                                    self.anytimePlans.append(plan)
                                }
                                
                                if schedule.isMorning() {
                                    self.morningPlans.append(plan)
                                }
                                
                                if schedule.isNoon() {
                                    self.noonPlans.append(plan)
                                }
                                
                                if schedule.isNight() {
                                    self.nightPlans.append(plan)
                                }
                            }
                            return matchingSchedule
                        } else {
                            return false
                        }
                    }
                }
            
            case .failure(_):
                break
            }
        }
    }
    
    
    func fetchCompletedWorkouts(planIds: [String], date: Date, handler: @escaping (_ complete: Bool) -> Void) {
        let startOfDay = Int(date.startOfDay.timeIntervalSince1970)
        let endOfDay = Int(date.endOfDayByTime().timeIntervalSince1970)
        Network.shared.apollo.fetch(query: TaskVitalsQuery(metrics: planIds,
                                                           sinceEpoch: .some(startOfDay),
                                                           untilEpoch: .some(endOfDay)),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                
                let nodes = result.data?.me?.dataValues?.nodes ?? []
                
                self.allLookup = nodes.reduce(into: [String : Bool](), { json, model in
                    
                    if let key = model?.key {
                        json[key] = !key.isEmpty
                    }                                        
                    
                    if let key = model?.key,
                       let beginAt = model?.beginAt {
                        let date = Date(timeIntervalSince1970: .init(beginAt))
                        if date.isMorning(timeZone: .gmt) {
                            self.morningLookup[key] = !key.isEmpty
                        }
                        if date.isAfternoon(timeZone: .gmt) {
                            self.noonLookup[key] = !key.isEmpty
                        }
                        if date.isEvening(timeZone: .gmt) {
                            self.nightLookup[key] = !key.isEmpty
                        }
                    }
                    
                })
                handler(true)
                
                
            case .failure(_):
                handler(false)
                break
            }
        }
    }
    
    func workoutRoutineById(routineId: String) {
        
        Network.shared.apollo.fetch(query: WorkoutRoutineByIdQuery(id: routineId)) { response in
            
        }
    }
    
    func updateWorkoutRoutine(routineId: String, status: WorkoutActionType, handler: @escaping (_ complete: Bool) -> Void) {
        Network.shared.apollo.perform(mutation: WorkoutRoutineUpdateMutation(input:
                .some(WorkoutRoutineUpdateInput(id: routineId,
                                                action: .some(status.rawValue))))) { response in
            switch response {
            case .success(_):       
                handler(true)                                
                
            case .failure(_):
                handler(false)
                                
            }
        }
    }
    
    func cleanUp() {
        workoutPlans  = []
        anytimePlans  = []
        morningPlans  = []
        noonPlans  = []
        nightPlans  = []
    }
}


struct WorkoutSchedule: Decodable {
    let daysOfMonth: [Int]
    let daysOfWeek: [String]
    let interval: String
    let timeframes: [String]
    
    func isMorning() -> Bool {
        return timeframes.contains("morning")
    }
    
    func isNoon() -> Bool {
        return timeframes.contains("afternoon")
    }
    
    func isNight() -> Bool {
        return timeframes.contains("evening")
    }
    
    func isAnytime() -> Bool {
        return timeframes.contains("anytime")
    }
    
}

extension Date {
    func matches(schedule: WorkoutSchedule) -> Bool {
        let calendar = Calendar.autoupdatingCurrent
        
        // Check if the date matches any day of the month
        if !schedule.daysOfMonth.isEmpty {
            let dayOfMonth = calendar.component(.day, from: self)
            if !schedule.daysOfMonth.contains(dayOfMonth) {
                return false
            }
        }
        
        // Check if the date matches any day of the week
        if !schedule.daysOfWeek.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let dayOfWeek = formatter.string(from: self).lowercased()
            if !schedule.daysOfWeek.contains(dayOfWeek) {
                return false
            }
        }
        
        return true
    }
}

extension Array where Element == WorkoutSchedule {
    func matchesAny(for date: Date) -> Bool {
        return self.contains { schedule in
            date.matches(schedule: schedule)
        }
    }
}


extension WorkoutRoutineModel {
    var allPlans: [WorkoutPlanModel] {
        self.plans?.nodes?.compactMap({$0?.fragments.workoutPlanModel}) ?? []
    }
}

extension WorkoutPlanModel {
    
    var schedule: WorkoutSchedule? {
        
        guard let jsonString = self.frequency else { return nil }
        
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(WorkoutSchedule.self, from: jsonData)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    var isDaily: Bool {
        return self.frequency == "day"
    }
    
    var isWeekly: Bool {
        return self.frequency == "week"
    }
    
    var isMonthly: Bool {
        return self.frequency == "month"
    }
    
    var isBetween: Bool {
        return self.frequency == "maintain"
    }
}
