//
//  HabitValueView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/25/24.
//

import SwiftUI

struct HabitValueView: View {
    
    @Environment(HabitService.self) var service
    @State var value: String = ""
    @State private var isSaving: Bool = false
    @Binding var didTapDismiss: Bool
    
    var body: some View {
        VStack {
            Text("How long would you like this habit to last?")
            KeyValueField(key: "Habit Duration",
                          value: $value,
                          placeholder: "Enter Habit Duration (min)",
                          keyboardType: .decimalPad)
            Spacer()
            StandardButton(title: "COMPLETE") {
                self.isSaving = true
                service.value = value
                if let habitPlanId = service.habitPlanId, !habitPlanId.isEmpty {
                    service.createHabit(cpId: habitPlanId, assignPlan: false)
                } else {
                    service.createHabitPlan { complete in
                        isSaving = false
                    }
                }
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
        .onChange(of: service.didCompleteHabit) { oldValue, newValue in
            isSaving = false
            didTapDismiss.toggle()
        }
    }
}
