//
//  HeartRateVariability.swift
//  zala
//
//  Created by Kyle Carriedo on 10/20/24.
//

import Foundation
import HealthKit

extension HealthKitManager {
    
    func fetchTodayAverageHRV(completion: @escaping (Result<Double, Error>) -> Void) {
        let healthStore = HKHealthStore()
        
        // Define the type for HRV (Heart Rate Variability)
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(.failure(NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "HRV type is not available"])))
            return
        }
        
        // Get the start of today
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        // Create a predicate for today
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        // Create the statistics query for average HRV
        let query = HKStatisticsQuery(quantityType: hrvType,
                                      quantitySamplePredicate: predicate,
                                      options: .discreteAverage) { (query, result, error) in
            
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Get the average HRV for today
            if let result = result, let average = result.averageQuantity() {
                // HRV is measured in milliseconds
                let averageHRV = average.doubleValue(for: HKUnit.secondUnit(with: .milli))
                completion(.success(averageHRV))
            } else {
                completion(.success(0.0)) // No data
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }

    func fetchAverageRestingHeartRateForDay(
        date: Date,
        completion: @escaping (Result<Double?, Error>) -> Void
    ) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(NSError(domain: "HealthKitUnavailable", code: 1, userInfo: nil)))
            return
        }
        
        let healthStore = HealthKitManager.shared.healthStore
       
        guard let restingHeartRateType = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else {
            completion(.failure(NSError(domain: "InvalidDataType", code: 2, userInfo: nil)))
            return
        }
                        
//        guard HealthKitManager.canFetch(type: restingHeartRateType) else {
//            completion(.failure(NSError(domain: "InvalidDataType", code: 2, userInfo: nil)))
//            return
//        }
        
        // Get start and end of the day
        let calendar = Calendar.current
        guard let startOfDay = calendar.startOfDay(for: date) as Date? else {
            completion(.failure(NSError(domain: "DateConversionError", code: 3, userInfo: nil)))
            return
        }
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: endOfDay,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: restingHeartRateType,
            quantitySamplePredicate: predicate,
            options: .discreteAverage
        ) { _, statistics, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let averageQuantity = statistics?.averageQuantity() {
                let averageBPM = averageQuantity.doubleValue(for: .count().unitDivided(by: .minute()))
                completion(.success(averageBPM))
            } else {
                completion(.success(nil)) // No data available for the day
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchAverageHRV(date: Date, completion: @escaping (_ avg: Double, _ error:Error?) -> Void) {
        
        let healthStore = HealthKitManager.shared.healthStore
        
        // Define the type for HRV (Heart Rate Variability)
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(0.0, NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "HRV type is not available"]))
            return
        }        
                        
//        guard HealthKitManager.canFetch(type: hrvType) else {
//            completion(0.0, NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "HRV type is not available"]))
//            return
//        }
        
        let startOfDay = calendar.startOfDay(for: date)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: date.endOfDayByTime(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: hrvType,
                                      quantitySamplePredicate: predicate,
                                      options: .discreteAverage) { (query, result, error) in
            
            // Check for errors
            if let error = error {
                completion(0.0, error)
                return
            }
            
            // Get the average HRV for today
            if let result = result, let average = result.averageQuantity() {
                // HRV is measured in milliseconds
                let averageHRV = average.doubleValue(for: HKUnit.secondUnit(with: .milli))
                completion(averageHRV, nil)
            } else {
                completion(0.0, nil) // No data
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    func fetchWeeklyAverageHRV(for startDate: Date, endDate: Date, completion: @escaping (Result<Double, Error>) -> Void) {
        let healthStore = HKHealthStore()
        
        // Define the type for HRV (Heart Rate Variability)
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(.failure(NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "HRV type is not available"])))
            return
        }
        
        // Get the start and end of the current week
        
        // Create a predicate for the current week
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // Create the statistics query for average HRV
        let query = HKStatisticsQuery(quantityType: hrvType,
                                      quantitySamplePredicate: predicate,
                                      options: .discreteAverage) { (query, result, error) in
            
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Get the average HRV for the current week
            if let result = result, let average = result.averageQuantity() {
                // HRV is measured in milliseconds
                let averageHRV = average.doubleValue(for: HKUnit.secondUnit(with: .milli))
                completion(.success(averageHRV))
            } else {
                completion(.success(0.0)) // No data
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    func fetchAverageHRV(startDate: Date, endDate: Date, completion: @escaping (Result<[Date: Double], Error>) -> Void) {
        let healthStore = HKHealthStore()
        
        // Define the type for HRV
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(.failure(NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "HRV type is not available"])))
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: hrvType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = results as? [HKQuantitySample] else {
                completion(.success([:])) // No results
                return
            }
            
            var dailyHRV: [Date: (totalHRV: Double, count: Int)] = [:]
            
            let calendar = Calendar.autoupdatingCurrent
            for sample in results {
                let hrvValue = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                let date = calendar.startOfDay(for: sample.startDate)
                
                if let existing = dailyHRV[date] {
                    dailyHRV[date] = (totalHRV: existing.totalHRV + hrvValue, count: existing.count + 1)
                } else {
                    dailyHRV[date] = (totalHRV: hrvValue, count: 1)
                }
            }
            
            var averageHRV: [Date: Double] = [:]
            for (date, value) in dailyHRV {
                averageHRV[date] = value.totalHRV / Double(value.count)
            }
            
            completion(.success(averageHRV))
        }
        
        healthStore.execute(query)
    }
    
    func fetchAverageRestingHeartRate(
        startDate: Date,
        endDate: Date,
        completion: @escaping (Result<[Date: Double], Error>) -> Void
    ) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(NSError(domain: "HealthKitUnavailable", code: 1, userInfo: nil)))
            return
        }
        
        let healthStore = HKHealthStore()
        guard let restingHeartRateType = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else {
            completion(.failure(NSError(domain: "InvalidDataType", code: 2, userInfo: nil)))
            return
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )
        
        let query = HKStatisticsCollectionQuery(
            quantityType: restingHeartRateType,
            quantitySamplePredicate: predicate,
            options: .discreteAverage,
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1)
        )
        
        query.initialResultsHandler = { _, results, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var averagesByDate: [Date: Double] = [:]
            results?.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                if let averageQuantity = statistics.averageQuantity() {
                    let averageBPM = averageQuantity.doubleValue(for: .count().unitDivided(by: .minute()))
                    averagesByDate[statistics.startDate] = averageBPM
                }
            }
            
            completion(.success(averagesByDate))
        }
        
        healthStore.execute(query)
    }
}


