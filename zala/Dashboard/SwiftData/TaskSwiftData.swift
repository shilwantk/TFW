//
//  TaskSwiftData.swift
//  zala
//
//  Created by Kyle Carriedo on 10/20/24.
//

import Foundation
import SwiftData
import SwiftUI
import Observation
import ZalaAPI
import Foundation
import SwiftData

@Model
final class TaskSwiftData {
    @Attribute var id: Int
    @Attribute var date: Date
    @Attribute var key: String
    @Attribute var routine: UUID
    @Attribute var isCompleted: Bool
    
    init(id: Int, date: Date, key: String, isCompleted: Bool, routine: UUID) {
        self.id = id
        self.date = date
        self.key = key
        self.isCompleted = isCompleted
        self.routine = routine
    }
}

extension TaskModel {
    func taskSwiftData(complete:Bool, date: Date) -> TaskSwiftData? {
        guard let taskStringId = id else { return nil }
        guard let taskId = Int(taskStringId) else { return nil }
        guard let cpStringId = carePlan?.id else { return nil }
        guard let cpId = UUID(uuidString: cpStringId) else { return nil }
        
        return .init(id: taskId,
                     date: date,
                     key: key ?? "",
                     isCompleted: complete, 
                     routine: cpId)
    }
}



@Observable
class TaskSwiftDataService {
    
    var tasksLookup: [String: Bool] = [:]
    
    func isComplete(todoTask: TodoTask) -> Bool {
        guard let task = todoTask.task?.fragments.taskModel else { return false }
        guard let taskId = task.id else { return false }
        return tasksLookup[taskId] ?? false
    }
    
    func checkComplete(taskId: Int, context: ModelContext) throws -> Bool {
        let fetchDescriptor = FetchDescriptor<TaskSwiftData>(
            predicate: #Predicate { $0.id == taskId }
        )
        
        // Fetch the results
        let tasks = try context.fetch(fetchDescriptor)
        
        // Return the first result if it exists
        return tasks.first?.isCompleted ?? false
    }
    
    // MARK: - Fetch
    func fetchTasks(by ids: [Int], context: ModelContext) {
        // Create a fetch descriptor with a predicate to filter tasks by IDs
        let calendar = Calendar.current
        
        
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let fetchDescriptor = FetchDescriptor<TaskSwiftData>(
            predicate: #Predicate { task in
                task.date >= startOfDay && task.date < endOfDay
            }
        )
        
        do {
            // Fetch the results
            let tasks = try context.fetch(fetchDescriptor)
            tasksLookup = tasks.reduce(into: [String: Bool]()) { json, taskData in
                let id = String(Int(taskData.id))
                let complete = taskData.isCompleted
                json[id] = complete
            }
            
        } catch {
            return
        }
    }
    
        
    //MARK: - Fetch
    func fetchTaskById(taskId: Int, context: ModelContext) throws -> TaskSwiftData? {
        // Create a fetch descriptor with a predicate to filter by id
        let fetchDescriptor = FetchDescriptor<TaskSwiftData>(
            predicate: #Predicate { $0.id == taskId }
        )
        
        // Fetch the results
        let tasks = try context.fetch(fetchDescriptor)
        
        // Return the first result if it exists
        return tasks.first
    }
        
    
    //MARK: - Update
    func markComplete(_ task: TaskModel, in context: ModelContext) throws -> Void {
        guard let taskIdString = task.id else { return }
        guard let taskId = Int(taskIdString) else { return }
        if let task = try fetchTaskById(taskId: taskId, context: context) {
            task.isCompleted = true
            try context.save()
        } else {
            if let task = task.taskSwiftData(complete: true, date: Date()) {
                try bulkSaveTasks([task], in: context)
            }
        }
    }
       
    
    //MARK: - Save
    func save(task:TaskSwiftData, for date: Date, in context: ModelContext) throws {
        if try fetchTaskById(taskId: task.id, context: context) == nil {
            context.insert(task)
            try? context.save()
        }
    }
    
    func bulkSaveTasks(_ tasks: [TaskSwiftData], in context: ModelContext) throws {
        for task in tasks {
            // Check if the task already exists for the same date
            if try fetchTaskById(taskId: task.id, context: context) == nil {
                context.insert(task) // Add the task to the context
            }
        }
        
        // Save all tasks at once
        do {
            try context.save()
            
        } catch {}
    }
    
    //MARK: - Delete
    func deleteTasksByCarePlanId(carePlanId: UUID, context: ModelContext) throws {
        
        let fetchDescriptor = FetchDescriptor<TaskSwiftData>(
            predicate: #Predicate { $0.routine == carePlanId }
        )
                
        let tasksToDelete = try context.fetch(fetchDescriptor)
        
        
        for task in tasksToDelete {
            context.delete(task)
        }
                
        try context.save()
    }
    
    //MARK: - Helpers
    func checkAndStorSwiftDataTasks(_ tasks:[TaskModel], date: Date, context: ModelContext) {
        guard date.isToday() else { return }
        let ids = tasks.compactMap({Int($0.id ?? "0")})
        let swiftDataTasks = tasks.compactMap({$0.taskSwiftData(complete:false, date: Date())})
        do {
            try bulkSaveTasks(swiftDataTasks, in: context)
            _ = try calculateCompletionStats(context: context)
            if !tasks.isEmpty {
                fetchTasks(by: ids, context: context)
            }
        } catch {
        }
        
    }
    
    //MARK: - Calculations
    func calculateCompletionStats(context: ModelContext) throws -> (completedTasks: Int, completionPercentage: Double) {
        // Fetch all tasks
        let allTasks: [TaskSwiftData] = try context.fetch(FetchDescriptor<TaskSwiftData>())
        
        // Total number of tasks
        let totalTasks = allTasks.count
        
        // Total number of completed tasks
        let completedTasks = allTasks.filter { $0.isCompleted }.count
        
        // Calculate completion percentage
//        let completionPercentage = totalTasks > 0 ? (Double(completedTasks) / Double(totalTasks)) * 100 : 0
        let completionPercentage = totalTasks > 0 ? (Double(completedTasks) / Double(totalTasks)) : 0
        
        return (completedTasks, completionPercentage)
    }
}
