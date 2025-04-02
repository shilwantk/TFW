//
//  HabitService.swift
//  zala
//
//  Created by Kyle Carriedo on 5/25/24.
//

import Foundation
import SwiftUI
import ZalaAPI
import Observation

enum HabitKey: String {
    case meditation = "mindfulness"
    case spiritual
    case body
    case sleep
    case social
    case environmental
    case breathing
    case measure = "vital"
    case supplement
    case diet
    case workout = "activity"
    case train
    
    var isTime: Bool {
        switch self {
        case .body,.meditation, .spiritual, .sleep, .social, .environmental, .breathing, .workout, .train: true
        case .measure, .supplement, .diet: false
        }
    }
    
    var keys: [String] {
        switch self {
        case .meditation: return []
            
        case .spiritual:
            return []
        case .sleep:
            return []
        case .social:
            return []
        case .environmental:
            return []
        case .breathing:
            return []
        case .measure:
            return []
        case .supplement:
            return []
        case .workout:
            return []
        case .train:
            return []
        case .body:
            return []
        case .diet:
            return []
        }
    }
}

@Observable class HabitService {
    
    var habitPlanId: String? = nil
    var selectedMetric: MetricModel?
    var habitCategory:  HabitKey?
    var selectedFreqency: HabitSelection? //interval day, week, month
    var selectedKind: HabitCalendarPickerKind? 
    
    var selectedDays: Set<HabitSelection> = [] //mon , tue etc...
    var selectedTimes: Set<HabitSelection> = [] //anytime, morning noon, night
    var selectedNumbers: Set<Int> = [] //number on a month
    var value: String = ""
    
    var didCompleteHabit:Bool = false
    
    
    var accountService: AccountService = AccountService()
        
    
    fileprivate func validation() -> Bool {
        guard selectedMetric != nil else { return false }
        guard selectedFreqency != nil else { return false }
        guard !selectedTimes.isEmpty else { return false }
        return true
    }
    
    func requiresTime() -> Bool {
        if let category = habitCategory {
            return category.isTime
        } else {
            return false
        }
    }
    
    
    func activateHabit(id: String, handler: @escaping (Bool) -> Void) {
        Network.shared.apollo.perform(mutation: ActivateHabitMutation(input: .some(IDInput(id:id)))) { response in
            switch response {
            case .success(_):
                handler(true)
                
            case .failure(_):
                handler(false)
                
            }
        }
    }
    
    func getHabitPlan() {
        accountService.fetchAccount { complete in
            self.habitPlanId = self.accountService.habitPlanId
        }
    }
    
    //step 1
    func createHabitPlan(handler: @escaping (Bool) -> Void) {
        
        let input = CarePlanCreateInput(
            name: "Zala Habit",
            focus: "habit",
            description: "Your personalized habit plan.",
            durationInDays: 365)
        
        Network.shared.apollo.perform(mutation: CreateHabitPlanMutation(id: .zalaOrg,
                                                                         input: .some(input))) { response in
            switch response {
            case .success(let result):
                if let plan = result.data?.careplanCreate?.carePlan?.id {
                    self.habitPlanId = plan
                    self.createHabit(cpId: plan)
                    self.saveHaibit(plan: plan) { complete in
                        handler(true)
                    }
                } else {
                    handler(false)
                }
                
            case .failure(_):
                handler(false)
            }
        }
    }
    
    fileprivate func saveHaibit(plan: String, handler: @escaping (Bool) -> Void) {
        guard let userId = Network.shared.userId() else { return }
        accountService.addPreference(userId: userId, input: PreferenceInput(key: .habitPlan, value: [plan])) { complete in
            handler(complete)
        }
    }
    
    //Step 2 or used for adding more habits
    func createHabit(cpId: String, assignPlan: Bool = true) {
        
        let times = Array(selectedTimes.compactMap({$0.key.rawValue}))
        guard let category = habitCategory?.rawValue else { return }
        guard let key = selectedMetric?.key else { return }
        guard let title = selectedMetric?.title else { return  }
        guard let value = Double(value) else { return  }
        guard let interval = selectedFreqency?.key.rawValue else { return  }
        let values = [value]
        let input = TaskCreateInput(carePlan: cpId,
                         key: key,
                         title: .some(category),
                         desc: .some(title.lowercased()),
                         testType: "at_least",
                         data: .some(values),
                         interval: .some(interval),
                         timeFrames: .some(times),
                         mealInfo: "anytime")
        
        Network.shared.apollo.perform(mutation: CreateHabitMutation(input: .some(input))) { response in
            switch response {
            case .success(let result):
                if assignPlan {
                    self.assignPlanHabit()
                } else {
                    if let id = result.data?.taskCreate?.task?.id {
                        self.activateHabit(id: id) { complete in
                            self.didCompleteHabit.toggle()
                        }
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    //Step 3
    func assignPlanHabit() {
        guard let habitPlanId  else { return }
        guard let userId = Network.shared.userId() else { return }
        Network.shared.apollo.perform(mutation: AssignHabitPlanMutation(input: .some(CarePlanAssignInput(
            id: habitPlanId,
            user: userId,
            inviteMessage: .some("Welcome to your Habit plan where you can create and track your own Habits."))))) { response in
            switch response {
            case .success(let result):
                self.habitPlanId = result.data?.careplanAssign?.carePlan?.id
                self.acceptHabitPlan(id: result.data?.careplanAssign?.carePlan?.id ?? "")
            case .failure(_):
                break
            }
        }
    }
    
    //Step 4
    func acceptHabitPlan(id: String) {
        Network.shared.apollo.perform(mutation: RoutineAcceptMutation(input: .some(CarePlanAcceptInput(id: id)))) { response in
            switch response {
            case .success(_):
                self.didCompleteHabit.toggle()
                
            case .failure(_):
                self.didCompleteHabit.toggle()
                
            }
        }
    }
    
    func removeHabit(id: String, handler: @escaping (Bool) -> Void) {
        Network.shared.apollo.perform(mutation: RemoveHabitMutation(input: .some(.init(id: id)))) { response in
            switch response {
            case .success(_):
                handler(true)
                
            case .failure(_):
                handler(true)                
            }
        }
    }
    
    func cancelHabit(id: String, handler: @escaping (Bool) -> Void) {
        Network.shared.apollo.perform(mutation: CancelHabitMutation(input: .some(.init(id: id)))) { response in
            switch response {
            case .success(_):
                handler(true)
                
            case .failure(_):
                handler(true)
            }
        }
    }
    
    func completeHabit(id: String) {
        Network.shared.apollo.perform(mutation: CompleteHabitMutation(input: .some(.init(id: id)))) { response in
            switch response {
            case .success(_):
                self.didCompleteHabit.toggle()
                
            case .failure(_):
                self.didCompleteHabit.toggle()
            }
        }
    }
}
