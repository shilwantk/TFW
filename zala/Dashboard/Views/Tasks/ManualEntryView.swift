//
//  ManualEntryView.swift
//  zala
//
//  Created by Kyle Carriedo on 9/7/24.
//

import SwiftUI
import ZalaAPI

struct ManualEntry {
    var type: String
    var question: String
    var placeholder: String
    var valuePlaceholder: String
    var title: String
    var key: String
    var header: String
    var units: [PickerItem]
    
    func isMedication() -> Bool {
        return type.lowercased() == "medication"
    }
}


struct ManualEntryView: View {
    let entry: ManualEntry
    @State var name: String = ""
    @State var value: String = ""
    @State var dateTime: Date = .now
    @State var selectedOption: PickerItem = .defaultDropdown
    @State var service: TasksService = TasksService()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                Text(entry.question)
                    .style(size:.x20, weight: .w400)
                KeyValueField(key: entry.key,
                              value: $name,
                              placeholder: entry.placeholder)
                Text(entry.header)
                    .style(size:.x20, weight: .w400)
                KeyValueField(key: entry.key,
                              value: $value,
                              placeholder:entry.valuePlaceholder)
                DropDownView(selectedOption: $selectedOption, items: .constant(entry.units))
                DateDropDownView(
                    key: "Enter Time",
                    selectedDate: $dateTime,
                    dateAndTime: .constant(true),
                    isDob: false,
                    showKey: true,
                    darkMode: true)
                Spacer()
                StandardButton(title: "SUBMIT") {
                    save()
                }
            }
            .padding()
            .navigationTitle(entry.title)
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
            .onChange(of: service.taskSaved) {
                dismiss()
            }
        }
    }
    
    fileprivate func save() {
        let dataValue = value
        
        guard let identifier = Network.shared.userId() else { return }
        let key = entry.isMedication() ? "person.medication" : "person.meal"
        
        let unit = entry.isMedication() ? selectedOption.key : "count"
        
//        let dates = times()
        let beganEpoch = Int(dateTime.timeIntervalSince1970)
        let endEpoch = Int(dateTime.timeIntervalSince1970 + 100)
        
        let input = AnswerInput(key: key,
                    data: .some([dataValue]),
                    unit: .some(unit),
                    beginEpoch: .some(beganEpoch),
                    endEpoch: .some(endEpoch),
                    source: .some(DataValueSourceInput(name: .some("manual entry"),
                                                       identifier: .some(identifier))))
        
//        if !note.isEmpty {
//            input.note = .some(AnswerNoteInput(body: .some(note), author: .some(identifier), private:.some(false)))
//        }
        
        service.postTaskResults(title: name.lowercased(), taskInput: input)
    }
}
