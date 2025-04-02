//
//  HabitFrequencyView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/25/24.
//

import SwiftUI

enum HabitSelectionKey: String {
    case day
    case week
    case month
    
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun
    
    case anytime
    case morning
    case afternoon
    case evening
    case customTime
}

struct HabitSelection: Hashable {
    var title: String
    var key: HabitSelectionKey
    var kind: HabitCalendarPickerKind
}

struct HabitFrequencyView: View {
    @Binding var didTapDismiss: Bool
    @Environment(HabitService.self) var service
    @State var frequency: [HabitSelection] = [
        HabitSelection(title: "Daily", key: .day, kind: .time),
        HabitSelection(title: "Weekly", key: .week, kind: .days),
        HabitSelection(title: "Monthly", key: .month, kind: .cal)
//        HabitSelection(title: "Specific Time", key: .day, kind: .time)
    ]
    @State var selFrequency: HabitSelection? = nil
    @State var didTapNext: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How often do you want to perform this habit?")
            ScrollView {
                ForEach(frequency, id:\.self) { freq in
                    SelectionCellView(label: freq.title, isSelected: .constant(freq == selFrequency)).onTapGesture {
                        self.selFrequency = freq
                    }
                }
            }
            Spacer()
            StandardButton(title: "CONTINUE") {
                didTapNext.toggle()
            }
        }
        .padding()
        .navigationTitle("CONFIGURE HABIT")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    didTapDismiss.toggle()
                }, label: {
                    Image.close
                })
            }
        })
        .onChange(of: selFrequency, { oldValue, newValue in
            service.selectedFreqency = newValue
        })
        .navigationDestination(isPresented: $didTapNext) {
            if let selFrequency {
                HabitCalendarPickerView(didTapDismiss: $didTapDismiss, kind: selFrequency.kind).environment(service)
            }
        }
    }
}
