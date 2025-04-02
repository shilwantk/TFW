//
//  HabitCalendarPickerView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/25/24.
//

import SwiftUI

enum HabitCalendarPickerKind {
    case time
    case days
    case cal
}

struct HabitCalendarPickerView: View {
    
    @Binding var didTapDismiss: Bool
    @Environment(HabitService.self) var service
    @State var daysOfWeek: [HabitSelection] = [
        HabitSelection(title: "Mondays", key: .mon, kind: .days),
        HabitSelection(title: "Tuesdays", key: .tue, kind: .days),
        HabitSelection(title: "Wednesdays", key: .wed, kind: .days),
        HabitSelection(title: "Thursdays", key: .thu, kind: .days),
        HabitSelection(title: "Fridays", key: .thu, kind: .days),
        HabitSelection(title: "Saturdays", key: .thu, kind: .days),
        HabitSelection(title: "Sundays", key: .thu, kind: .days)]
    
    @State var timesOfDay: [HabitSelection] = [
        HabitSelection(title: "Anytime", key: .anytime, kind: .days),
        HabitSelection(title: "Morning (6AM - 12PM)", key: .morning, kind: .days),
        HabitSelection(title: "Afternoon (12PM - 6PM)", key: .afternoon, kind: .days),
        HabitSelection(title: "Evening (6PM - 12AM)", key: .evening, kind: .days)
//        HabitSelection(title: "Custom Time", key: .customTime, kind: .days)
    ]
    
    @State var didTapNext: Bool = false
    @State var kind: HabitCalendarPickerKind
    
    
    let numbers = Array(1...31)
    let columns = Array(repeating: GridItem(.flexible()), count: 7) // 7 columns for a week layout
    @State private var selectedNumbers: Set<Int> = []
    
    //selections
    @State var selDays: Set<HabitSelection> = []
    
    @State var selTime: Set<HabitSelection> = []
    @State private var isSaving: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How often do you want to perform this habit?")
            ScrollView {
                if kind == .days {
                    ForEach(daysOfWeek, id:\.self) { day in
                        SelectionCellView(label: day.title, isSelected: .constant(selDays.contains(day))).onTapGesture {
                            if selDays.contains(day) {
                                selDays.remove(day)
                            } else {
                                selDays.insert(day)
                            }
                        }
                    }
                } else if kind == .time {
                    ForEach(timesOfDay, id:\.self) { time in
                        SelectionCellView(label: time.title, isSelected: .constant(selTime.contains(time))).onTapGesture {
                            if selTime.contains(time) {
                                selTime.remove(time)
                            } else {
                                selTime.insert(time)
                            }
                        }
                    }
                } else {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(numbers, id: \.self) { number in
                            Text("\(number)")
                                .foregroundColor(selectedNumbers.contains(number) ? Theme.shared.upDownButton : Theme.shared.placeholderGray)
                                .frame(width: 44, height: 44)
                                .background(selectedNumbers.contains(number) ? Theme.shared.lightBlue : Theme.shared.mediumBlack)
                                .onTapGesture {
                                    if selectedNumbers.contains(number) {
                                        selectedNumbers.remove(number)
                                    } else {
                                        selectedNumbers.insert(number)
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
            Spacer()
            StandardButton(title: service.requiresTime() ? "CONTINUE" : "COMPLETE") {
                service.selectedKind = kind
                service.selectedTimes = selTime
                service.selectedDays = selDays
                service.selectedNumbers = selectedNumbers
                
                service.requiresTime() ? didTapNext.toggle() : saveHabit()
            }
        }
        .overlay(alignment: .top, content: {
            if isSaving {
                LoadingBannerView(message: "Saving...")
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            }
        })
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
        .navigationDestination(isPresented: $didTapNext) {
            if kind == .days || kind == .cal {
                HabitCalendarPickerView(didTapDismiss: $didTapDismiss, kind: .time).environment(service)
            } else {
                HabitValueView(didTapDismiss: $didTapDismiss).environment(service)
            }
        }
        .onChange(of: service.didCompleteHabit) { oldValue, newValue in
            isSaving = false
            didTapDismiss.toggle()
        }
    }
    
    fileprivate func saveHabit() {
        isSaving = true
        service.value = "1" //they only need to complete the task so 1 value is enough.
        if let habitPlanId = service.habitPlanId, !habitPlanId.isEmpty {
            service.createHabit(cpId: habitPlanId, assignPlan: false)
        } else {
            service.createHabitPlan { complete in
                isSaving = false
            }
        }
    }
}
