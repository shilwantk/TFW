//
//  GraphService.swift
//  zala
//
//  Created by Kyle Carriedo on 9/27/24.
//

import Foundation
import Observation
import HealthKit
import SwiftUI

enum GraphType {
    case hr, day
}

enum GraphTime: Int, CaseIterable {
    case lastSeven = 7
    case today = 1
    
    func title() -> String {
        switch self {
        case .lastSeven: "7 Days"
        case .today: "24hr"
        }
    }
}

@Observable class GraphService {
    
    var insightWorkoutSelections: [InsightsConfigation] = []
    var insightSelections: [InsightsConfigation] = []
    var data: [GraphData] = []
    var chartXScale:  ClosedRange<Date> = Date().startOfDay...Date()
        
    var scale: CGFloat = 1.0
    var previousScale: CGFloat = 1.0
    var selectedDate: Date? = nil
    var graphType: GraphType = .hr
    var targetColor: Color = Theme.shared.blue
    var isScrollable: Bool = false
    var graphTime: GraphTime = .lastSeven
    
    func clear() {
        data.removeAll()
    }
    
    func timeIntervalToHourString(_ timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        return dateFormatter.string(from: date)
    }
        
    fileprivate func buildBodyTemp(_ type: String) {
        HealthKitManager.shared.fetchBodyTempAvgPerDay { bodyTempAvg, error in
            if error != nil {
                return
            }
            var bodyTempData: [ChartData] = []
            for temp in bodyTempAvg ?? [:] {
                bodyTempData.append(ChartData(value: temp.value.last ?? 0.0, timeOfDay: temp.key))
            }
            let time = bodyTempData.sorted(by: {$0.timeOfDay < $1.timeOfDay})
            
            if let startOfDay = time.first?.timeOfDay {
                self.chartXScale = startOfDay...Date.now
            }
            
            self.data.append(GraphData(type: type, data: time, key: "body temp"))
        }
    }
    
    fileprivate func buildStepCount(type: String) {
        HealthKitManager.shared.getStepCountsByHour { stepsByHour, error in
            if error != nil {
                return
            }
            var stepsData: [ChartData] = []
            for step in stepsByHour ?? [:] {
                stepsData.append(ChartData(value: step.value, timeOfDay: step.key))
            }
            let time = stepsData.sorted(by: {$0.timeOfDay < $1.timeOfDay})
            
            if let startOfDay = time.first?.timeOfDay {
                self.chartXScale = startOfDay...Date.now
            }
            
            self.data.append(GraphData(type: type, data: time, key: "steps"))
        }
    }
    
    func buildRestingHeartRate(start: Date, end: Date, isPrimary: Bool) {
        chartXScale = start...end
        let type: String = isPrimary ? .primary : .secondary
        
        var modifyEndDate = end
        if end.isInFuture {
            modifyEndDate = Date().endOfDayByTime()
        }
        HealthKitManager.shared.fetchAverageRestingHeartRate(startDate: start, endDate: modifyEndDate) { result in
            switch result {
            case .success(let averageRHR):
                var graphData: [ChartData] = []
                for (date, avg) in averageRHR {
                    if avg > 0 {
                        graphData.append(.init(value: avg, timeOfDay: date))
                    }
                }
                let results = graphData.sorted(by: {$0.timeOfDay < $1.timeOfDay})
                self.data.append(.init(type: type, data: results))
            case .failure(_):
                break
            }
        }
    }
    
    func buildActiveEnergy(start: Date, end: Date, isPrimary: Bool) {
        chartXScale = start...end
        let type: String = isPrimary ? .primary : .secondary
        
        var modifyEndDate = end
        if end.isInFuture {
            modifyEndDate = Date().endOfDayByTime()
        }
        
        HealthKitManager.shared.fetchAverageActiveEnergyBreakdown(startDate: start, endDate: modifyEndDate, useAvg: true) { result in
            switch result {
            case .success(let averageHRV):
                var graphData: [ChartData] = []
                for (date, avg) in averageHRV {
                    if avg > 0 {
                        graphData.append(.init(value: avg, timeOfDay: date))
                    }
                }
                let results = graphData.sorted(by: {$0.timeOfDay < $1.timeOfDay})
                self.data.append(.init(type: type, data: results))

            case .failure(_):break
            }
        }
    }
    
    func buildAvgHRV(start: Date, end: Date, isPrimary: Bool) {
        chartXScale = start...end
        let type: String = isPrimary ? .primary : .secondary
        HealthKitManager.shared.fetchAverageHRV(startDate: start, endDate: end) { result in
            switch result {
            case .success(let averageHRV):
                var graphData: [ChartData] = []
                for (date, avg) in averageHRV {
                    graphData.append(.init(value: avg, timeOfDay: date))
                }
                let results = graphData.sorted(by: {$0.timeOfDay < $1.timeOfDay})
                self.data.append(.init(type: type, data: results))

            case .failure(_): break
            }
        }
    }
    
    func buildSleep(start: Date, end: Date, isPrimary: Bool) {
        chartXScale = start...end
        let type: String = isPrimary ? .primary : .secondary
        
        HealthKitManager.shared.getSleepByHour(start: start, end: end) { sleepByHour, error in
            if error != nil {
                return
            }
            var sleepData: [ChartData] = []
            for step in sleepByHour ?? [:] {
                sleepData.append(ChartData(value: step.value, timeOfDay: step.key))
            }
            
            let time = sleepData.sorted(by: {$0.timeOfDay < $1.timeOfDay})
            
            self.data.append(GraphData(type: type, data: time, key: "sleep"))
        }
    }
    
    fileprivate func buildHeartRates(type: String) {
        let days = graphTime == .today ? 1 : 7
        HealthKitManager.shared.averageHeartRatePerDayForLast(days: days) { json, error in
            if error != nil {
                return
            }
            
            if let json {
                let keys = Array(json.keys)
                var hrData: [ChartData] = []
                for key in keys {
                    if let value = json[key] {
                        hrData.append(ChartData(value: value, timeOfDay: key))
                    }
                }
                let results = hrData.sorted(by: {$0.timeOfDay < $1.timeOfDay})
                self.data.append(GraphData(type: type, data: results))
            }
        }
    }
    
    fileprivate func demobuildHeartRates(type: String) {
        HealthKitManager.shared.fetchHeartRates { heartRateSamples, error in
            if error != nil {
                return
            }
            
            var hrData: [ChartData] = []
            if let samples = heartRateSamples, !samples.isEmpty {
                for sample in samples {
                    let value = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                    hrData.append(ChartData(value: value, timeOfDay: sample.startDate))
                }
                let time = hrData.sorted(by: {$0.timeOfDay < $1.timeOfDay})
                if let startOfDay = time.first?.timeOfDay {
                    self.chartXScale = startOfDay...Date.now
                }
                self.data.append(GraphData(type: type, data: time))
                
            }
        }
    }
}
