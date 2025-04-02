//
//  HabitSelectionView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/25/24.
//

import SwiftUI
import ZalaAPI

struct HabitSelectionView: View {
    
    var vitalsService: VitalsService = VitalsService()
    var service: HabitService = HabitService()
    
    @State var type: HabitKey
    @Binding var didTapDismiss: Bool
    
    @Environment(\.dismiss) var dismiss
    @State var trainMetrics: [MetricModel] = []
    @State var selectedMetric: MetricModel? = nil
    @State var didTapNext: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Which vital from the list would you like to measure?")
            ScrollView {
                ForEach(vitalsService.filteredMetrics, id:\.self) { metric in
                    SelectionCellView(label: metric.title ?? "", isSelected: .constant(selectedMetric == metric)).onTapGesture {
                        self.selectedMetric = metric
                    }
                }
            }
            Spacer()
            StandardButton(title: "CONTINUE") {
                if selectedMetric != nil {
                    didTapNext.toggle()
                }
            }
            .navigationDestination(isPresented: $didTapNext) {
                if selectedMetric != nil {
                    HabitFrequencyView(didTapDismiss: $didTapDismiss).environment(service)
                }
                
            }
        }
        .padding()
        .task {
            service.getHabitPlan()
            vitalsService.fetchMetrics { complete in
                vitalsService.filterMetrics(key: type.rawValue)
            }
        }
        .onChange(of: selectedMetric, { oldValue, newValue in
            service.selectedMetric = newValue
            service.habitCategory = type
        })
        .navigationTitle("CONFIGURE HABIT")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
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
