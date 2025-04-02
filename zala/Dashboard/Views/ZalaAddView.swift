//
//  ZalaAddView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/28/24.
//

import SwiftUI

struct ZalaAddView: View {
    @Binding var close: Bool
    @Binding var selection: Bool
    @State var showHabbit: Bool = false
    @State var showMedication: Bool = false
    @State var showFood: Bool = false
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Record/Start Habit")
                Button {
                    showHabbit.toggle()
                } label: {
                    Image.menuHabit
                }
                .frame(width: 55, height: 55)
                .padding(.trailing)
            }
            HStack {
                Spacer()
                Text("Record Supplement")
                Button {
                    showMedication.toggle()
                } label: {
                    Image.menuSup
                }
                .frame(width: 55, height: 55)
                .padding(.trailing)
            }
            HStack {
                Spacer()
                Text("Record Meal")
                Button {
                    showFood.toggle()
                } label: {
                    Image.menuNut
                }
                .frame(width: 55, height: 55)
                .padding(.trailing)
            }                        
            HStack {
                Spacer()
                CircleButtonView(icon: .xIcon, 
                                 gradientColor: Theme.shared.blackGradientColor,
                                 action: $close)
            }
            .padding(.bottom, 65)
            
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showMedication) {
            NavigationStack {
                ManualEntryView.init(entry: .medication)
            }
        }
        .fullScreenCover(isPresented: $showHabbit) {
            NavigationStack {
                HabitPantryView()                
            }
        }
        .sheet(isPresented: $showFood) {
            NavigationStack {
                RecordMealView()
            }
        }
    }
}

#Preview {
    ZalaAddView(close: .constant(false), selection: .constant(false))
}


extension ManualEntry {
    static let medication: ManualEntry = .init(type: "medication", 
                                               question: "What medication or supplement did you take?",
                                               placeholder: "Enter Title of Medication",
                                               valuePlaceholder: "Enter Dosage",
                                               title: "RECORD MEDICATION",
                                               key: "Medication",
                                               header: "What was the dosage?",
                                               units: [PickerItem(title: "mg (milligram)", key: "mg"),
                                               PickerItem(title: "g (gram)", key: "g"),
                                               PickerItem(title: "mcg (microgram)", key: "mcg"),
                                               PickerItem(title: "mL (milliliter)", key: "mL"),
                                               PickerItem(title: "L (liter)", key: "L"),
                                               PickerItem(title: "IU (international unit)", key: "IU"),
                                               PickerItem(title: "tablet(s)", key: "tablet"),
                                               PickerItem(title: "capsule(s)", key: "capsule"),
                                               PickerItem(title: "drop(s)", key: "drop"),
                                               PickerItem(title: "puff(s)", key: "puff"),
                                               PickerItem(title: "tsp (teaspoon)", key: "tsp"),
                                               PickerItem(title: "tbsp (tablespoon)", key: "tbsp"),
                                               PickerItem(title: "patch(es)", key: "patch"),
                                               PickerItem(title: "vial(s)", key: "vial"),
                                               PickerItem(title: "ampoule(s)", key: "ampoule"),
                                               PickerItem(title: "spray(s)", key: "spray"),
                                               PickerItem(title: "suppository(s)", key: "suppository"),
                                               PickerItem(title: "cream", key: "cream"),
                                               PickerItem(title: "ointment", key: "ointment")])
}
