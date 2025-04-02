//
//  LineChartView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/21/24.
//

import SwiftUI
import Charts
import HealthKit
import Observation


struct ChartData: Identifiable, Hashable {
    let id = UUID()
    let value: Double
    let timeOfDay: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct GraphData: Equatable {
    var type:String
    var data:[ChartData]
    var key: String = "hr"
}

//let rhrData = GraphData(type: .secondary, data: rhr)
//let hrData = GraphData(type: .primary, data: rhr2)

struct LineChartView: View {
    
    @Binding var isScrollable: Bool
    
    @Environment(GraphService.self) var service
    
    @Binding var selectedDataPoint: ChartData?
    @State private var dragLocation: CGPoint = .zero
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        GeometryReader { geo in
        Chart(service.data, id:\.type) { items in
            ForEach(items.data, id: \.id) { data in
                LineMark(x: .value("time of day", data.timeOfDay),
                         y: .value("hr", data.value))
                .interpolationMethod(.catmullRom)
                .foregroundStyle(service.targetColor)
//                .symbol(.circle)
                .foregroundStyle(by: .value("", items.type))
//                .symbol(by: .value("type", items.type))
                
                ForEach(items.data, id: \.id) { data in
                    PointMark(
                        x: .value("Time of Day", data.timeOfDay),
                        y: .value("hr", data.value)
                    )
                    .symbol(.circle)
                    .foregroundStyle(service.targetColor)
                    .symbol(by: .value("type", items.type))
                    .symbolSize(data == selectedDataPoint ? 100 : 50) // Increase size for selected point
                }
                
                if let workout = service.insightWorkoutSelections.last,
                    let start = workout.startDate,
                    let end = workout.endDate {
                    renderWorkoutOverlay(start: start, end: end, name: workout.insight.title)
                }
                
                // Vertical line that appears on drag
                if let selectedPoint = selectedDataPoint {
                    RuleMark(x: .value("Time of Day", selectedPoint.timeOfDay))
                        .foregroundStyle(service.targetColor)
                        .lineStyle(.init(lineWidth: 2))
//                        .lineStyle(.init(lineWidth: 2, dash: [5, 5]))
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXScale(domain: service.chartXScale, type: .linear)
        .chartLegend(.hidden)
        .chartXAxis(content: {
            AxisMarks(values: .stride(by: .day, count: 1)) { value in
                AxisValueLabel(format: .dateTime.day(.twoDigits), 
                               centered: false)
            }
        })        
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragLocation = value.location
                    updateSelectedDataPoint(location: value.location, in: geo)
                }
                .onEnded { _ in
                    selectedDataPoint = nil // Clear selection on drag end
                }
        )
        }
    }
    
    fileprivate func renderWorkoutOverlay(start: Date, end: Date, name: String) -> some ChartContent {
        return RectangleMark(xStart: .value("Start", start),
                      xEnd: .value("End", end))
            .foregroundStyle(Theme.shared.lightBlue.opacity(0.2))
            .annotation(
                position: .overlay, alignment: .top, spacing: 0, content: {
                    Text(name)
                        .style(color: Theme.shared.lightBlue, size: .xSmall, weight: .w400)
                        .ignoresSafeArea(.all, edges: [.leading, .trailing])
                        .padding([.leading, .trailing], 8)
                        .padding([.top, .bottom], 2)
                        .background {
                            RoundedRectangle(cornerRadius: 2).fill(Theme.shared.darkText)
                        }
                }
            )
            .accessibilityHidden(true)
    }
    
    // Calculate the x-position for a selected point based on time
     private func xPosition(for dataPoint: ChartData, in geo: GeometryProxy) -> CGFloat {
         guard let lastData = service.data.last?.data.last else { return 0.0 }
         guard let firstData = service.data.last?.data.first else { return 0.0 }
         let totalTimeInterval = lastData.timeOfDay.timeIntervalSince(firstData.timeOfDay)
         let timeOffset = dataPoint.timeOfDay.timeIntervalSince(firstData.timeOfDay)
         let xRatio = timeOffset / totalTimeInterval
         return geo.size.width * CGFloat(xRatio)
     }
     
     // Calculate the y-position for a selected point based on value
     private func yPosition(for dataPoint: ChartData, in geo: GeometryProxy) -> CGFloat {
         guard let data = service.data.last?.data else { return 0.0 }
         let maxValue = data.map(\.value).max() ?? 1
         let minValue = data.map(\.value).min() ?? 0
         let yRatio = (dataPoint.value - minValue) / (maxValue - minValue)
         return geo.size.height * (1 - CGFloat(yRatio))
     }

     // Update the selected data point based on drag location
     private func updateSelectedDataPoint(location: CGPoint, in geo: GeometryProxy) {
         // Calculate the closest x-position (time) based on drag location
         guard let data = service.data.last?.data else { return }
         guard let endTimeOfDay = data.last?.timeOfDay else { return }
         guard let startTimeOfDay = data.first?.timeOfDay else { return }
         
         let xRatio = location.x / geo.size.width
         let timeOffset = TimeInterval(xRatio) * endTimeOfDay.timeIntervalSince(startTimeOfDay)
         let closestTime = startTimeOfDay.addingTimeInterval(timeOffset)
                  
         let newSelectedDataPoint = data.min(by: {
             abs($0.timeOfDay.timeIntervalSince(closestTime)) < abs($1.timeOfDay.timeIntervalSince(closestTime))
         })
         
         if newSelectedDataPoint != selectedDataPoint {
             // Trigger haptic feedback when the selected data point changes
             hapticFeedback.impactOccurred()
             selectedDataPoint = newSelectedDataPoint
         }
         
     }
}


func isSameDay(_ timeInterval1: TimeInterval, _ timeInterval2: TimeInterval) -> Bool {
    let date1 = Date(timeIntervalSinceReferenceDate: timeInterval1)
    let date2 = Date(timeIntervalSinceReferenceDate: timeInterval2)
    return isSameDay(date1, date2)
}


func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
    let calendar = Calendar.current
    let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
    let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
    return components1.year == components2.year && components1.month == components2.month && components1.day == components2.day
}
