//
//  Sleep.swift
//  zala
//
//  Created by Kyle Carriedo on 9/25/24.
//

import Foundation
import HealthKit

//MARK: Sleep
extension HealthKitManager {
    
    func fetchSleepSamples(startDate: Date, endDate: Date, completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let query = HKSampleQuery(sampleType: sleepType,
                                  predicate: queryPredicated(startDate: startDate, endDate: endDate),
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [
                                    NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                                  ]) { (query, results, error) in
                                      if let error = error {
                                          completion(nil, error)
                                          return
                                      }
                                      
                                      if let sleepData = results as? [HKCategorySample] {
                                          completion(sleepData, nil)
                                      } else {
                                          completion(nil, nil)
                                      }
                                  }
        
        healthStore.execute(query)
    }
    
    func calculateAverageSleep(_ samples: [HKCategorySample], totalDays: Int) -> Double {
        let asleepSamples = samples.filter { $0.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue }
        
        var totalSleepDuration: TimeInterval = 0 // Sum of all sleep durations
        
        for sample in asleepSamples {
            let sleepDuration = sample.endDate.timeIntervalSince(sample.startDate)
            totalSleepDuration += sleepDuration
        }
        
        return totalSleepDuration / Double(totalDays) / 3600.0
    }
    
    func fetchTodaysSleepAvg(date: Date, completion: @escaping (Double?, Error?) -> Void) {
        guard let startDate = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: date) else { return }
        let endOfDay = date.endOfDayByTime()
        fetchSleepSamples(startDate: startDate, endDate: endOfDay) { samples, error in
            guard let sleepData = samples, error == nil else {
                completion(nil, error)
                return
            }
            // Return sleep duration for each day
            self.calculateSleepBy(sleepData) { results, error in
                if let results, let total = Array(results.values).last {
                    completion(total, nil)
                } else {
                    let avgSleep = self.calculateAverageSleep(sleepData, totalDays: 1)
                    completion(avgSleep, nil)
                }
            }
        }
    }
    
    func fetchTodaysSleepAvg(completion: @escaping (Double?, Error?) -> Void) {
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? . now //sleep starts yesterday or change this to have more avgs.
        let endOfDay = Date().endOfDayByTime()
        fetchSleepSamples(startDate: startDate, endDate: endOfDay) { samples, error in
            guard let samples = samples, error == nil else {
                completion(nil, error)
                return
            }
            
            let avgSleep = self.calculateAverageSleep(samples, totalDays: 1)
            completion(avgSleep, nil)
        }
    }
    
    
    func fetchAverageSleep(startDate: Date, endDate: Date, completion: @escaping (Result<Double, Error>) -> Void) {
        let healthStore = HKHealthStore()
        
        
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(.failure(NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sleep type is not available"])))
            return
        }
                
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            
            guard let results = results as? [HKCategorySample] else {
                completion(.success(0.0)) // No results
                return
            }            
            
            let averageSleep = self.calculateSleepAverage(results)
            
            completion(.success(averageSleep))
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    func fetchSleepAvg( _ days:Int, completion: @escaping (Double?, Error?) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sleep Analysis Type is unavailable"]))
            return
        }
        
        let query = HKSampleQuery(sampleType: sleepType,
                                  predicate: queryPredicated(startDate: daysAgo(days) ?? .now, endDate: .now),
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { (query, result, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let samples = result as? [HKCategorySample] else {
                completion(nil, NSError(domain: "HealthKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to cast samples to HKCategorySample"]))
                return
            }
            
            completion(self.calculateSleepAverage(samples), nil)
        }
        
        HealthKitManager.shared.healthStore.execute(query)
    }
    
    func getSleepByHour(start: Date, end: Date, completion: @escaping ([Date: Double]?, Error?) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil, nil)
            return
        }
        
        let healthStore = HealthKitManager.shared.healthStore
                        
//        guard HealthKitManager.canFetch(type: sleepType) else {
//            completion(nil, nil)
//            return
//        }
        
        let query = HKSampleQuery(sampleType: sleepType,
                                  predicate: queryPredicated(startDate: start,
                                                             endDate: end),
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [
                                    NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
                                  ]) { (query, results, error) in
                                      
                                      if let error = error {
                                          completion(nil, error)
                                          return
                                      }
                                      
                                      guard let sleepData = results as? [HKCategorySample] else {
                                          completion(nil, error)
                                          return
                                      }
                                      
                                      // Return sleep duration for each day
                                      self.calculateSleepBy(sleepData) { results, error in
                                          completion(results, nil)
                                      }
                                  }
        
        healthStore.execute(query)
    }
    
    fileprivate func calculateSleepBy(
        time: Calendar.Component = .day,
        typeOfSleep: HKCategoryValueSleepAnalysis = .awake,
        _ samples: [HKCategorySample],
        completion: @escaping ([Date: Double]?, Error?) -> Void) {
            // Dictionary to store total sleep duration per hour
            var dailySleepDuration: [Date: TimeInterval] = [:]
            let cal = Calendar.autoupdatingCurrent
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.autoupdatingCurrent
            dateFormatter.dateStyle = .medium
            
            // Define the cutoff time for sleep day (e.g., 7 PM)
            let sleepDayCutoffHour = 19 // 7 PM
            
            
            
            for sample in samples {
                guard sample.value != HKCategoryValueSleepAnalysis.awake.rawValue else { continue } //samples can be broken into different phases of sleep
                guard sample.value != HKCategoryValueSleepAnalysis.inBed.rawValue else { continue } //samples can be broken into different phases of sleep
                //                guard sample.sourceRevision.source.name.lowercased() == "whoop" else { continue } //only scope to one source
                
//                var typeOfSleepString = "none"
//                if sample.value == HKCategoryValueSleepAnalysis.awake.rawValue {
//                    typeOfSleepString = "awake"
//                }
//                else if sample.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue {
//                    typeOfSleepString = "rem"
//                }
//                else if sample.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue {
//                    typeOfSleepString = "core"
//                }
//                else if sample.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue {
//                    typeOfSleepString = "deep"
//                }
//                else if sample.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue {
//                    typeOfSleepString = "asleepUnspecified"
//                }
//                else if sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue {
//                    typeOfSleepString = "inBed"
//                }
//                else {
//                    typeOfSleepString = "\(sample.value)"
//                }
                
                
                
                let sleepStartDate = sample.startDate
                var effectiveDate: Date
                
                var sleepDuration = sample.endDate.timeIntervalSince(sample.startDate)
                sleepDuration = (sleepDuration / 3600)
                
                // Check if the sleep starts after the cutoff hour
                if cal.component(.hour, from: sleepStartDate) >= sleepDayCutoffHour {
                    // If it starts after the cutoff, it belongs to the next day
                    effectiveDate = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: sleepStartDate))!
                } else {
                    // If it starts before the cutoff, it belongs to the current day
                    effectiveDate = cal.startOfDay(for: sleepStartDate)
                }
                
                // Add sleep duration to the total for the effective date
                dailySleepDuration[effectiveDate, default: 0] += sleepDuration
                
                
            }
            completion(dailySleepDuration, nil)
        }
    fileprivate func textTotal(dailySleepDuration: [Date: TimeInterval],
                               completion: @escaping ([Date: Double]?, Error?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.dateStyle = .medium
        completion(nil, nil)
    }
    
    fileprivate func calculateSleepAverage(_ samples: [HKCategorySample]) -> Double {
        var totalSleepTime: TimeInterval = 0
        var sleepDaysCounted: Set<Date> = []
        
        for sample in samples {
            if sample.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue {
                let sleepTime = sample.endDate.timeIntervalSince(sample.startDate)
                totalSleepTime += sleepTime
                
                // Consider sleep only if it's on a new day
                let day = Calendar.current.startOfDay(for: sample.startDate)
                sleepDaysCounted.insert(day)
            }
        }
        
        let averageSleepTime = totalSleepTime / Double(sleepDaysCounted.count)
        return averageSleepTime / 3600
    }
}
