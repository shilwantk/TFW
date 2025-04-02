//
//  ActiveEnergy.swift
//  zala
//
//  Created by Kyle Carriedo on 10/20/24.
//

import Foundation
import HealthKit

//MARK: Body Temperature
extension HealthKitManager {
    
    func fetchTodayActiveEnergy(completion: @escaping (Double?) -> Void) {
        let healthStore = HKHealthStore()
        
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil)
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: activeEnergyType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { (query, result, error) in
            
            // Check for errors
            if error != nil {
                completion(nil)
                return
            }
            
            // Get the total active energy burned today
            if let result = result, let sum = result.sumQuantity() {
                // Total active energy burned in kilocalories
                let activeEnergyBurned = sum.doubleValue(for: HKUnit.kilocalorie())
                completion(activeEnergyBurned)
            } else {
                completion(0.0) // No data
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    func fetchActiveEnergy(date: Date, completion: @escaping (Double?) -> Void) {
        
        let healthStore = HealthKitManager.shared.healthStore
        
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil)
            return
        }
        
//        guard !HealthKitManager.canFetch(type: activeEnergyType) else {
//            completion(nil)
//            return
//        }
        
        let calendar = Calendar.current
         let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }

        
        // Define the predicate and statistics query
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: activeEnergyType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { (query, result, error) in
            
            // Check for errors
            if error != nil {
                completion(nil)
                return
            }
            
            // Get the total active energy burned today
            if let result = result, let sum = result.sumQuantity() {
                // Total active energy burned in kilocalories
                let activeEnergyBurned = sum.doubleValue(for: HKUnit.kilocalorie())
                completion(activeEnergyBurned)
            } else {
                completion(0.0) // No data
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    // Function to calculate the average active energy for a given date range
    func fetchAverageActiveEnergyBreakdown(startDate: Date,
                                             endDate: Date,
                                             useAvg: Bool,
                                             completion: @escaping (Result<[Date: Double], Error>) -> Void) {
        let healthStore = HKHealthStore()
        
        // Define the type for Active Energy Burned
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(.failure(NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Active Energy type is not available"])))
            return
        }
        
        // Create a predicate for the date range
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(
                quantityType: activeEnergyType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: startDate,
                intervalComponents: DateComponents(day: 1)
            )
            
            query.initialResultsHandler = { _, results, error in
                guard let statsCollection = results else {
                    completion(.failure(error ?? NSError(domain: "HealthKit", code: 1, userInfo: nil)))
                    return
                }
                
                // Dictionary to hold each day's energy, with date as the key
                var dailyEnergies: [Date: Double] = [:]
                
                statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    let date = statistics.startDate
                    let energy = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                    dailyEnergies[date] = energy
                }
                
                completion(.success(dailyEnergies))
            }       
        
        healthStore.execute(query)
    }
    
    func fetchAverageActiveEnergy(startDate: Date, 
                                  endDate: Date,
                                  completion: @escaping (Result<[Date: Double], Error>) -> Void) {
        let healthStore = HKHealthStore()
        
        // Define the type for Active Energy Burned
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(.failure(NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Active Energy type is not available"])))
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: activeEnergyType, 
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { (query, results, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = results as? [HKQuantitySample] else {
                completion(.success([:])) // No results
                return
            }
            
            // Dictionary to hold total active energy for each day
            var dailyActiveEnergy: [Date: Double] = [:]
            
            // Iterate through results and accumulate totals
            let calendar = Calendar.autoupdatingCurrent
            for sample in results {
                let energyValue = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
                let date = calendar.startOfDay(for: sample.startDate)
                
                if let existingTotal = dailyActiveEnergy[date] {
                    dailyActiveEnergy[date] = existingTotal + energyValue
                } else {
                    dailyActiveEnergy[date] = energyValue
                }
            }
            
            completion(.success(dailyActiveEnergy))
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    
    // Function to calculate the average active energy for a given date range
    func fetchAverageActiveEnergyCurrentWeek(startDate: Date, 
                                             endDate: Date,
                                             useAvg: Bool,
                                             completion: @escaping (Result<Double, Error>) -> Void) {
        let healthStore = HKHealthStore()
        
        // Define the type for Active Energy Burned
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(.failure(NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Active Energy type is not available"])))
            return
        }
        
        // Create a predicate for the date range
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // Set up the query to fetch samples
        let query = HKSampleQuery(sampleType: activeEnergyType, 
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { (query, results, error) in
            
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Process the results
            guard let results = results as? [HKQuantitySample] else {
                completion(.success(0.0)) // No results
                return
            }
            
            // Sum active energy and count days
            var totalEnergy = 0.0
            let calendar = Calendar.current
            var uniqueDays: Set<Date> = []
            
            for sample in results {
                let energyValue = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
                totalEnergy += energyValue
                let date = calendar.startOfDay(for: sample.startDate)
                uniqueDays.insert(date)
            }
            
            // Calculate the average if there are valid days
            let averageEnergy = uniqueDays.count > 0 ? totalEnergy / Double(uniqueDays.count) : 0.0
            
            if useAvg {
                completion(.success(averageEnergy))
            } else {
                completion(.success(totalEnergy))
            }
            
        }
        
        // Execute the query
        healthStore.execute(query)
    }

    // Helper function to get the start and end dates for a given week
    func getStartAndEndOfWeek(for date: Date) -> (startOfWeek: Date, endOfWeek: Date)? {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start else { return nil }
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else { return nil }
        return (startOfWeek, endOfWeek)
    }

    // Function to compare the current week's average energy with the previous week's
    func compareCurrentWeekVsPreviousWeekEnergy(for date: Date, 
                                                key: InsightsKey,
                                                completion: @escaping (Result<(today: Double, avg:Double), Error>) -> Void) {
        let calendar = Calendar.current
        
        // Get current week and previous week date ranges
        guard let (currentWeekStart, currentWeekEnd) = getStartAndEndOfWeek(for: date),
              let previousWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeekStart),
              let previousWeekEnd = calendar.date(byAdding: .day, value: 6, to: previousWeekStart) else {
            completion(.failure(NSError(domain: "Date", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not calculate date range"])))
            return
        }
        
        // Fetch average energy for current and previous weeks
        if key == .hrv {
            self.fetchWeeklyAverageHRV(for: currentWeekStart, endDate: currentWeekEnd) { result in
                switch result {
                case .success(let currentWeekAvg):
                    self.fetchWeeklyAverageHRV(for: previousWeekStart, endDate: previousWeekEnd) { resultPreviousWeek in
                        switch resultPreviousWeek {
                        case .success(let previousWeekAvg):
                            // Calculate the difference
                            let difference = currentWeekAvg - previousWeekAvg
                            completion(.success((currentWeekAvg, difference)))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        else if key == .activeEnergy {
            fetchTodayActiveEnergy { todaysData in
                self.fetchAverageActiveEnergyCurrentWeek(startDate: currentWeekStart, endDate: currentWeekEnd, useAvg: false) { resultCurrentWeek in
                    switch resultCurrentWeek {
                    case .success(let currentWeekAvg):
                        self.fetchAverageActiveEnergyCurrentWeek(startDate: previousWeekStart, endDate: previousWeekEnd, useAvg: false) { resultPreviousWeek in
                            switch resultPreviousWeek {
                            case .success(let previousWeekAvg):
                                // Calculate the difference
                                let difference = currentWeekAvg - previousWeekAvg
                                completion(.success((currentWeekAvg, difference)))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        else if key == .sleep {
            fetchAverageSleep(startDate: currentWeekStart, endDate: currentWeekEnd) { result in
                switch result {
                case .success(let currentWeekAvg):
                    self.fetchAverageSleep(startDate: previousWeekStart, endDate: previousWeekEnd) { resultPreviousWeek in
                        switch resultPreviousWeek {
                        case .success(let previousWeekAvg):
                            // Calculate the difference
                            let difference = currentWeekAvg - previousWeekAvg
                            completion(.success((currentWeekAvg, difference)))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}


//MARK: - Today vs Yesterday
extension HealthKitManager {
    func compareTodayVsYesterdaysData(for date: Date,
                                       key: InsightsKey,
                                       completion: @escaping (Result<(today: Double, difference:Double), Error>) -> Void) {
        let currentDate = date
        let dayBefore = date.dayBefore
        if key == .activeEnergy {
            self.fetchActiveEnergy(date: currentDate) { avg in
                let todayAvg = avg ?? 0.0
                self.fetchActiveEnergy(date: dayBefore) { yesterDaysSum in
                    let difference = todayAvg - (yesterDaysSum ?? 0.0)
                    completion(.success((todayAvg, difference)))
                }
            }
        } else if key == .sleep {
            
            // Get current week and previous week date ranges
            guard let (currentWeekStart, currentWeekEnd) = getStartAndEndOfWeek(for: date) else {
                completion(.failure(NSError(domain: "Date", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not calculate date range"])))
                return
            }
            
            getSleepByHour(start: currentWeekStart, end: currentWeekEnd) { days, error in
                let currentDay = date
                let datebefore = date.dayBefore
                var todayAvg: Double = 0.0
                var dayBeforeAvg: Double = 0.0
                for day in days ?? [:] {
                    if day.key.isSameDay(as: currentDay) {
                        todayAvg = day.value
                    } else if day.key.isSameDay(as: datebefore) {
                        dayBeforeAvg = day.value
                    }
                }
                
                let difference = todayAvg - dayBeforeAvg
                completion(.success((todayAvg, difference)))
            }
        } else if key == .hrv {
            fetchAverageHRV(date: currentDate) { avg, error in
                self.fetchAverageHRV(date: dayBefore) { dayBeforeAvg, error in
                    let difference = avg - dayBeforeAvg
                    completion(.success((avg, difference)))
                }
            }
        } else if key == .rhr {
            fetchAverageRestingHeartRateForDay(date: currentDate) { result in
                switch result {
                case .success(let success):
                    let avg = success ?? 0.0
                    self.fetchAverageRestingHeartRateForDay(date: dayBefore) { resultDayBefore in
                        switch resultDayBefore {
                        case .success(let success):
                            let difference = avg - (success ?? 0.0)
                            completion(.success((avg, difference)))
                        case .failure(_):
                            completion(.success((0, 0)))
                        }
                    }                    
                case .failure(_):
                    completion(.success((0, 0)))
                }
            }
        }
    }
}
