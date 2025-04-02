//
//  TasksService.swift
//  zala
//
//  Created by Kyle Carriedo on 5/8/24.
//

import Foundation
import ZalaAPI

@Observable class TasksService {
    var morning: [TodoTask] = []
    var afternoon: [TodoTask] = []
    var night: [TodoTask] = []
    var anytime: [TodoTask] = []
    var allTasks: [TaskModel] = [] //needs to be task for swift data
    var keys: [String] = []
    var vitalLookup: [String: Bool] = [:]
    var morningLookup: [String: Bool] = [:]
    var noonLookup: [String: Bool] = [:]
    var nightLookup: [String: Bool] = [:]
    
    var taskSaved: Bool = false
    
    func clear() {
        allTasks = []
        morning = []
        afternoon = []
        night = []
        anytime = []
    }
    
    func clearVitals() {
        vitalLookup = [:]
        morningLookup = [:]
        noonLookup = [:]
        nightLookup = [:]
    }
    
    func isComplete(todo:TodoTask) -> Bool {
        return vitalLookup[todo.task?.key ?? ""] ?? false
    }
    
    func complete(task: TodoTask, handler: @escaping (Bool) -> Void) {
        
        Network.shared.apollo.perform(mutation: CompleteTaskMutation(input: .some(.init(interval: task.id!)))){ result in
            switch result {
            case .success(_):
                handler(true)
                
            case .failure(_):
                
                handler(false)
            }
        }
        
    }
    
    func fetchVitalsTasks(date: Date, handler: @escaping (_ complete: Bool) -> Void) {
        guard !keys.isEmpty else {
            handler(true)
            return
        }
        
        clearVitals()
        let startOfDay = Int(date.startOfDay.timeIntervalSince1970)
        let endOfDay = Int(date.endOfDayByTime().timeIntervalSince1970)
        Network.shared.apollo.fetch(query: TaskVitalsQuery(metrics: Array(keys),
                                                           sinceEpoch: .some(startOfDay),
                                                           untilEpoch: .some(endOfDay)),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                
                self.vitalLookup = result.data?.me?.dataValues?.nodes?.reduce(into: [String : Bool](), { json, model in
                    
                    if let key = model?.key {
                        json[key] = !key.isEmpty
                    }
                    
                    if let key = model?.key,
                       let beginAt = model?.beginAt {
                        let date = Date(timeIntervalSince1970: .init(beginAt))
                        if date.isMorning(timeZone: .gmt) {
                            self.morningLookup[key] = !key.isEmpty
                        } else if date.isAfternoon(timeZone: .gmt) {
                            self.noonLookup[key] = !key.isEmpty
                        } else if date.isEvening(timeZone: .gmt) {
                            self.nightLookup[key] = !key.isEmpty
                        }
                    }
                    
                }) ?? [:]
                handler(true)
                
                
            case .failure(_):
                handler(false)
                break
            }
        }
    }
    
    func fetchTasksFor(date:Date, handler: @escaping (_ complete: Bool) -> Void) {
        clear()
        let taskDate = Date.yearMonthDayString(date: date)
        
        Network.shared.apollo.fetch(query: TodaysTasksQuery(date: .some(taskDate)), cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                let data = result.data?.me?.tasksTodo?.compactMap({$0}) ?? []
                let todos = data.compactMap({$0.dayIntervals}).flatMap({$0}).compactMap({$0.fragments.todoTask})
//                self.keys = data.compactMap({$0.key})
                
                for todo in todos {
                    let type: TaskPeriod = todo.isAnyTime() ? .anytime : todo.periodType
                    switch type {
                    case .morning:
                        self.morning.append(todo)
                    case .noon:
                        self.afternoon.append(todo)
                    case .night:
                        self.night.append(todo)
                    case .anytime:
                        self.anytime.append(todo)
                    }
                }
                handler(true)
                
            case .failure(_):
                handler(false)
            }
        }
    }
    
    //MARK: - Newtwork
    func postTaskResults(title: String, taskInput: AnswerInput, handler: ((Bool) -> Void)? = nil) {
        guard let userId = Network.shared.userId() else { return }
        let beganDateEpoch = taskInput.beginEpoch.unwrapped ?? Int(Date().timeIntervalSince1970)

        let input = UserAddDataInput(user: .some(userId),
                         kind: .some(Constants.USER_CREATE),
                         name: .some(title),
                         beginEpoch: .some(beganDateEpoch),
                         data: .some([taskInput]))
        
        Network.shared.apollo.perform(mutation: CreateVitalMutation(input: .some(input))) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                handler?(true)
                taskSaved.toggle()
                
            case .failure(_):
                handler?(false)
                taskSaved.toggle()
            }
        }
    }
    
    func upload(base64: String,
                            attachmentKey: String,
                            handler: @escaping (String?) -> Void) {
        Network.shared.apollo.perform(mutation: CreateAttachmentMutation(auth: .null, input: .some(AttachmentCreateInput(label: .some(attachmentKey) , base64: base64)))){ response in            
            switch response {
            case .success(let result):
                let attachmentId = result.data?.attachmentCreate?.attachment?.id
                handler(attachmentId)
            case .failure(_):
                handler(nil)
                
            }
        }
    }
    
    func autocomplete(task: TaskModel, timeOfDay: TimeOfDay, handler: @escaping (Bool) -> Void) {
        let taskData = autoPopulate(task: task).compactMap({String($0)})
        
        guard let identifier = Network.shared.userId() else { return }
        guard let key = task.key else { return }
        guard !taskData.isEmpty else { return }
        
        let date = timeOfDay.clcualteWorkoutTime()?.timeIntervalSince1970
        
        let beganEpoch = Int(date ?? 0.0)
        let unit =  task.unit ?? ""

        let endEpoch = beganEpoch + 100
        let input = AnswerInput(key: key,
                    data: .some(taskData),
                    unit: .some(unit),
                    beginEpoch: .some(beganEpoch),
                    endEpoch: .some(endEpoch),
                    source: .some(DataValueSourceInput(name: .some("manual entry"),
                                                       identifier: .some(identifier))))
        
        self.postTaskResults(title: task.snapTitle(), taskInput: input) { complete in
            handler(complete)
        }
    }
    
    fileprivate func autoPopulate(task: TaskModel) -> [Double] {
        if task.isAtMost() {
            var allData:[Double] = []
            for data in task.data ?? [] {
                if data - 1 <= 0 {
                    allData.append(0.99)
                } else {
                    allData.append(data - 1)
                }
            }
            return allData
            
        } else if task.isAtLeast() {
            return task.data?.compactMap({$0 + 1 }) ?? []
        } else if task.isBetween() {
            let min = task.data?.min() ?? 0
            let max = task.data?.max() ?? 0
            let randomNumber = Double.random(in: min...max)
            return [randomNumber]
        } else {
            return task.data ?? []
        }
    }
}
