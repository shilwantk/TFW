//
//  BodyTemp.swift
//  zala
//
//  Created by Kyle Carriedo on 9/27/24.
//

import Foundation
import HealthKit

//MARK: Body Temperature
extension HealthKitManager {
    
    func fetchBodyTempAvgPerDay(startDate: Date = Calendar.current.startOfDay(for: Date.now),
                                endDate: Date = Date.now,
                                completion: @escaping ([Date: [Double]]?, Error?) -> Void) {
        fetchBodyTempatures { samples, error in
            completion(self.calculateAvgPerDay(samples ?? []), error)            
        }
    }
    
    func fetchBodyTempatures(startDate: Date = Calendar.current.startOfDay(for: Date.now),
                         endDate: Date = Date.now,
                         completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, NSError(domain: "com.yourapp.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available"]))
            return
        }
        
        let query = HKSampleQuery(sampleType: .quantityType(forIdentifier: .bodyTemperature)!,
                                  predicate: queryPredicated(startDate: startDate,
                                                             endDate: endDate),
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { (query, results, error) in
            if error != nil {
                return
            }
            
            guard let samples = results as? [HKQuantitySample], error == nil else {
                completion(nil, error)
                return
            }
            completion(samples, nil)
        }

        
        HealthKitManager.shared.healthStore.execute(query)
    }
    
    func calculateAvgPerDay(_ samples: [HKQuantitySample]) -> [Date: [Double]] {
        // Dictionary to store temperature samples per day
        var dailyTemperatures: [Date: [Double]] = [:]

        let calendar = Calendar.current
        for sample in samples {
            let temperature = sample.quantity.doubleValue(for: HKUnit.degreeCelsius())
            let sampleDate = sample.startDate

            // Get the start of the day for grouping
            let startOfDay = calendar.startOfDay(for: sampleDate)

            // Add temperature to the corresponding day
            if dailyTemperatures[startOfDay] != nil {
                dailyTemperatures[startOfDay]?.append(temperature)
            } else {
                dailyTemperatures[startOfDay] = [temperature]
            }
        }
        
        return dailyTemperatures
    }
}
