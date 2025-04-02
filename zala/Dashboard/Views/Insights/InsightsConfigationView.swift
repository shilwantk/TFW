//
//  InsightsConfigationView.swift
//  zala
//
//  Created by Kyle Carriedo on 4/14/24.
//

import SwiftUI

struct InsightsConfigationView: View {
    
    @Environment(InsightsService.self) var service
    @Environment(\.dismiss) var dismiss
    @State var selections:Set<InsightsConfigation> = []
    @State var workouts:Set<InsightsConfigation> = []
        
    var body: some View {
        VStack {
            Text("What vital(s) are you interested in seeing a deep dive on? You can select up to two to compare.")
                .style(color:.white, size:.x18, weight: .w400)
            ScrollView {
                VStack {
                    ForEach(Array(service.allInsights), id: \.self) { data in
                        SelectionCellView(label: data.insight.title,
                                          isSelected: .constant(selections.contains(data)))
                        .onTapGesture {
                            if selections.contains(data) {
                                selections.remove(data)
                            } else if !maxReached() {
                                selections.insert(data)
                            }
                        }
                    }
                }
//                VStack(alignment: .leading) {
//                    Text("Activity")
//                        .style(color:.white, size:.x22, weight: .w800)
//                    Text("Select a recent activity to overlay on the graph.")
//                        .italic()
//                        .style(color:Theme.shared.placeholderGray, size:.regular, weight: .w300)                    
//                    VStack {
//                        ForEach(Array(service.workoutInsightSelections), id: \.self) { config in
//                            SelectionCellView(label: config.title,
//                                              subTitle: config.subtitle,
//                                              isSelected: .constant(workouts.contains(config)))
//                            .onTapGesture {
//                                if workouts.contains(config) {
//                                    workouts.remove(config)
//                                } else if !maxWorkoutReached() {
//                                    workouts.insert(config)
//                                }
//                            }
//                        }
//                    }
//                }
            }
            Spacer()
            Divider().background(.gray)
            StandardButton(title: "Complete Setup") {
                var data = Array(selections)
                if var dataFirst = selections.first {
                    dataFirst.isPrimary = true
                    data[0] = dataFirst
                    service.primaryInsight = dataFirst
                }
                service.insightSelections = []
                service.insightSelections = data
                
//                service.workoutInsightSelections = []
//                service.workoutInsightSelections = Array(workouts)
                
                dismiss()
            }
            .disabled(!maxReached())
            .padding()
        }
        .navigationTitle("Configure My Insights")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    dismiss()
                } label: {
                    Image.close
                }

            }
        })
        .task {
            workouts = []
//            service.fetchWorkouts()
        }
    }
    
    fileprivate func maxReached() -> Bool {
        return selections.count == 2
    }
    
    fileprivate func maxWorkoutReached() -> Bool {
        return selections.count == 1
    }
}

#Preview {
    InsightsConfigationView()
}
