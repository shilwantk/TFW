//
//  InsightsService.swift
//  zala
//
//  Created by Kyle Carriedo on 4/14/24.
//

import Foundation
import SwiftUI
import ZalaAPI
import HealthKit

let defaultResult: Result<(today: Double, difference: Double), Error> = .success((today: 0.0, difference: 0.0))

@Observable class InsightsService {
    
    var primaryInsight: InsightsConfigation? = nil
    var insightSelections: [InsightsConfigation] = []
    
    var zalaInsights: [ZalaInsight] = []
    var selectedInsight: ZalaInsight? = nil
    var allInsights: [InsightsConfigation] = []
    
    func buildEmptyInsights(for currentDate: Date) {
        self.insight(key: .hrv, currentDate: currentDate, result: defaultResult)
        self.insight(key: .sleep, currentDate: currentDate, result: defaultResult)
        self.insight(key: .activeEnergy, currentDate: currentDate, result: defaultResult)
        self.insight(key: .rhr, currentDate: currentDate, result: defaultResult)
    }
    
    func buildInsights(for currentDate: Date) {
        let manager = HealthKitManager.shared
        if manager.isValid {
            manager.requestInsightsAccess { complete in
                print(complete)
                manager.compareTodayVsYesterdaysData(for: currentDate, key: .hrv) { hrvResult in
                    
                    self.insight(key: .hrv, currentDate: currentDate, result: hrvResult)
                    
                    manager.compareTodayVsYesterdaysData(for: currentDate, key: .sleep) { sleepResult in
                        
                        self.insight(key: .sleep, currentDate: currentDate, result: sleepResult)
                        
                        manager.compareTodayVsYesterdaysData(for: currentDate, key: .activeEnergy) { activeEnergyResult in
                            
                            self.insight(key: .activeEnergy, currentDate: currentDate, result: activeEnergyResult)
                            
                            manager.compareTodayVsYesterdaysData(for: currentDate, key: .rhr) { rhrResult in
                                
                                self.insight(key: .rhr, currentDate: currentDate, result: rhrResult)
                                
                            }
                            
                        }
                    }
                }
            }
        } else {
            buildEmptyInsights(for: currentDate)
        }
    }
    
    //MARK: - Helpers
    fileprivate func insight(key: InsightsKey,
                             currentDate: Date,
                             result: Result<(today:Double, difference: Double), Error>) {
        let displayData = key.displayData()
        
        switch result {
        case .success(let data):
            let todays = String(format: "%.2f", data.today)
            
            let isElevated = data.difference > 0
            let data = isElevated ? data.difference : data.difference * -1
            let value = String(format: "%.2f", data)
            
            let msg = "\(isElevated ? "Up" : "Down") \(value) \(displayData.unit) from previous day"
            
            let insight = ZalaInsight(key: key,
                               reading: "\(todays) \(displayData.unit)",
                               msg: msg,
                               title: displayData.title,
                               timestamp: currentDate,
                               elevated: isElevated)
            self.insert(insight: insight)
        case .failure(_):
            insert(insight: ZalaInsight.noChange(key: key, title: displayData.title))
        }
    }
    
    func clear() {
        zalaInsights = []
    }
    
    fileprivate func insert(insight: ZalaInsight) {
        if zalaInsights.isEmpty {
            self.zalaInsights.append(insight)
            self.convert(insight)
        } else {
            self.zalaInsights.append(insight)
        }
    }
    
    func convert(_ insight: ZalaInsight) {
        let insightConfig = InsightsConfigation(isPrimary: true,
                                                insight: insight)
        selectedInsight = insight
        primaryInsight = insightConfig
        insightSelections = []
        insightSelections = [insightConfig]
    }
}



extension InsightsService {
    static func fetchAndStoreInsights(date: Date, handler: @escaping (_ complete: Bool) -> Void) {
        let manager = HealthKitManager.shared
        var dataInput: [AnswerInput] = []
        manager.compareTodayVsYesterdaysData(for: date, key: .hrv) { hrvResult in
            let result = try? hrvResult.get().today
            
            let answer = AnswerInput(key: HealthKitKeys.heartRateVariability.key,
                                     data: .some([String(result ?? 0.0)]),
                                     unit: .some("ms"),
                                     beginEpoch: .some(Int(Date.now.timeIntervalSince1970)),
                                     endEpoch: .some(Int(Date.now.timeIntervalSince1970) + 2),
                                     source: .some(.init(name:.some(Constants.HEALTHKIT))))
            
            dataInput.append(answer)
                        
            manager.compareTodayVsYesterdaysData(for: date, key: .sleep) { sleepResult in
                let result = try? sleepResult.get().today
                
                dataInput.append(.init(key: "rest.sleep",
                                       data: .some([String(result ?? 0.0)]),
                                       unit: .some("min"),
                                       beginEpoch: .some(Int(Date.now.timeIntervalSince1970)),
                                       endEpoch: .some(Int(Date.now.timeIntervalSince1970)),
                                       source: .some(.init(name:.some(Constants.HEALTHKIT)))))
                                
                
                manager.compareTodayVsYesterdaysData(for: date, key: .activeEnergy) { activeEnergyResult in
                    let result = try? activeEnergyResult.get().today
                    
                    dataInput.append(.init(key: "calories.total_burned_calories",
                                           data: .some([String(result ?? 0.0)]),
                                           unit: .some("cal"),
                                           beginEpoch: .some(Int(Date.now.timeIntervalSince1970)),
                                           endEpoch: .some(Int(Date.now.timeIntervalSince1970)),
                                           source: .some(.init(name:.some(Constants.HEALTHKIT)))
                                          ))
                    
                    
                    let beganDateEpoch = Int(Date().timeIntervalSince1970)
                    let input =  UserAddDataInput(kind: .some(Constants.HEALTHKIT),
                                                  name: .some("vizualizer vitals"),
                                                  beginEpoch: .some(beganDateEpoch),
                                                  data: .some(dataInput))
                    
                    
                    Network.shared.apollo.perform(mutation: CreateVitalMutation(input: .some(input))) { result in
                        switch result {
                        case .success(_):
                            handler(true)
                            
                        case .failure(_):
                            handler(true)
                        }
                    }
                }
            }
        }
    }
}
