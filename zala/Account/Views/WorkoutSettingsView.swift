//
//  WorkoutSettingsView.swift
//  zala
//
//  Created by Kyle Carriedo on 12/8/24.
//

import SwiftUI
import ZalaAPI

struct WorkoutSettingsView: View {
    
    @Bindable var service: AccountService
    @State var squat: String = ""
    @State var bench: String = ""
    @State var deadlift: String = ""
    @State var isSaving: Bool = false
    
    @State var wakeUpDate: Date? = nil
    @State var bedtimeDate: Date? = nil
    
    var body: some View {
        VStack {
            ZStack(alignment:.top) {
                if isSaving {
                    LoadingBannerView(message: "Saving...")
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            ScrollView {
                Text("1 Rep Max (1RM)")
                    .style(size: .x18, weight: .w500)
                    .align(.leading)
                Text("Zala uses these values to calculate precise Rate of Perceived Exertion (RPE) estimates, ensuring every workout is tailored to your strength and goals.")
                    .style(color: Theme.shared.gray, size: .x13, weight: .w500)
                    .align(.leading)
                
                VStack {
                    KeyValueField(key: "Squat Max",
                                  value: $squat,
                                  placeholder: "Enter Squat Max")
                    
                    KeyValueField(key: "Bench Max",
                                  value: $bench,
                                  placeholder: "Enter Bench Max")
                    
                    KeyValueField(key: "Deadlift Max",
                                  value: $deadlift,
                                  placeholder: "Enter Deadlift Max")
                }
                
                Text("Sleep Schedule")
                    .style(size: .x18, weight: .w500)
                    .align(.leading)
                    .padding(.top)
                
                VStack {
                    OptionalDateDropDownView(
                        key: "Target Wake Time",
                        selectedDate: $wakeUpDate,
                        dateAndTime: .constant(false),
                        timeOnly: .constant(true),
                        darkMode: true,
                        isDob: false,
                        showKey: true)
                    OptionalDateDropDownView(
                        key: "Target Sleep Time",
                        selectedDate: $bedtimeDate,
                        dateAndTime: .constant(false),
                        timeOnly: .constant(true),
                        darkMode: true,
                        isDob: false,
                        showKey: true)
                }
            }
            Spacer()
            StandardButton(title: "Save", height: 44) {
                guard let userId = Network.shared.userId() else { return }
                self.isSaving = true
                service.addPreference(userId: userId,
                                      input: PreferenceInput(key: .squat, value: [squat])) { complete in
                    service.addPreference(userId: userId,
                                          input: PreferenceInput(key: .bench, value: [bench])) { complete in
                        service.addPreference(userId: userId,
                                              input: PreferenceInput(key: .deadlift, value: [deadlift])) { complete in
                            
                            if let wakeUpDate, let bedtimeDate {
                                service.addPreference(userId: userId,
                                                      input: PreferenceInput(key: .wakupTime, value: ["\(Int(wakeUpDate.timeIntervalSince1970))"])) { complete in
                                    
                                    service.addPreference(userId: userId,
                                                          input: PreferenceInput(key: .bedtime, value: ["\(Int(bedtimeDate.timeIntervalSince1970))"])) { complete in
                                        self.isSaving = false
                                    }
                                }
                            } else {
                                self.isSaving = false
                            }
                        }
                    }
                }
            }
            .frame(height: 44)
        }
        .padding()
        .navigationTitle("Workout Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            service.fetchPreferences(keys: [.squat,  .bench, .deadlift, .wakupTime, .bedtime]) { storedPreferences in
                for preference in storedPreferences {
                    switch preference.key {
                    case .squat: self.squat = preference.value?.last ?? ""
                    case .bench: self.bench = preference.value?.last ?? ""
                    case .deadlift: self.deadlift = preference.value?.last ?? ""
                    case .wakupTime:
                        let wakeUpEpoch = Int(preference.value?.last ?? "0") ?? 0
                        self.wakeUpDate = Date(timeIntervalSince1970: TimeInterval(wakeUpEpoch))
                    case .bedtime:
                        let bedtimeEpoch = Int(preference.value?.last ?? "0") ?? 0
                        self.bedtimeDate = Date(timeIntervalSince1970: TimeInterval(bedtimeEpoch))
                    case .none: break
                    case .some(_): break
                    }
                }
            }
        }
    }
}
