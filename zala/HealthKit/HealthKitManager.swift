//
//  HealthKitManager.swift
//  zala
//
//  Created by Kyle Carriedo on 4/5/24.
//

import Foundation
import Combine
import SwiftUI
import Apollo
import ZalaAPI
import KeychainSwift
import HealthKit

let emptyVital = (key: "_empty_", unit: "", title: "", values: [""])

public struct UserDefaultKeys {
    static let didAskPermission = "did_ask_permissions"
}

extension NSNotification {
    static let HealthSync = Notification.Name.init("HealthSync")
}

@Observable class HealthKitManager {
    
    var logManager = LogManager()
    
    enum HealthKitState {
        case authorized
        case notAuthorized
        case hasNotAsked
        case syncComplete
        case isSyncing
        case none
    }
    
    static let shared = HealthKitManager()
    
    var accessingHealthKit = false
    var syncingData = false
    var state: HealthKitState = .none
    let calendar = Calendar.autoupdatingCurrent
    
    let healthStore = HKHealthStore()
    var observerHash    = [String: HKObserverQuery]()
    private var counterHash    = [String: HKObserverQuery]()
    let keychain = KeychainSwift()
    
    var insights = Set([
        HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!,
        HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!
    ])
    
    var allTypes = Set([
        HKQuantityType.quantityType(forIdentifier: .heartRate)!,
        HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!,
        
        HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
        HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!,
        HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!,
        
        HKQuantityType.quantityType(forIdentifier: .height)!,
        HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
        HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!,
        HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)!,
        HKQuantityType.quantityType(forIdentifier: .waistCircumference)!,
//        HKCorrelationType.correlationType(forIdentifier: .bloodPressure)!,
        
        
        HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!,
        HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!,
        HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!,
        
        
        
        HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
        HKQuantityType.quantityType(forIdentifier: .numberOfTimesFallen)!,
        HKQuantityType.quantityType(forIdentifier: .distanceWheelchair)!,
        HKQuantityType.quantityType(forIdentifier: .stepCount)!,
        HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!,
        HKQuantityType.quantityType(forIdentifier: .vo2Max)!,
        
        
        
        HKQuantityType.quantityType(forIdentifier: .dietaryFatTotal)!,
        HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
        HKQuantityType.quantityType(forIdentifier: .dietarySugar)!,
        
        HKQuantityType.quantityType(forIdentifier: .dietaryProtein)!,
        HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
        HKQuantityType.quantityType(forIdentifier: .dietaryWater)!,
        HKQuantityType.quantityType(forIdentifier: .dietarySodium)!,
        HKQuantityType.quantityType(forIdentifier: .dietaryVitaminD)!,
        
        HKObjectType.workoutType(),
        
        HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!,
        HKSampleType.categoryType(forIdentifier: .mindfulSession)!,
    ])
    
    var isValid: Bool {
        guard HKHealthStore.isHealthDataAvailable() else {
            return false
        }
        return HealthKitManager.getHealthKitPermission()
    }
 
    static func syncHealthKitPermission(didAsk: Bool) {
        UserDefaults.standard.set(didAsk, forKey: UserDefaultKeys.didAskPermission)
    }
    
    static func getHealthKitPermission() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.didAskPermission)
    }
    
    func logout(handler: @escaping (Bool) -> Void) {
        //Stop all observer queries...
        for key in observerHash.keys {
            if let query = observerHash[key] {
                self.healthStore.stop(query)
            }
        }
        //reset the hash and stop all background processes...
        self.observerHash = [String: HKObserverQuery]()
        self.counterHash = [String: HKObserverQuery]()
        self.healthStore.disableAllBackgroundDelivery { (complete, error) in
            handler(true)
        }
        //not sure if we need to ask again?....
        HealthKitManager.syncHealthKitPermission(didAsk: false)
    }
        
    func requestInsightsAccess(handler: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
        healthStore.requestAuthorization(toShare: [], read: insights) { success, error in
            if success {
                print("HealthKit access granted")
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    
    static func canFetch(type: HKObjectType) -> Bool {
        let status = HealthKitManager.shared.healthStore.authorizationStatus(for: type)
        switch status {
          case .notDetermined:
            return false
          case .sharingDenied:
            return false
          case .sharingAuthorized:
            return true
          @unknown default:
            return false
          }
    }
    
    func authStatus() -> HKAuthorizationStatus {
        guard let type = allTypes.first else { return .notDetermined }
        return healthStore.authorizationStatus(for: type)
    }
    
    func authMessage() -> String {
        return HealthKitManager.getHealthKitPermission() ? "enabled" : "disabled"
    }
    
    func refetchHealthData() {
        state = .isSyncing
        syncingData = true
        self.sendNotificaiton(value: syncingData)
        if Array(counterHash.keys).isEmpty {
            self.counterHash = observerHash
        }
        for type in allTypes {
            self.runAppropriateQueries(sample: type, hkHandler: nil)
        }
    }
    
    func sendNotificaiton(value: Bool) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.HealthSync,
                                            object: nil,
                                            userInfo: ["info": value])
        }
    }
    
    func requestAuthorizationAgain(handler: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(toShare: nil, read: allTypes) { succes, error in
            HealthKitManager.syncHealthKitPermission(didAsk: succes)
            handler(true)
        }
    }
    
    
    func requestAccessIfNeeded(handler: @escaping (Bool) -> Void) {
        if !HealthKitManager.getHealthKitPermission() {
            healthStore.requestAuthorization(toShare: nil, read: allTypes) { succes, error in
                HealthKitManager.syncHealthKitPermission(didAsk: succes)
                handler(true)
            }
        } else {
            refetchHealthData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                handler(true)
            })
        }
    }
    
    func requestAccessToHealthKit() {
        if HealthKitManager.getHealthKitPermission() {
            self.setupObserverQueries()
        }
    }
    
    
    func setupObserverQueries() {
        for type in allTypes {
            self.setupObserverQuery(sample: type)
        }
    }
    
    fileprivate func setupObserverQuery(sample: Any) {
        guard let sampleType = sample as? HKSampleType else {
            return
        }
        let data = self.observerHash[sampleType.typeName]
        
        
        if data == nil  {
            let item = HKObserverQuery.init(sampleType: sampleType, predicate: nil, updateHandler: { (query, completionHandler, error) in
                if self.counterHash.keys.isEmpty {
                    self.counterHash = self.observerHash
                }
                
                self.handleBackgroundHealthQueryFetching(sample: sample, hkHandler: completionHandler)
            })
            
            self.healthStore.execute(item)
            self.observerHash[sampleType.typeName] = item
            self.counterHash[sampleType.typeName] = item
            enableBackgroundDelivery(sampleType: sampleType)
        }
    }
    
    fileprivate func enableBackgroundDelivery(sampleType: HKObjectType) -> Void {
        healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (success, error) in
        })
    }
    
    func handleBackgroundHealthQueryFetching(sample: Any, hkHandler: @escaping HKObserverQueryCompletionHandler) {
        //only send data if we have a valid token.
        //dont make the call to send data to the server if we have a bad token
        let tokenState = keychain.isValidToken()
        guard tokenState.isValid != false else {
            hkHandler()
            return
        }
        self.runAppropriateQueries(sample: sample, hkHandler: hkHandler)
    }
    
    func runAppropriateQueries(sample: Any, hkHandler: HKObserverQueryCompletionHandler?)  {
        guard  let sampleType = sample as? HKSampleType else {
            return
        }
        if sampleType.isCumlative() {
            // I dont think we want to get individual readings for cumlative types since there
            // is a potential for overlaping times and data (Steps is one example of overlaping with multiple sources.)
            guard let quantityType = sample as? HKQuantityType else {
                return
            }
            self.setupCumulativeQueries(sampleType: quantityType, typeName: sampleType.typeName, hkHandler: hkHandler)
        } else {
            self.setupDiscrete(sampleType: sampleType, hkHandler: hkHandler)
        }
    }
    
    func setupCumulativeQueries(sampleType: HKQuantityType, typeName:String, hkHandler: HKObserverQueryCompletionHandler?)  {
        
        let runningTotalData = self.retrieveRunningTotal(sampleType: sampleType)
        //dont make the call to send data to the server if we have a bad token
        let tokenState = keychain.isValidToken()
        guard tokenState.isValid != false else {
            self.executeHandler(typeName: typeName, hkHandler: hkHandler)
            return
        }
        
        let queryStartDate = self.startOfTheDay()
        let queryEndDate   = self.endOfTheDay()
        
        var interval    = DateComponents()
        interval.hour   = 1
        
        var dataArray   = [AnswerInput]()
        let predicate   = HKQuery.predicateForSamples(withStart: queryStartDate, end: queryEndDate, options: .strictStartDate)
        let query       = HKStatisticsCollectionQuery.init(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum, .separateBySource], anchorDate: queryStartDate, intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            guard let statsCollection = results else {
                self.executeHandler(typeName: typeName, hkHandler: hkHandler)
                return
            }
            
            var healthsnapTitle = ""
            var statisticsTotal: Double = 0
            
            statsCollection.enumerateStatistics(from: queryStartDate, to: queryEndDate) { statistics, stop in
                if let quantity = statistics.sumQuantity() {
                    let date    = statistics.startDate
                    let endDate = statistics.endDate
                    
                    let data  = self.valueFor(quantity: quantity, quantityType: sampleType)
                    healthsnapTitle = data.title
                                        
                    let value = data.values.last ?? "0"
                    statisticsTotal += Double(value) ?? 0
                    
                    //Bundles
                    let sourceName = statistics.sources?.last?.name ?? "Health App"
                    let identifier = statistics.sources?.last?.bundleIdentifier ?? "No ID"
                    let sources     = DataValueSourceInput(name: .some(sourceName.trimmingCharacters(in: .whitespacesAndNewlines)), identifier: .some(identifier))
                    let dataInput   = AnswerInput(
                        key:        data.key,
                        data:       .some(data.values),
                        unit:       .some(data.unit),
                        beginEpoch: .some(Int(date.timeIntervalSince1970)),
                        endEpoch:   .some(Int(endDate.timeIntervalSince1970) - 1),
                        source:     .some(sources))
                    dataArray.append(dataInput)
                }
            }
            
            //We dont want to send the same data multiple times this checks to see if the values have change at
            //This means if the user deletes, update or create new data into HealthKit.
            let existingRunningTotal = runningTotalData.runningTotal ?? 0
            if existingRunningTotal != statisticsTotal {
                self.saveRunningTotal(sampleType: sampleType, runningTotal: statisticsTotal)
                
                self.postVitals(title: healthsnapTitle, typeName: sampleType.typeName, vitals: dataArray,  hkHandler: hkHandler)
            } else {
                let runningTotalDate = Date(timeIntervalSince1970: runningTotalData.time)
                if Date().isGreaterThanOrEqualTo(runningTotalDate.nearestHour) {
                    self.saveRunningTotal(sampleType: sampleType, runningTotal: 0)
                }
                self.executeHandler(typeName: typeName, hkHandler: hkHandler)
            }
        }
        healthStore.execute(query)
    }
    
    
    func setupDiscrete(sampleType: HKSampleType, hkHandler: HKObserverQueryCompletionHandler?)  {
        let anchorDateQuery     = self.retrieveSavedAnchor(sampleType: sampleType)
        let predicate           = (anchorDateQuery == nil) ? HKQuery.predicateForSamples(withStart: self.startOfTheDay(), end: nil, options: .strictStartDate) : nil
        var dataArray           = [AnswerInput]()
        let anchoredObjectQuery = HKAnchoredObjectQuery.init(type: sampleType,  predicate: predicate, anchor: anchorDateQuery, limit: HKObjectQueryNoLimit , resultsHandler: { (anchoredObjectQuery, samples, deletedSamples, newAnchorQuery, error) in
            
            guard error == nil else {
                self.executeHandler(typeName: sampleType.typeName, hkHandler: hkHandler)
                return
            }
            
            //dont make the call to send data to the server if we have a bad token
            let tokenState = self.keychain.isValidToken()
            guard tokenState.isValid != false else {
                self.executeHandler(typeName: sampleType.typeName, hkHandler: hkHandler)
                return
            }
            
            if let newAnchor = newAnchorQuery {
                self.saveNewAnchor(sampleType: sampleType, newAnchor: newAnchor)
            }
            
            var healthsnapTitle = ""
            for (_, sample) in (samples?.enumerated())! {
                                
                let data    = self.valueFor(sample: sample)
                 healthsnapTitle = data.title
                let source  = sample.sourceRevision.source
                _ = source.name.replacingOccurrences(of: "’", with: "")

                let sourceInput = DataValueSourceInput(name: .some(source.name.trimmingCharacters(in: .whitespacesAndNewlines)),
                                                       identifier: nil) //The issues is if I switch watch I get new bundle ID server is not handling it correctly
                
                let dataInput = AnswerInput(key:        data.key,
                                            data:       .some(data.values),
                                            unit:       .some(data.unit),
                                            beginEpoch: .some(Int(sample.startDate.timeIntervalSince1970)),
                                            endEpoch:   .some(Int(sample.endDate.timeIntervalSince1970)),
                                            source:     .some(sourceInput))
                
                
                //this is adding extra data.
                if let workout = sample as? HKWorkout {
                    
                    if workout.workoutActivityType == .running || workout.workoutActivityType == .walking {
                        let duration = workout.duration.minBreakdown()
                        let key = workout.workoutActivityType == .running ? "activity.running_time" : "activity.walking_time"
                        let unit = "min"
                        
                        let sourceInput = DataValueSourceInput(name: .some(source.name.trimmingCharacters(in: .whitespacesAndNewlines)),
                                                               identifier: nil) //The issues is if I switch watch I get new bundle ID server is not handling it correctly
                        
                        let dataInput = AnswerInput(key:        key,
                                                    data:       .some([String(format:"%.2d", duration)]),
                                                    unit:       .some(unit),
                                                    beginEpoch: .some(Int(sample.startDate.timeIntervalSince1970)),
                                                    endEpoch:   .some(Int(sample.endDate.timeIntervalSince1970)),
                                                    source:     .some(sourceInput))
                        
                        dataArray.append(dataInput)
                    }
                    
                } else if sampleType.categoryTypeIdentifier == .sleepAnalysis {
                    if let categorySample = sample as? HKCategorySample {
                        _ = String((categorySample.value == 1) ? "Asleep" : "In Bed")
                    }
                } else if let meta = sample.metadata {
                    //NOTE check out meta sample.metadata tons of additional info might be good in note
                    _ = (meta.compactMap({ (key, value) -> String in
                        return "\(key) : \(value)"
                    }) as Array).joined(separator: "\n")
                }
                
                dataArray.append(dataInput)
            }
            self.postVitals(title: healthsnapTitle, typeName: sampleType.typeName, vitals: dataArray, hkHandler: hkHandler)
        })
        healthStore.execute(anchoredObjectQuery)
    }
    
    private func workoutMetaData(workout: HKWorkout) -> AnswerNoteInput {
        let totalDistance = workout.totalDistance
        let cal = workout.totalEnergyBurned
        let events = workout.workoutEvents?.compactMap({ (event) -> String? in
            let startTime = Date.dateStringFromDate(date: event.dateInterval.start, dateStyle:.none, timeStyle: .medium, isRelative: false)
            let endTime   = Date.dateStringFromDate(date: event.dateInterval.end, dateStyle:.none, timeStyle: .medium, isRelative: false)
            let duration  = event.dateInterval.duration.timeBreakdown()
            let formattedDuration = String(format: "%0.2d:%0.2d:%0.2d",duration.hours,duration.minutes,duration.seconds)
            var content = ""
            if let distance = totalDistance {
                content.append("\nTotal Distance: \(distance.doubleValue(for: HKUnit.foot()))")
            }
            if let totalCal = cal {
                content.append("\nTotal Calories Burned: \(totalCal.doubleValue(for: HKUnit.kilocalorie()))")
            }
            
            content.append("\n\(String(describing: event.type)) : \(startTime) - \(endTime) (\(formattedDuration))")
            return content
        }).joined(separator: "\n")
        
        var containerContent = ""
        
        if let distance = totalDistance {
            containerContent.append("\nWorkout Total Distance: \(distance.doubleValue(for: HKUnit.foot()))")
        }
        
        if let totalCal = cal {
            containerContent.append("\nWorkout Total Calories Burned: \(totalCal.doubleValue(for: HKUnit.kilocalorie()))")
        }
        
        if let allEvents = events {
            containerContent.append(allEvents)
        }
        return  AnswerNoteInput(body: .some(containerContent), author: .some(self.keychain.userID() ?? "-"), private: .some(false))
    }
    
    private func retrieveRunningTotal(sampleType: HKSampleType) -> (runningTotal:Double?, time: Double) {
        let typeName         = sampleType.typeName
        let runningTotalKey  = typeName + Constants.RUNNING_TOTAL
        return (UserDefaults.standard.double(forKey: runningTotalKey), UserDefaults.standard.double(forKey: Constants.RUNNING_TOTAL_TIME))
    }
    
    fileprivate func executeHandler(typeName:String, hkHandler: HKObserverQueryCompletionHandler?) {
        counterHash[typeName] = nil
        if hkHandler != nil {
            self.syncingData = !counterHash.keys.isEmpty
            if !self.syncingData {
                self.sendNotificaiton(value: self.syncingData)
            }
            hkHandler!()
        } else {
            self.syncingData = !counterHash.keys.isEmpty
            if !self.syncingData {
                self.sendNotificaiton(value: self.syncingData)
            }
        }
    }
    
    private func saveRunningTotal(sampleType: HKSampleType, runningTotal: Double) {
        let typeName         = sampleType.typeName
        let runningTotalKey  = typeName + Constants.RUNNING_TOTAL
        let runningTotalDateKey  = Constants.RUNNING_TOTAL_TIME
        let nowDate = Double(Date().timeIntervalSince1970)
        UserDefaults.standard.set(runningTotal, forKey: runningTotalKey)
        UserDefaults.standard.set(nowDate, forKey: runningTotalDateKey)
    }
    
    private func retrieveSavedAnchor(sampleType: HKSampleType) -> HKQueryAnchor? {
        let typeName   = sampleType.typeName
        let anchorKey  = typeName + Constants.ANCHOR_QUERY_NAME
        if let data    = UserDefaults.standard.object(forKey: anchorKey) as? Data {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data)
        } else {
            return nil
        }
    }
    
    private func saveNewAnchor(sampleType: HKSampleType, newAnchor: HKQueryAnchor) {
        let typeName   = sampleType.typeName
        let anchorKey  = typeName + Constants.ANCHOR_QUERY_NAME
        let anchorData = try? NSKeyedArchiver.archivedData(withRootObject: newAnchor, requiringSecureCoding: false)
        UserDefaults.standard.set(anchorData, forKey: anchorKey)
    }
    
    private func startOfTheDay() -> Date {
        let startOfDay   = Date().startOfDay
        var cal            = Date.autoupdatingCurrentCalendar
        cal.locale         = Locale.autoupdatingCurrent
        let components     = cal.dateComponents([.year, .month, .day, .hour], from: startOfDay)
        return cal.date(from: components)!
    }
    
    private func endOfTheDay() -> Date {
        let endOfDay     = Date().endOfDayByTime()
        var cal            = Date.autoupdatingCurrentCalendar
        cal.locale         = Locale.autoupdatingCurrent
        let endComponents  = cal.dateComponents([.year, .month, .day, .hour, .minute], from: endOfDay)
        return cal.date(from: endComponents)!
    }
    
    //MARK: - Newtwork
    private func postVitals(title: String, typeName: String, vitals: Array <AnswerInput>, hkHandler: HKObserverQueryCompletionHandler?) {
        if vitals.isEmpty {            self.executeHandler(typeName: typeName, hkHandler: hkHandler)
            return
        }
        
         if vitals.last?.isEmptyDataArray() ?? true {
            self.executeHandler(typeName: typeName, hkHandler: hkHandler)
            return
        }
        
        
        
        
        let beganDateEpoch = vitals.first?.beginEpoch.unwrapped ?? Int(Date().timeIntervalSince1970)
        let input =  UserAddDataInput(kind: .some(Constants.HEALTHKIT),
                                      name: .some(title),
                                      beginEpoch: .some(beganDateEpoch),
                                      data: .some(vitals))
        let mutation = CreateVitalMutation(input: .some(input))
        
        Network.shared.apollo.perform(mutation: mutation) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let graphQLResult):
                
                if let error = graphQLResult.data?.userAddData?.errors?.last?.fragments.errorModel {
                    
                    let vital = vitals.last ?? AnswerInput(.init())
                    let value = vital.data 
                    let key = vital.key 
                    let unit = vital.unit 
                    let msg = error.message ?? ""
                    logManager.addLog("\(title) \(typeName) \(key) \(unit) \(value) \(msg) \n.", kind: .healthkit)
                    logManager.addLog("Request Error:", kind: .request)
                    
                }
                
                self.executeHandler(typeName: typeName, hkHandler: hkHandler)
                
            case .failure(let error):
                let vital = vitals.last ?? AnswerInput(.init())
                let value = vital.data
                let key = vital.key
                let unit = vital.unit
                let msg = error.localizedDescription
                logManager.addLog("\(title) \(typeName) \(key) \(unit) \(value) \(msg).", kind: .healthkit)
                self.executeHandler(typeName: typeName, hkHandler: hkHandler)
            }
        }
    }
}


extension AnswerInput {
    func isEmptyDataArray() -> Bool {
        return self.key == "_empty_"
    }
}

extension HealthKitManager {
    //Used for descrete types
    func valueForWorkout(sample: HKSample) -> (key:String, unit: String, title: String, values: [String]) {
        if let workout = sample as? HKWorkout {
                        
            
            let workoutTitle = workout.localizedTitle()
            let duration = workout.duration.minBreakdown()
            let key = workout.workoutKey().key
            let unit = workout.workoutKey().unit
            return (key: key, unit: unit, title: workoutTitle, values:  [String(format:"%.2d", duration)])
            
        } else {
            return emptyVital
        }
    }
    
    func valueFor(sample: HKSample) -> (key:String, unit: String, title: String, values: [String]) {
        if let workout = sample as? HKWorkout {
            
            let workoutTitle = workout.localizedTitle()
            let duration = workout.duration.minBreakdown()
//            let distance = workout.totalDistance
            let key = workout.workoutKey().key
            let unit = workout.workoutKey().unit
            return (key: key, unit: unit, title: workoutTitle, values:  [String(format:"%.2d", duration)])
            
        }
        else if let type = sample as? HKCorrelation {
            let objects = Array(type.objects)
            
            if let item1 = objects.first as? HKQuantitySample,
               let item2 = objects.last as? HKQuantitySample {
                var dataValues: [String] = []
                if item1.quantityType.quantityTypeIdentifier == .bloodPressureSystolic {
                    dataValues.insert(String(item1.quantity.doubleValue(for: HKUnit.millimeterOfMercury())), at: 0)
                }
                if item1.quantityType.quantityTypeIdentifier == .bloodPressureDiastolic {
                    dataValues.append(String(item1.quantity.doubleValue(for: HKUnit.millimeterOfMercury())))
                }
                if item2.quantityType.quantityTypeIdentifier == .bloodPressureSystolic {
                    dataValues.insert(String(item2.quantity.doubleValue(for: HKUnit.millimeterOfMercury())), at: 0)
                }
                if item2.quantityType.quantityTypeIdentifier == .bloodPressureDiastolic {
                    dataValues.append(String(item2.quantity.doubleValue(for: HKUnit.millimeterOfMercury())))
                }
                return (key: "vital.blood_pressure", unit: "mmHg", title: "Blood Pressure", values: dataValues)
            } else {
                return emptyVital
            }
        }
        else if let quantitySample = sample as? HKQuantitySample {
            switch quantitySample.quantityType.quantityTypeIdentifier {
                
            case .heartRate:
                let unit = HKUnit.count().unitDivided(by: HKUnit.minute())
                return (key: HealthKitKeys.heartRate.key, unit: "bpm", title: HealthKitKeys.heartRate.title, values:  [String(quantitySample.quantity.doubleValue(for: unit))])
                
            case .heartRateVariabilitySDNN:                
                let unit = HKUnit.secondUnit(with: .milli)
                return (key: HealthKitKeys.heartRateVariability.key, unit: "ms", title: HealthKitKeys.heartRateVariability.title, values:  [String(quantitySample.quantity.doubleValue(for: unit))])
                
            case .restingHeartRate:
                let unit = HKUnit.count().unitDivided(by: HKUnit.minute())
                return (key: HealthKitKeys.restingHeartRate.key, unit: "bpm", title: HealthKitKeys.restingHeartRate.title, values:  [String(quantitySample.quantity.doubleValue(for: unit))])
                
            case .vo2Max:
                let unit = HKUnit.literUnit(with: .milli).unitDivided(by: .minute()).unitDivided(by: .gramUnit(with: .kilo))
                return (key: HealthKitKeys.vo2.key, unit: "ml/min/kg", title: HealthKitKeys.vo2.title, values:  [String(quantitySample.quantity.doubleValue(for: unit))])
                
                
            case .bloodGlucose:
                var hours = ""
                if let mealtime = sample.metadata?[HKMetadataKeyBloodGlucoseMealTime] as? Int {
                    //mealtime (1: Before Meal, 2: After Meal)
                    hours = (mealtime == 1) ? "8" : "0"
                } else {
                    //Unspecified
                    hours = "0"
                }
                return (key: HealthKitKeys.bloodGlucose.key, unit: "mg/dL", title: HealthKitKeys.bloodGlucose.title, values: [String(quantitySample.quantity.doubleValue(for: HKUnit(from: "mg/dL"))), hours])
                
            case .bodyTemperature:
                return (key: "vital.temperature",
                        unit: "F",
                        title: "Body Temperature",
                        values: [String(quantitySample.quantity.doubleValue(for: HKUnit.degreeFahrenheit()))])
                
            case .height:
                return (key: "body.height", unit: "in", title: "Height", values: [String(quantitySample.quantity.doubleValue(for: HKUnit.inch()))])
                
            case .bodyMass:
                return (key: "body.weight", unit: "lb", title: "Weight", values: [String(quantitySample.quantity.doubleValue(for: HKUnit.pound()))])
                
            case .oxygenSaturation:
                return (key: "vital.oxygen_saturation", unit: "percent", title: "Oxygen Saturation", values: [String(quantitySample.quantity.doubleValue(for: HKUnit.percent()))])
            
            case .respiratoryRate:
                return (key: "respiration.min_breaths_per_min", unit: "min", title: "Breaths per Minutes", values: [String(quantitySample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute())))])
                       
                
            case .bodyMassIndex:
                return (key: "body.bmi", unit: "bmi", title: "BMI", values: [String(quantitySample.quantity.doubleValue(for: HKUnit.count()))])
                
            case .bodyFatPercentage:
                return (key: "body.fat", unit: "percent", title: "Body Fat", values: [String(quantitySample.quantity.doubleValue(for: HKUnit.percent()))])
                
            case .waistCircumference:
                return (key: "body.circumference.waist", unit: "in", title: "Waist Circumference", values: [String(quantitySample.quantity.doubleValue(for: HKUnit.inch()))])
                
            default: return emptyVital
            }
            
        } else if let categorySample = sample as? HKCategorySample {
            
            switch categorySample.categoryType.categoryTypeIdentifier {
                
            case .sleepAnalysis:
                return (key: "rest.sleep", unit: "min", title: "Sleep", values: [String(Date.minutesBetweenDates(startDate: categorySample.startDate, endDate: categorySample.endDate))])
                
            case .mindfulSession:
                return (key: "rest.mindfulness", unit: "min", title: "Mindfulness", values: [String(Date.minutesBetweenDates(startDate: categorySample.startDate, endDate: categorySample.endDate))])
                
                
            default: return emptyVital
            }
            
        } else {
            
            return emptyVital
        }
    }
    
    
    
    //Used for cumlative types
    func valueFor(quantity: HKQuantity, quantityType: HKQuantityType) -> (key:String, unit: String, title: String, values: [String]) {
        switch quantityType.quantityTypeIdentifier {
        case .distanceWheelchair:     return (key: "activity.wheelchair_distance", unit: "mi", title: "", values: [String(quantity.doubleValue(for: HKUnit.mile()))])
        case .distanceCycling:        return (key: "activity.cycling", unit: "mi", title: "Cycling Distance", values: [String(quantity.doubleValue(for: HKUnit.mile()))])
        case .numberOfTimesFallen:    return (key: "activity.falls", unit: "count", title: "Number of Times Fallen", values: [String(quantity.doubleValue(for: HKUnit.count()))])
        case .stepCount:              return (key: "activity.steps", unit: "count", title: "Steps", values: [String(quantity.doubleValue(for: HKUnit.count()))])
        case .dietaryFatTotal:        return (key: "diet.fats",      unit: "g",     title: "Fat Total", values: [String(quantity.doubleValue(for: HKUnit.gram()))])
        case .dietarySugar:           return (key: "diet.sugar",     unit: "g",       title: "Sugar", values: [String(quantity.doubleValue(for: HKUnit.gram()))])
        case .dietaryProtein:         return (key: "diet.protein",   unit: "g",     title: "Protein", values: [String(quantity.doubleValue(for: HKUnit.gram()))])
        case .dietarySodium:          return (key: "diet.sodium",    unit: "g",       title: "Sodium", values: [String(quantity.doubleValue(for: HKUnit.gram()))])
        case .dietaryVitaminD:        return (key: "diet.vitamin_d", unit: "IU",      title: "Vitamin D", values: [String(quantity.doubleValue(for: HKUnit.gram()))])
        case .dietaryEnergyConsumed:  return (key: "diet.calories",  unit: "cal",     title: "Total Caloric Intake", values: [String(quantity.doubleValue(for: HKUnit.kilocalorie()))])
        case .activeEnergyBurned:     return (key: "calories.total_burned_calories",     unit: "cal", title: "Active Energy Burned", values: [String(quantity.doubleValue(for: HKUnit.kilocalorie()))])
        case .dietaryWater:           return (key: "diet.water",     unit: "oz", title: "Water", values: [String(quantity.doubleValue(for: HKUnit.fluidOunceUS()))])
        case .dietaryCarbohydrates:   return (key: "diet.carbohydrates", unit: "g", title: "Carbohydrates", values: [String(quantity.doubleValue(for: HKUnit.gram()))])
            
        case .distanceWalkingRunning: return (key: "activity.walking", unit: "mi", title: "Walking + Running Distance", values: [String(quantity.doubleValue(for: HKUnit.mile()))])
            
        default: return emptyVital
        }
    }
}


extension HKSampleType {
    var typeName:  String {
        return String(describing: self)
    }
    
    var quantityTypeIdentifier: HKQuantityTypeIdentifier {
        return HKQuantityTypeIdentifier(rawValue: self.identifier)
    }
    
    var categoryTypeIdentifier: HKCategoryTypeIdentifier {
        return HKCategoryTypeIdentifier(rawValue: self.identifier)
    }
    
    func isCumlative() -> Bool {
        let types: [HKQuantityTypeIdentifier] = [
            .distanceWalkingRunning,
            .distanceCycling,
            .distanceWheelchair,
            .numberOfTimesFallen,
            .stepCount,
            .dietaryFatTotal,
            .dietaryCarbohydrates,
            .dietarySugar,
            .dietaryProtein,
            .dietaryEnergyConsumed,
            .dietaryWater,
            .dietarySodium,
            .dietaryVitaminD]
        return types.contains(quantityTypeIdentifier)
    }
}



extension HKWorkout {

    
    func workoutKey() -> (key: String, unit: String) {
        switch workoutActivityType {
        case .pilates:  return (key:"activity.pilates",   unit: "min")
        case .barre:    return (key:"activity.barre",     unit: "min")
        case .yoga:     return (key:"activity.yoga",      unit: "min")
        case .rowing:   return (key:"activity.rowing",    unit: "mi")
        case .jumpRope: return (key:"activity.jump_rope", unit: "count")
        case .highIntensityIntervalTraining: return (key:"activity.hiit", unit: "min")
        case .cycling:   return (key:"activity.cycling",    unit: "mi")
        case .running:   return (key:"activity.running",    unit: "mi")
        case .walking:   return (key:"activity.walking",    unit: "mi")
        default: return (key:"activity.workout", unit: "min")
            
        }
    }
    func localizedTitle() -> String {
        switch workoutActivityType {
        case .americanFootball:        return "American Football"
        case .archery:                 return "Archery"
        case .australianFootball:      return "Australian Football"
        case .badminton:               return "Badminton"
        case .baseball:                return "Baseball"
        case .basketball:              return "Basketball"
        case .bowling:                 return "Bowling"
        case .boxing:                  return "Boxing"
        case .climbing:                return "Climbing"
        case .cricket:                 return "Cricket"
        case .crossTraining:           return "Cross Training"
        case .curling:                 return "Curling"
        case .cycling:                 return "Cycling"
        case .dance:                   return "Dance"
        case .elliptical:              return "Elliptical"
        case .equestrianSports:        return "Equestrian Sports"
        case .fencing:                 return "Fencing"
        case .fishing:                 return "Fishing"
        case .golf:                    return "Golf"
        case .gymnastics:              return "Gymnastics"
        case .handball:                return "Handball"
        case .hiking:                  return "Hiking"
        case .hockey:                  return "Hockey"
        case .hunting:                 return "Hunting"
        case .lacrosse:                return "Lacrosse"
        case .martialArts:             return "Martial Arts"
        case .mindAndBody:             return "Mind And Body"
        case .paddleSports:            return "Paddle Sports"
        case .play:                    return "Play"
        case .racquetball:             return "Racquetball"
        case .rowing:                  return "Rowing"
        case .rugby:                   return "Rugby"
        case .running:                 return "Running"
        case .sailing:                 return "Sailing"
        case .skatingSports:           return "Skating Sports"  // Ice Skating, Speed Skating, Inline Skating, Skateboarding, etc.
        case .snowSports:              return "Snow Sports" // Sledding, Snowmobiling, Building a Snowman, etc. See also HKWorkoutActivityTypeCrossCountrySkiing, HKWorkoutActivityTypeSnowboarding, and HKWorkoutActivityTypeDownhillSkiing.
        case .soccer:                  return "Soccer"
        case .softball:                return "Softball"
        case .squash:                  return "Squash"
        case .stairClimbing:           return "Stair Climbing" // See also HKWorkoutActivityTypeStairs and HKWorkoutActivityTypeStepTraining.
        case .surfingSports:           return "Surfing Sports" // Traditional Surfing, Kite Surfing, Wind Surfing, etc.
        case .swimming:                return "Swimming"
        case .tableTennis:             return "Table Tennis"
        case .tennis:                  return "Tennis"
        case .trackAndField:           return "Track And Field" // Shot Put, Javelin, Pole Vaulting, etc.
        case .volleyball:              return "Volleyball"
        case .walking:                 return "Walking"
        case .waterFitness:            return "Water Fitness"
        case .waterPolo:               return "Water Polo"
        case .waterSports:             return "Water Sports" // Water Skiing, Wake Boarding, etc.
        case .wrestling:               return "Walking"
        case .yoga:                    return "Yoga"
        case .barre:                   return "Barre" // HKWorkoutActivityTypeDanceInspiredTraining
        case .coreTraining:            return "Core Training"
        case .crossCountrySkiing:      return "Cross Country Skiing"
        case .downhillSkiing:          return "Downhill Skiing"
        case .flexibility:             return "Flexibility"
        case .jumpRope:                return "Jump Rope"
        case .kickboxing:              return "Kickboxing"
        case .pilates:                 return "Pilates"
        case .snowboarding:            return "Snowboarding"
        case .stairs:                  return "Stairs"
        case .stepTraining:            return "Step Training"
        case .wheelchairWalkPace:      return "Wheelchair Walk Pace"
        case .wheelchairRunPace:       return "Wheelchair Run Pace"
        case .taiChi:                  return "Tai Chi"
        case .mixedCardio:             return "Mixed Cardio"
        case .handCycling:             return "Hand Cycling"
        case .other:                   return "Other"
        case .traditionalStrengthTraining:   return "Traditional Strength Training" // Primarily machines and/or free weights
        case .highIntensityIntervalTraining: return "HIIT (High Intensity Interval Training)"
        case .functionalStrengthTraining:    return "Functional Strength Training"
        case .mixedMetabolicCardioTraining:  return "Mixed Metabolic Cardio Training"
        case .preparationAndRecovery:        return "Preparation And Recovery"
        default: return "Workout"
        }
    }
}

struct HealthKitKeys {
    static let heartRate = (key:"vital.heart_rate", title: "Heart Rate")
    static let restingHeartRate = (key:"vital.resting_heart_rate", title: "Resting Heart Rate")
    static let bloodGlucose = (key:"vital.blood_glucose", title: "Blood Glucose")
    static let heartRateVariability = (key:"vital.avg_hrv_rmssd", title: "Heart Rate Variability")
    static let vo2 = (key:"vital.vo2_samples", title: "VO2 Samples")
}


//MARK: - Query
extension HealthKitManager {
    
    func getStepCountsByHour(completion: @escaping ([Date: Double]?, Error?) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(nil, NSError(domain: "YourAppDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Step count type not available"]))
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: stepType,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: startOfDay,
                                                intervalComponents: DateComponents(hour: 1))
        
        query.initialResultsHandler = { query, results, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var stepCountsByHour = [Date: Double]()
            if let results = results {
                results.enumerateStatistics(from: startOfDay, to: now) { statistics, stop in
                    let count = statistics.sumQuantity()?.doubleValue(for: .count())
                    stepCountsByHour[statistics.startDate] = count ?? 0
                }
            }
            
            completion(stepCountsByHour, nil)
        }
        
        HealthKitManager.shared.healthStore.execute(query)
    }
    
    
    func fetchWorkouts(startDate: Date = Calendar.current.startOfDay(for: Date.now),
                       endDate: Date = Date.now,
                       completion: @escaping ([HKWorkout]?, Error?) -> Void) {
        // Check if HealthKit is available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, NSError(domain: "com.yourapp.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available"]))
            return
        }
        
        // Define the type of data you want to fetch (workouts)
        let workoutType = HKWorkoutType.workoutType()
        
        // Set up the start and end dates (from the start of the day until now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // Set up the sort descriptor to get the most recent workouts first
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Prepare the query
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(nil, error)
                return
            }
            completion(workouts, nil)
        }
        
        // Execute the query
        HealthKitManager.shared.healthStore.execute(query)
    }
}

extension HKWorkout {
    
    func formattedStartTitle() -> String {
        return Date.dateStringFromDate(date: self.startDate, dateStyle: .medium, timeStyle: .none, isRelative: true)
    }
    
    func workoutTimeRange() -> String {
        let startTime = Date.dateStringFromDate(date: startDate, dateStyle: .none, timeStyle: .medium, isRelative: false)
        let endTime = Date.dateStringFromDate(date: endDate, dateStyle: .none, timeStyle: .medium, isRelative: false)
        return "\(startTime) - \(endTime)"
    }
    
    func insightLabel() -> String {
        return "\(formattedStartTitle()), \(workoutTimeRange())"
    }
}

//MARK: - Helpers
extension HealthKitManager {
    func daysAgo(_ numberOfDays: Int) -> Date? {
        let calendar = Calendar.current
        let now = Date()
        return calendar.date(byAdding: .day, value: numberOfDays * -1, to: now)
    }
    
    func queryPredicated(startDate: Date, endDate: Date) -> NSPredicate {
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    }
}
