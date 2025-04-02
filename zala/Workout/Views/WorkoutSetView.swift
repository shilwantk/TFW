//
//  WorkoutSetView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI
import Observation
import ZalaAPI

enum WorkoutStatus: String {
    case pending = "pending"
    case active = "active"
    case completed = "completed"
    case cancelled = "cancelled"
}

enum WorkoutActionType: String {
    case activate = "activate"
    case deactivate = "deactivate"
    case archive = "archive"
    case cancel = "cancel"
}

@Observable class WorkoutManager {
    //Plans
    var workoutPlan: WorkoutPlanModel? = nil
    var workoutPlans: [WorkoutPlanModel] = []
    
    //groups
    var currentGroup: WorkoutPlanGroupModel? = nil
    var workoutGroups: [WorkoutPlanGroupModel] = []
    
    //Workouts
    var currentWorkout: WorkoutPlanGroupActivityModel? = nil
    var workouts: [WorkoutPlanGroupActivityModel] = []
    
    //sets
    var sets: [WorkoutSetModel] = []
    var currentSet: WorkoutSetModel? = nil    
    
    var storedValues:[String] = []
    var idx: Int = 0
    var grpIdx: Int = 0
    
    var setIdx: Int = 0
    var workoutIdx: Int = 0
    
    
    
    var completed: Bool = false
    var endWorkout: Bool = false
    
    var workout: WorkoutRoutineModel? = nil
    
    var answers: [String: AnswerInput] = [:]
    
    var logManager = LogManager()
    
    var squatMax: Double?
    var benchMax: Double?
    var deadliftMax: Double?
    
    var timeOfDay: TimeOfDay? = nil
    
    init() {}
    
    func store(key: String, answer: AnswerInput) {
        answers[key] = answer
    }
    
    func update(with plan: WorkoutPlanModel, timeOfDay: TimeOfDay) {
        self.timeOfDay = timeOfDay
        
        self.workoutPlans = []
        self.workoutPlan = plan
        
        //groups
        self.workoutGroups = (self.workoutPlan?.groups?.compactMap({$0.fragments.workoutPlanGroupModel}) ?? [])
        self.currentGroup = self.workoutGroups.first
        
        //workouts
        self.workouts = (currentGroup?.activityLinks?.compactMap({$0.fragments.workoutPlanGroupActivityModel}) ?? [])
        
        self.currentWorkout = workouts.first
        
        //sets
        self.sets = self.currentWorkout?.allSets ?? []
        self.currentSet = self.sets.first
        resetStates()
        fetch1RPMMaxes()
    }
    
    init(plan: WorkoutPlanModel) {
        
        self.workoutPlans = []
        self.workoutPlan = plan
        
        //groups
        self.workoutGroups = (self.workoutPlan?.groups?.compactMap({$0.fragments.workoutPlanGroupModel}) ?? [])
        
        self.currentGroup = self.workoutGroups.first
        
        //workouts
        self.workouts = currentGroup?.activityLinks?.compactMap({$0.fragments.workoutPlanGroupActivityModel}) ?? []
        self.currentWorkout = workouts.first
        
        //sets
        self.sets = self.currentWorkout?.allSets ?? []
        self.currentSet = self.sets.first
        resetStates()
        fetch1RPMMaxes()
    }
    
    init(workout: WorkoutRoutineModel) {
        self.workout = workout
        
        //plans
        self.workoutPlans = workout.plans?.nodes?.compactMap({$0?.fragments.workoutPlanModel}) ?? []
        self.workoutPlan = self.workoutPlans.last
        
        //groups
        self.workoutGroups = (self.workoutPlan?.groups?.compactMap({$0.fragments.workoutPlanGroupModel}) ?? [])
        
        self.currentGroup = self.workoutGroups.first
        
        //workouts
        self.workouts = currentGroup?.activityLinks?.compactMap({$0.fragments.workoutPlanGroupActivityModel}) ?? []
        self.currentWorkout = workouts.first
        
        //sets
        self.sets = self.currentWorkout?.allSets ?? []
        self.currentSet = self.sets.first
        resetStates()
        fetch1RPMMaxes()
        
    }
    
//    func start(_ workout: [ExerciseGroup]) {
//        exerciseGroups = workout
//        currentGroup = workout.first
//        workouts = currentGroup?.workouts ?? []
//    }
    
//    func start(_ workout: [ExerciseGroup]) {
//        exerciseGroups = workout
//        currentGroup = workout.first
//        workouts = currentGroup?.workouts ?? []
//    }
    
    func run() {
        resetStates()
        currentWorkout = workouts[workoutIdx]
        currentSet = currentWorkout?.allSets[setIdx]
    }
    
    func resetStates() {
        idx = 0
        grpIdx = 0
        workoutIdx = 0
        setIdx = 0
        completed = false
        endWorkout = false
    }
    
    func resetSetCount() {
        setIdx = 0
    }
    
    func next() {
        setIdx += 1
        if sets.count > setIdx {
            currentSet = sets[setIdx]
        } else {
            //reset set count
            resetSetCount()
            
            //do we have another exercise ?
            if workouts.count > workoutIdx + 1 {
                workoutIdx += 1
                currentWorkout = workouts[workoutIdx]
                sets = currentWorkout?.allSets ?? []
                currentSet = sets[setIdx]
            } else {
                
                //do we have another group
                if workoutGroups.count > grpIdx + 1 {
                    
                    resetSetCount()
                    workoutIdx = 0
                    
                    grpIdx += 1
                    currentGroup = workoutGroups[grpIdx]
                    workouts = currentGroup?.allActvityLinks ?? []
                    currentWorkout = workouts[idx]
                    
                    sets = currentWorkout?.allSets ?? []
                    currentSet = sets[setIdx]
                } else {
                    completed = true
                    idx = 0
                    grpIdx = 0
                    workoutIdx = 0
                    setIdx = 0
                    currentWorkout = nil
                    workouts = []
                    workoutGroups = []
                    currentSet = nil
                    sets = []
                }
                
            }
        }
    }
    
    func back() {
        setIdx -= 1
        if setIdx < 0 {
            //first exercise in group
            grpIdx -= 1
            if grpIdx == 0 {
                //first group
                currentGroup = workoutGroups[grpIdx]
                workouts = currentGroup?.allActvityLinks ?? []
                currentWorkout = workouts[idx]
                sets = currentWorkout?.allSets ?? []
                setIdx = sets.count - 1
                currentSet = sets[setIdx]
                
            } else if grpIdx < 0 {
//                completed = true
            } else {
                currentGroup = workoutGroups[grpIdx]
                workouts = currentGroup?.allActvityLinks ?? []
                currentWorkout = workouts[idx]
                sets = currentWorkout?.allSets ?? []
                setIdx = sets.count - 1
                currentSet = sets[setIdx]
            }
        } else {
            currentSet = sets[setIdx]
        }
    }
    
    func atStart() -> Bool {
        return idx <= 0
    }
    
    func atEnd() -> Bool {
        return idx >= workouts.endIndex
    }
    
    func atStartOfGroups() -> Bool {
        return grpIdx <= 0 && idx <= 0
    }
    
    func atEndOfGroups() -> Bool {
        return grpIdx >= workoutGroups.endIndex
    }
    
    func clcualteWorkoutTime() -> Date? {
        switch timeOfDay {
        case .morning:
            return Date().createDate(hour: 10)
        case .afternoon:
            return Date().createDate(hour: 15)
        case .night:
            return Date().createDate(hour: 18)
        case .anytime:
            return Date().createDate(hour: 1)
        case .none:
            return Date().createDate(hour: 1)
        }
    }
    
    
    //MARK: - API
    func endPlan() {
        
    }
    
    func save(handler: @escaping (_ complete: Bool) -> Void) {
        var inputs = Array(answers.values)
        guard inputs.isEmpty == false else { return }
        guard let planId = workoutPlan?.id else { return }
        guard let title = workoutPlan?.title else { return }
        let beganDateEpoch = clcualteWorkoutTime() ?? .now
        let key = "\(Constants.WORKOUT)_\(planId)"
        
        
        //store the datavalue
        let sourceInput = DataValueSourceInput(name: .some("zala workout"), identifier: nil)
        let dataInput = AnswerInput(key:        key,
                                    data:       .some(["completed"]),
                                    unit:       .some("count"),
                                    beginEpoch: .some(Int(beganDateEpoch.timeIntervalSince1970)),
                                    endEpoch:   .some(Int(Date.now.timeIntervalSince1970)),
                                    source:     .some(sourceInput))
        
        inputs.append(dataInput)
        
        //store all values
        let input =  UserAddDataInput(kind: .some(key),
                                      name: .some(title),
                                      beginEpoch: .some(Int(beganDateEpoch.timeIntervalSince1970)),
                                      data: .some(inputs))
        
        
        Network.shared.apollo.perform(mutation: CreateVitalMutation(input: .some(input))) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let graphQLResult):
                
                if let error = graphQLResult.data?.userAddData?.errors?.last?.fragments.errorModel {
                    logManager.addLog("\(title) was not saved. \(error.message ?? "")", kind: .basic)
                    handler(false)
                } else {
                    handler(true)
                }
                
            case .failure(let error):
                logManager.addLog("\(title) was not saved.\(error.localizedDescription)", kind: .basic)
                handler(false)
            }
        }
    }
    
    func fetch1RPMMaxes() {
        guard let userId = Network.shared.userId() else { return  }
        Network.shared.apollo.fetch(query: FetchPreferenceQuery(id: .some(userId))) { response in
            switch response {
            case .success(let result):
                let models = result.data?.user?.preferences?.compactMap({$0.fragments.preferenceModel})
                for model in models ?? [] {
                    if model.key == .squat {
                        self.squatMax = Double(model.value?.last ?? "0.0")
                    }
                    if model.key == .bench {
                        self.benchMax = Double(model.value?.last ?? "0.0")
                    }
                    if model.key == .deadlift {
                        self.deadliftMax = Double(model.value?.last ?? "0.0")
                    }
                }
                
            case .failure(_):
                break
            }
        }
    }
}


struct WorkoutSetView: View {
//    let exerciseGroup: ExerciseGroup
//    let exerciseGroup: WorkoutPlanModel
    let exerciseGroup: WorkoutPlanGroupModel
    @Binding var expandedAll: Bool
    @State private var expanded: Bool = true
    @State private var activityLinks: [WorkoutPlanGroupActivityModel] = []
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    Text(exerciseGroup.title ?? "-")
                        .style(size: .x18, weight: .w800)
                    Spacer()
                    Image.downArrow
                        .rotationEffect(.degrees(expanded ? 0 : 180))
                }
                .padding()
            }
            .frame(height: 50)
            .background(Theme.shared.darkText)
            .cornerRadius(8, corners: expanded ? [.topLeft, .topRight] : .allCorners)
            .onTapGesture {
                withAnimation {
                    expanded.toggle()
                }
            }
            .onChange(of: expandedAll) { oldValue, newValue in
                withAnimation {
                    expanded = newValue
                }
            }
            .onAppear {
                self.activityLinks = (exerciseGroup.activityLinks?.compactMap({$0.fragments.workoutPlanGroupActivityModel}) ?? [])
            }
            if expanded {
                VStack {
                    VStack {
                        ForEach(activityLinks, id:\.self) { workout in
                            ForEach(workout.allSets, id:\.self) { set in
                                WorkoutCellView(icon:.workout,
                                                title: workout.formattedTitle,
                                                middleLine: set.middleLine,
                                                bottomLine: set.bottomLine)
                                if set.hasRest {
                                    TintButton(icon: .stopwatch,
                                               title: "REST: \(set.rest ?? "0")",
                                               color: Theme.shared.lightBlue,
                                               minHeight: 40,
                                               centerAlign: false) {
                                        
                                    }
                                }
                            }
                        }
                    }.padding()
                }
                .background(Theme.shared.mediumBlack)
                .cornerRadius(8, corners: expanded ? [.bottomLeft, .bottomRight] : .allCorners)
            }
        }
    }
}


extension WorkoutPlanGroupActivityModel {
    
    var allSets: [WorkoutSetModel] {
        return sets?.compactMap({$0.fragments.workoutSetModel}) ?? []
    }
    
    var restCount: Int {        
        let restSets = sets?.filter({$0.rest?.isEmpty == false}) ?? []
        return restSets.count
    }
    
    var hasRest: Bool {
        return sets?.contains(where: {$0.rest?.isEmpty == false}) ?? false
    }
    
    var isMain: Bool {
        return starred ?? false
    }
    
    var formattedTitle: String {
        return isMain ? "\(activity?.name ?? "") (Main)" : activity?.name ?? ""
    }
}

extension WorkoutPlanGroupModel {
    
    var allActvityLinks: [WorkoutPlanGroupActivityModel] {
        return activityLinks?.compactMap({$0.fragments.workoutPlanGroupActivityModel}) ?? []
    }
}

extension WorkoutPlanModel: @retroactive Identifiable {
    
    var allGroups: [WorkoutPlanGroupModel] {
        (self.groups?.compactMap(\.fragments.workoutPlanGroupModel) ?? [])
    }
}

extension WorkoutSetModel: @retroactive Identifiable {
    
    var middleLine: String {
        switch kind {
        case .time: return  "Active Time: \(self.time ?? "0 seconds")"
        case .rpe: return "Reps: \(self.reps ?? 0) - RPE: \(self.rpe ?? 0)"
        case .distance: return "Distance: \(distance ?? "0")"
        case .weight:
            if weight == nil {
                return "Reps: Bodyweight"
            } else if let weight, weight == "0 lbs" {
                return "Reps: Bodyweight"
            } else if let weight, weight.isEmpty {
                return "Reps: Bodyweight"
            } else if let weight, let reps {
                return "Reps: \(reps) x \(weight)"
            } else {
                return "Reps: \(self.reps ?? 0)"
            }
            
        case .none: return  ""
        }
    }
    
    var bottomLine: String {
        switch kind {
        case .time: "Weight: 0lbs (Bodyweight)"
        case .rpe: "Weight: \(self.weight ?? "0 lbs")"
        case .distance: "Weight: 0lbs (Bodyweight)"
        case .weight:
            if weight == nil {
                "Weight: Bodyweight"
            } else if let weight, weight == "0 lbs" {
                "Weight: Bodyweight"
            } else if let weight, weight.isEmpty {
                "Weight: Bodyweight"
            } else {
                "Weight: 0lbs (Bodyweight)"
            }
        case .none: ""
        }
    }
    
    var hasRest: Bool {
        if let rest, !rest.isEmpty {
            let restValue = self.restValue
            return restValue > 0.0
        } else {
            return false
        }
    }
    
    var restValue: Double {
        guard let rest = rest else { return 0 }
        let data = rest.split(separator: " ")
        guard data.count > 1 else { return 0 }
        let value = Double(data[0]) ?? 0.0
        let unit  = data[1].lowercased()
        if unit == "sec" {
            return value
        } else if unit == "min" {
            return value * 60
        } else {
            return value
        }
    }
    
    var kind: WorkoutKind {
        if let rpe, rpe > 0 {
            return WorkoutKind.rpe
        } else if let distance, !distance.isEmpty {
            return WorkoutKind.distance
        } else if let time, !time.isEmpty, !isEmpty(time) {
            return WorkoutKind.time
        } else if let weight, !weight.isEmpty, weight != "0 lbs" {
            return WorkoutKind.weight
        } else if let reps, reps >= 0 {
            return WorkoutKind.weight
        }  else {
            return WorkoutKind.none
        }
    }
    
    
    func placeholder(reps: Bool = false) -> String {
        switch kind {
        case .time: "Enter Completed Time"
        case .rpe: "Enter Completed Reps"
        case .distance: "Enter Total Distance"
        case .weight: "Enter Total \(reps ? "Reps" : "Weight")"
        case .none: ""
        }
    }
    
    func key(reps: Bool = false) -> String {
        switch kind {
        case .time: "Completed Time"
        case .rpe: "Completed Reps"
        case .distance: "Completed Distance"
        case .weight: "Completed \(reps ? "Reps" : "Weight")"
        case .none: ""
        }
    }
    
    fileprivate func isEmpty(_ duration: String) -> Bool {
        return duration.lowercased() == "0 sec" ||
        duration.lowercased() == "0 min" ||
        duration.lowercased() == "0 mins" ||
        duration.lowercased() == "0 hrs" ||
        duration.lowercased() == "0 hr"
    }
}
