//
//  DashboardInsightsView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/21/24.
//

import SwiftUI
import Foundation

struct DashboardInsightsViewEmptyView: View {
    
    @Binding var showConfig: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Welcome to My Insights!")
                .style(color: .white, size: .large, weight: .w800)
                .padding(.top)
            Text("To get started select up to two vitals. You can also overlay an activity to see how the vitals changed during that activity.")
                .italic()
                .style(color: .white, size: .regular, weight: .w500)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            StandardButton(title: "Configure My Insights") {
                showConfig.toggle()
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5).fill(Theme.shared.darkText))
    }
}

struct DashboardInsightsView: View {
    
    @State private var isEmpty: Bool = false
    @State private var showCurrentViewing: Bool = false
    @State private var isScrollable: Bool = false
    @State private var insightsService: InsightsService = InsightsService()
    @State private var graphService: GraphService = GraphService()
    @State private var taskSwiftDataService: TaskSwiftDataService = TaskSwiftDataService()
    @State private var currentDate: Date = Date()
    @State private var calConfig: CalendarHeaderConfig = .week 
    
    @State var selectedDataPoint: ChartData? = nil

    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            CalendarHeaderView(date: $currentDate, config: $calConfig) { type in
                if type == .next {
                    currentDate = currentDate.forwardOneWeek()
                } else if type == .back {
                    currentDate = currentDate.subtractOneWeek()
                }
            }
            if !insightsService.zalaInsights.isEmpty {
                ScrollView {
                    buildCallouts()
                    Spacer()
                    buildGraph()
                }
            } else {
                Spacer()
            }
        }
        .task {
            insightsService.clear()
            buildZalaCallouts(keys: [.hrv, .sleep, .activeEnergy, .rhr])
        }
        .onChange(of: insightsService.selectedInsight) { oldValue, newValue in
            graphInsights()
        }
        .onChange(of: currentDate) { _, _ in
            graphInsights()
        }
    }
    
    fileprivate func buildZalaCallouts(keys: [InsightsKey]) {
        insightsService.buildInsights(for: currentDate)
    }
    
    fileprivate func graphInsights() {
        guard let key = insightsService.selectedInsight?.key else { return }
        guard let weekRange = currentDate.weekRange() else { return }
        
        graphService.clear()
        
        switch key {
            
        case .hrv:
            graphService.buildAvgHRV(start: weekRange.start, end: weekRange.end, isPrimary: false)
            
            
        case .sleep:
            graphService.buildSleep(start: weekRange.start, end: weekRange.end, isPrimary: false)
            
        case .workout:
            break
            
        case .protocol:
            graphService.buildAvgHRV(start: weekRange.start, end: weekRange.end, isPrimary: false)
            
        case .none:
            break
            
        case .activeEnergy:
            graphService.buildActiveEnergy(start: weekRange.start, end: weekRange.end, isPrimary: false)
            
        case .rhr:
            graphService.buildRestingHeartRate(start: weekRange.start, end: weekRange.end, isPrimary: false)
        }
    }
    
    @ViewBuilder
    fileprivate func buildCallouts() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Zala Call Outs")
                    .style(color: .white, size: .large, weight: .w800)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            ForEach(insightsService.zalaInsights, id:\.self) { insight in
                CalloutCellView(title: insight.title,
                                timestamp: insight.timeOnly(),
                                value: insight.reading,
                                msg: insight.msg,
                                elevated: insight.elevated,
                                isSelected: .constant(insightsService.selectedInsight == insight))
                .onTapGesture {
                    graphService.targetColor = insight.elevated ? Theme.shared.orange : Theme.shared.blue
                    insightsService.convert(insight)
                }
            }
        }
    }
    
    @ViewBuilder
    fileprivate func buildGraph() -> some View {
        VStack {
            if insightsService.primaryInsight != nil {
                let data = msg()
                VStack {
                    Text(data.title)
                        .style(color: graphService.targetColor,
                               size: .small,
                               weight: .w400)
                        .align(.leading)
                    Text(data.subtitle)
                        .style(color: graphService.targetColor,
                               size: .xSmall,
                               weight: .w400)
                        .align(.leading)
                }
                .align(.leading)
                .padding(.bottom, 5)
            }
            LineChartView(isScrollable: $isScrollable,
                          selectedDataPoint: $selectedDataPoint)
                .environment(graphService)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
        .padding()
    }
    
    @ViewBuilder
    fileprivate func buildCalloutSelectionHeader() -> some View {
        HStack {
            VStack {
                Text("Currently Viewing")
                    .style(color: Theme.shared.lightBlue,
                           size: .small,
                           weight: .w400)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment:.leading)
                Text(insightsService.primaryInsight?.insight.title ?? "")
                    .style(color: .white,
                           size: .regular,
                           weight: .w700)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment:.leading)
            }
            Spacer()
            Image.pencilCircle
            Button(action: {
                showCurrentViewing.toggle()
            }, label: {
                Text("Edit")
                    .style(color: Theme.shared.lightBlue,
                           size: .regular,
                           weight: .w400)
            })
        }
        .frame(height: 44)
        .padding([.leading, .trailing])
        Divider().background(.gray)
    }
    
    fileprivate func msg() -> (title: String, subtitle: String) {
        if let config = insightsService.primaryInsight {
            let insight = config.insight
            let data = insight.key.displayData()
            if let selectedDataPoint {
                let value = String(format: "%.2f", selectedDataPoint.value)
                let date = DateFormatter.monthDay(date: selectedDataPoint.timeOfDay)
                return ("\(value) \(data.unit)", date)
            } else {
                return (insight.reading, config.graphMsg(graphService.graphTime))
            }
        } else {
            return ("", "")
        }
    }
}

#Preview {
    DashboardInsightsView()
}
