//
//  AddHabitView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/28/24.
//

import SwiftUI


struct AddHabitView: View {
    
    @State var selectedOption: PickerItem = .defaultDropdown
    @State var options: [PickerItem] = yesNo
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("The power of meditation")
                            .style(size:.x22, weight: .w800)
                        Image("demo-med")
                        Text("Some paragraph about why this habit is good for them, why they should add it etc.")
                            .style(color: Theme.shared.placeholderGray, size:.small, weight: .w400)
                    }
                    Text("Configure Habit")
                        .style(size:.x22, weight: .w800).padding([.bottom,.top])
                    VStack(alignment: .leading, spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How often do you want to perform this habit?")
                                .style(size:.small, weight: .w400)
                            DropDownView(selectedOption: $selectedOption, items: $options)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What time of the day works best for you?")
                                .style(size:.small, weight: .w400)
                            DropDownView(selectedOption: $selectedOption, items: $options)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Do you want to be reminded when its time to start your habit?")
                                .style(size:.small, weight: .w400)
                            DropDownView(selectedOption: $selectedOption, items: $options)
                        }
                    }
                }
                .padding()
            }
            Spacer()
            Divider().background(.gray)
            StandardButton(title: "Complete Setup").padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Add Habit")
                        .style(size:.x18, weight: .w800)
                    Text("Meditation - 20min")
                        .style(color: Theme.shared.lightBlue, size:.xSmall, weight: .w400)
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image.close
                })
            }
        })
    }
}

#Preview {
    AddHabitView()
}
