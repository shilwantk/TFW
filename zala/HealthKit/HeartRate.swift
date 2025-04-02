//
//  HeartRate.swift
//  zala
//
//  Created by Kyle Carriedo on 9/27/24.
//

import Foundation
import HealthKit

//MARK: Heart Rate
extension HealthKitManager {
    
    func calculateAverageHeartRate(samples: [HKQuantitySample]) -> Double {
        let totalHeartRate = samples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) }
        return totalHeartRate / Double(samples.count)
    }
    
    func fetchHeartRateAverage(_ days: Int, completion: @escaping (Double?, Error?) -> Void) {
        guard let pastDate = daysAgo(days) else {
            completion(nil, NSError(domain: "com.yourapp.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to calculate two weeks ago date."]))
            return
        }
        
        fetchHeartRateSamples(startDate: pastDate, endDate: .now) { (samples, error) in
            guard let samples = samples, error == nil else {
                completion(nil, error)
                return
            }
            
            if samples.isEmpty {
                completion(0, nil)
            } else {
                let averageHeartRate = self.calculateAverageHeartRate(samples: samples)
                completion(averageHeartRate, nil)
            }
        }
    }
    
    func averageHeartRatePerDayForLast(days: Int, completion: @escaping ([Date: Double]?, Error?) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        guard let pastDate = daysAgo(days) else {
            completion(nil, NSError(domain: "com.yourapp.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to calculate two weeks ago date."]))
            return
        }
        
        let dailyPredicate = queryPredicated(startDate: pastDate, endDate: .now)
        
        // Define a daily interval
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        // Set up statistics collection query
        let query = HKStatisticsCollectionQuery(
            quantityType: heartRateType,
            quantitySamplePredicate: dailyPredicate,
            options: .discreteAverage,
            anchorDate: pastDate,
            intervalComponents: dateComponents
        )
        
        query.initialResultsHandler = { _, results, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var dailyAverages: [Date: Double] = [:]
            
            // Iterate over the statistics for each day
            results?.enumerateStatistics(from: pastDate, to: .now) { statistics, _ in
                if let averageQuantity = statistics.averageQuantity() {
                    let averageHeartRate = averageQuantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                    dailyAverages[statistics.startDate] = averageHeartRate
                }
            }
            
            completion(dailyAverages, nil)
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodaysHeartRateAverage(completion: @escaping (Double?, Error?) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        
        fetchHeartRateSamples(startDate: startOfToday, endDate: now) { (samples, error) in
            guard let samples = samples, error == nil else {
                completion(nil, error)
                return
            }
            
            let averageHeartRate = self.calculateAverageHeartRate(samples: samples)
            completion(averageHeartRate, nil)
        }
    }
    
    func fetchHeartRateSamples(startDate: Date, endDate: Date, completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        let query = HKSampleQuery(sampleType: heartRateType,
                                  predicate: queryPredicated(startDate: startDate, endDate: endDate),
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample], error == nil else {
                completion(nil, error)
                return
            }
            completion(samples, nil)
        }
        
        HealthKitManager.shared.healthStore.execute(query)
    }
    
    
    func fetchRestingHeartRates(startDate: Date = Calendar.current.startOfDay(for: Date.now),
                                endDate: Date = Date.now,
                                completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        // Check if HealthKit is available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, NSError(domain: "com.yourapp.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available"]))
            return
        }
        
        // Prepare the query
        let query = HKSampleQuery(sampleType: .quantityType(forIdentifier: .restingHeartRate)!,
                                  predicate: queryPredicated(startDate: startDate, endDate: endDate),
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { (query, results, error) in
            guard let samples = results as? [HKQuantitySample], error == nil else {
                completion(nil, error)
                return
            }
            completion(samples, nil)
        }
        
        // Execute the query
        HealthKitManager.shared.healthStore.execute(query)
    }
    
    func fetchHeartRates(startDate: Date = Calendar.current.startOfDay(for: Date.now),
                         endDate: Date = Date.now,
                         completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, NSError(domain: "com.yourapp.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available"]))
            return
        }
        
        let query = HKSampleQuery(sampleType: .quantityType(forIdentifier: .heartRate)!,
                                  predicate: queryPredicated(startDate: startDate,
                                                             endDate: endDate),
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { (query, results, error) in
            guard let samples = results as? [HKQuantitySample], error == nil else {
                completion(nil, error)
                return
            }
            completion(samples, nil)
        }
        
        HealthKitManager.shared.healthStore.execute(query)
    }
}
