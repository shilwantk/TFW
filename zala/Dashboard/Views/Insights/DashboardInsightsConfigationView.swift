//
//  DashboardInsightsConfigationView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/21/24.
//

import SwiftUI

struct DashboardInsightsConfigationView: View {
    
    let items: [String] = [
        "Body Temperature",
        "Resting Heart Rate (RHR)",
        "Active Heart Rate (AHR)",
        "Respiratory Rate (RR)",
        "Heart Rate Variability (HRV)",
        "Blood Glucose",
        "Mood Levels",
        "Energy Levels"
    ]
    
    @State var selectedItem: String = ""
    
    var body: some View {
        VStack {
            Text("What vital(s) are you interested in seeing a deep dive on? You can select up to two to compare.")
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(items, id: \.self) { item in
                SelectionCellView(label: item, isSelected: .constant(selectedItem == item)).onTapGesture {
                    selectedItem = item
                }
            }
            StandardButton(title: "Complete Setup")
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text("Configure My Insights")
                    .style(color: .white, size: .x18, weight: .w800)
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}, label: {
                    Image.close
                })
            }
        })
    }
}

#Preview {
    NavigationStack {
        DashboardInsightsConfigationView()
    }
}
