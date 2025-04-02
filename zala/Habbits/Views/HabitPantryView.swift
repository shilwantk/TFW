//
//  HabitPantryView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/28/24.
//

import SwiftUI

extension Notification.Name {
    static let dataUpdated = Notification.Name("dataUpdated")
}

struct HabitCategory: Hashable, Identifiable {
    var id = UUID()
    var title: String
    var type: HabitKey
    var icon: Image
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct HabitPantryView: View {
    
    
    @Environment(\.dismiss) var dismiss
    @State var didTapDismiss: Bool = false
    let categories: [HabitCategory] = [
        HabitCategory(title: "Mind", type: .meditation, icon: .habitBrain),
        HabitCategory(title: "Body", type: .body, icon: .habitMeasure),
        HabitCategory(title: "Spiritual", type: .spiritual, icon: .habitSpiritual),
        HabitCategory(title: "Nutrition", type: .diet, icon: .habitFood),
        HabitCategory(title: "Sleep", type: .sleep, icon: .habitSleep),
        HabitCategory(title: "Social", type: .social, icon: .habitSocial),
        HabitCategory(title: "Environmental", type: .environmental, icon: .habitEnvironmental),
        HabitCategory(title: "Skills", type: .environmental, icon: .habitEnvironmental),
        HabitCategory(title: "Breathing", type: .breathing, icon: .habitBreath),
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var selection: HabitCategory? = nil
    var body: some View {
        VStack(alignment: .leading) {
            Text("Habit Categories")
                .style(size:.x22, weight: .w800)
                .padding(.leading, 20)
                .padding(.top)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(categories, id: \.self) { item in
                        VStack {
                            build(icon: item.icon)
                                .padding(.top, 30)
                            Text(item.title)
                                .style(size: .x18, weight: .w500)
                                .padding(.bottom, 30)
                                .padding(.top, 10)
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
                        )
                        .onTapGesture {
                            selection = item
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .fullScreenCover(item: $selection, onDismiss: {
            selection = nil
        }, content: { habit in
            NavigationStack {
                HabitSelectionView(type: habit.type, didTapDismiss: $didTapDismiss)
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Zala Habit Pantry")
        .toolbar(content: {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image.close
                }

            }
        })
        .onChange(of: didTapDismiss) { oldValue, newValue in
            NotificationCenter.default.post(name: .dataUpdated, object: nil)
            dismiss()
        }
    }
    
    fileprivate func build(icon:Image) -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                      stops: [
                        Gradient.Stop(color: Theme.shared.lightBlueGradientColor.primary, location: 0.00),
                        Gradient.Stop(color: Theme.shared.lightBlueGradientColor.secondary, location: 1.00),
                      ],
                      startPoint: UnitPoint(x: 0.5, y: 0),
                      endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                )
                .frame(width: 72, height: 72)
            icon
                .renderingMode(.template)
                .foregroundColor(.black)
                .scaledToFit()
                .frame(minWidth: 44, minHeight: 44)
        }
    }
}

#Preview {
    HabitPantryView()
}
