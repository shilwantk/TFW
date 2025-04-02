//
//  TaskInputView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/21/24.
//

import SwiftUI
import ZalaAPI

enum TaskInputViewLayout {
    case startAndEndTime
    case startOnly
    case singleValue
    case doubleValue
    case none
}

struct TaskInputView: View {
    @State var task: TaskModel
    @State var todo: TodoTask
    @State var layout: TaskInputViewLayout
    @State var timeOfDay: TimeOfDay    
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(TaskSwiftDataService.self) var cachedService
    @Environment(\.modelContext) var modelContext
    
    @State var startDate: Date = .now
    @State var endDate: Date = .now
    @State var note: String = ""
    @State var service: TasksService = TasksService()
    @State var showWarning: Bool = false
    @Binding var didSave: Bool
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .leading) {
                    DescriptionView(title: "Instructions", 
                                    desc: task.desc ?? "Unlock the full potential of this protocol by ensuring all required information is thoroughly completed. Don't miss the optional notes section, where you can add any extra details or insights to make your protocol truly stand out!")
                }
                VStack(alignment: .leading) {
                    Text("Enter Results")
                        .style(size:.x20, weight: .w400)
                    DateDropDownView(
                        key: "Start Time",
                        selectedDate: $startDate,
                        dateAndTime: .constant(true),
                        isDob: false,
                        showKey: true,
                        darkMode: true)
                    DateDropDownView(
                        key: "\(layout == .startOnly ? "Completed" : "End") Time",
                        selectedDate: $endDate,
                        dateAndTime: .constant(true),
                        isDob: false,
                        showKey: true,
                        darkMode: true)
                }
                VStack(alignment: .leading) {
                    Text("Want to add a note?")
                        .style(size:.x20, weight: .w400)
                    VStack(alignment: .leading, spacing: 0.0) {
                        TextEditor(text: $note)
                            .scrollContentBackground(.hidden)
                            .background(Theme.shared.mediumBlack)
                            .frame(maxHeight: 300)
                    }
                    .frame(minHeight: 300)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack))
                }
                if showWarning {
                    VStack {
                        Text("Your protocol is sugessting you do \(task.formattedTitle()) but the value you enter was \(valuesOnly().joined(separator: ",")) \(unit()).")
                            .style(color: Theme.shared.orange, size: .regular, weight: .w400)
                            .multilineTextAlignment(.center)
                            .padding([.top, .bottom], 5)
                    }
                    .frame(maxWidth: .infinity, minHeight: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 8).fill(Theme.shared.orange.opacity(0.12))
                    )
                }
                StandardButton(title: "SUBMIT") {
                    save()
                }
            }
            .padding()
            .navigationTitle(task.formattedTitle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image.xIcon
                    })
                }
            }
            .onChange(of: service.taskSaved) { oldValue, newValue in               
                do {
                    try cachedService.markComplete(task, in: modelContext)
                    self.didSave.toggle()
                    dismiss()
                } catch {
                    self.didSave.toggle()
                    dismiss()
                }
            }
        }
    }
    
    fileprivate func autoPopulate() -> [Double] {
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
    
    fileprivate func save() {        
        let taskData = autoPopulate().compactMap({String($0)})
        
        guard let identifier = Network.shared.userId() else { return }
        guard let key = task.key else { return }
        guard !taskData.isEmpty else { return }
        
//        let data = layout == .startOnly ? ["\(task.taskValue())"] : dataValue.values
        
//        let dates = times()
        let date = Date()// timeOfDay.clcualteWorkoutTime()
        let beganEpoch = Int(date.timeIntervalSince1970)
//        let beganEpoch = Int(dataValue.times.start.timeIntervalSince1970)
        let endEpoch = beganEpoch + 100
        var input = AnswerInput(key: key,
                    data: .some(taskData),
                    unit: .some(unit()),
                    beginEpoch: .some(beganEpoch),
                    endEpoch: .some(endEpoch),
                    source: .some(DataValueSourceInput(name: .some("manual entry"), 
                                                       identifier: .some(identifier))))
        
        if !note.isEmpty {
            input.note = .some(AnswerNoteInput(body: .some(note), author: .some(identifier), private:.some(false)))
        }
        service.postTaskResults(title: task.snapTitle(), taskInput: input) { complete in
            service.complete(task: todo) { complete in
                
            }
        }
    }
    
    fileprivate func isTime() -> Bool {
        return layout == .startAndEndTime || layout == .startOnly
    }
    
    fileprivate func unit() -> String {
        switch layout {
        case .startAndEndTime: return task.unit ?? ""
            
        case .startOnly: return task.unit ?? ""
            
        case .singleValue: return task.unit ?? ""
            
        case .doubleValue: return task.unit ?? ""
            
        case .none: return task.unit ?? ""
            
        }
    }
    
    fileprivate func times() -> (start:Date, end:Date) {
        switch layout {
            
        case .startAndEndTime: return (startDate, endDate)
            
        case .startOnly:
            guard let startedAt = endDate.subtractingHr(1) else { return (startDate, endDate) }
            return (startedAt, endDate)
            
        case .singleValue: return (startDate, endDate)
            
        case .doubleValue: return (startDate, endDate)
            
        case .none: return (startDate, endDate)
            
        }
    }
    
    fileprivate func valuesOnly() -> [String] {
        return value()?.values ?? []
    }
    
    fileprivate func value() -> (values:[String], times:(start:Date, end:Date))? {
        switch layout {
            
        case .startAndEndTime:
            if task.unit?.lowercased() == "hr" {
                let hrs = Date.hoursBetweenDates(startDate: startDate, endDate: endDate)
                return ([String(hrs)], (startDate, endDate))
            } else {
                let min = Date.minutesBetweenDates(startDate: startDate, endDate: endDate)
                return ([String(min)], (startDate, endDate))
            }
            
        case .startOnly:
            if task.unit?.lowercased() == "hr" {
                let hrVal = task.taskValue()
                guard let startedAt = endDate.subtractingHr(Int(hrVal)) else { return nil }
                let hrs = Date.hoursBetweenDates(startDate: startedAt, endDate: endDate)
                return ([String(hrs)], (startedAt, endDate))
                
            } else {
                guard let startedAt = endDate.subtractingMin(60) else { return nil }
                let min = Date.minutesBetweenDates(startDate: startedAt, endDate: endDate)
                return ([String(min)], (startedAt, endDate))
            }
            
            
        case .singleValue:
            if task.unit?.lowercased() == "min" {
                let minVal = task.taskValue()
                guard let startedAt = endDate.subtractingMin(Int(minVal)) else { return nil }
                let min = Date.minutesBetweenDates(startDate: startedAt, endDate: endDate)
                return ([String(min)], (startedAt, endDate))
                
            } else if task.unit?.lowercased() == "hr" {
                let hrVal = task.taskValue()
                guard let startedAt = endDate.subtractingHr(Int(hrVal)) else { return nil }
                let hrs = Date.hoursBetweenDates(startDate: startedAt, endDate: endDate)
                return ([String(hrs)], (startedAt, endDate))
                
            } else {
                guard let startedAt = endDate.subtractingMin(60) else { return nil }
                let min = Date.minutesBetweenDates(startDate: startedAt, endDate: endDate)
                return ([String(min)], (startedAt, endDate))
            }
            
        case .doubleValue: return nil
            
        case .none: return nil
            
        }
    }
}
