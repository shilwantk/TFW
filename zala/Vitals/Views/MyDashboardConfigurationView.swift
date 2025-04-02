//
//  MyDashboardConfigurationView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/24/24.
//

import SwiftUI

struct MyDashboardConfigurationView: View {
    
    @Environment(VitalsService.self) var service
    @Environment(AccountService.self) var accountService
    @Environment(\.dismiss) var dismiss
    @State var search: String = ""
    var actionTapped: (() -> Void)?
    var body: some View {
        VStack {
            Text("Select vitals to configure your dashboard.")
                .style(weight: .w400)
            TextField("Search vital", text: $search)
                .textFieldStyle(.roundedBorder)
                .onChange(of: search) { oldValue, newValue in
                    service.search(string: newValue)                    
                }
            ScrollView {
                ForEach(service.allMetrics, id: \.self) { metric in
                    SelectionCellView(label: metric.title ?? "-", isSelected: .constant(service.vitalsSelection.contains(metric))).onTapGesture {
                        service.handleSelection(metric: metric)
                    }
                }
            }
            Spacer()
            StandardButton(title: "Save") {
                accountService.updateVital(metricKeys: service.vitalsSelection.compactMap({$0.key})) { complete in
                    UserDefaults.standard.setValue(true, forKey: .configureDashboard)
                    actionTapped?()
                    dismiss()
                }
            }.padding()
        }.onAppear {
            service.isSearching = false
            service.fetchMetrics { complete in }
        }
        .navigationTitle("Dashboard Configuration")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                let title = service.vitalsSelection.isEmpty ? "Select All" : "Deselect All"
                Button(action: {
                    service.handleAllSelection()
                }, label: {
                    Text(title)
                        .foregroundColor(Theme.shared.orange)
                })
            }
            ToolbarItem(placement: .cancellationAction) {
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
    MyDashboardConfigurationView()
}
