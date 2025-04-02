//
//  VitalsService.swift
//  zala
//
//  Created by Kyle Carriedo on 5/24/24.
//

import Foundation
import SwiftUI
import ZalaAPI
import Observation

@Observable class VitalsService {

    var vitalsSelection: Set<MetricModel> = []
    var day: Date = Date().startOfDay
    var latestData: [DataValueModel] = []
    var metrics: [MetricModel] = []
    var trainedMetrics: [MetricModel] = []
    var searchMetrics: [MetricModel] = []
    var vitalResults: [VitalModel] = []
    var isSearching: Bool = false
    var filteredMetrics: [MetricModel] = []
    var allMetrics: [MetricModel] {
        return isSearching ? searchMetrics : metrics.sorted(by: {$0.title ?? "" < $1.title ?? ""})
    }
    
    func filterMetrics(key: String) {        
        if key == "body" || key == "train" {
            self.filteredMetrics = trainedMetrics
        } else {
            self.filteredMetrics = metrics.filter({$0.key.hasPrefix(key)}).sorted(by: {$0.title ?? "" < $1.title ?? ""})
        }
    }
    
    func updateUserMetrics(account: Account?) {
        guard let account else { return }
        let userMetrics = account.getPreference(key: .vitalsDashboard)?.value ?? []
        let keys = userMetrics.isEmpty ? metrics.map { $0.key } : userMetrics
        Network.shared.apollo.fetch(query: VitalsQuery(metrics: .some(keys))) { response in
            switch response {
            case .success(let result):
                self.latestData = result.data?.me?.latestData?.compactMap({$0.fragments.dataValueModel}) ?? []
                
            case .failure( _ ):
                break
            }
        }
    }
    
    func fetchLatestVitals() {
        let keys = vitalsSelection.isEmpty ? metrics.map { $0.key } : vitalsSelection.map({$0.key})
        Network.shared.apollo.fetch(query: VitalsQuery(metrics: .some(keys))) { response in
            switch response {
            case .success(let result):
                self.latestData = result.data?.me?.latestData?.compactMap({$0.fragments.dataValueModel}) ?? []
                
            case .failure(_):
                break
            }
        }
    }
    
    func fetchVitals() {
        guard let userId = Network.shared.userId() else { return }
        let startOfDay = Int(day.timeIntervalSince1970)
        let endOfDay = Int(Date().endOfDayByTime().timeIntervalSince1970)
        let keys = vitalsSelection.isEmpty ? metrics.map { $0.key } : vitalsSelection.map({$0.key})
        Network.shared.apollo.fetch(query: AccountVitalsQuery(id: .some(userId),
                                                              metrics: keys,
                                                              sinceEpoch: .some(startOfDay),
                                                              untilEpoch: .some(endOfDay))) { response in
            switch response {
            case .success(let result):
                self.vitalResults =  result.data?.user?.dataValues?.nodes?.compactMap({$0?.fragments.vitalModel}) ?? []
                break
            case .failure(_):
                break
            }
        }
    }
    
    func fetchMetrics(handler: @escaping (Bool) -> Void) {
        Network.shared.apollo.fetch(query: MetricsQuery()) { response in
            switch response {
            case .success(let result):
                self.metrics = result.data?.application?.metrics?.compactMap({$0.fragments.metricModel}) ?? []
                for json in train {
                    var data:[String: Any] = json
                    data["labels"] = [json["title"] ?? ""]
                    let metric = MetricModel(_dataDict: DataDict.init(data: json, fulfilledFragments: []))
                    self.trainedMetrics.append(metric)
                }
                handler(true)
            case .failure(_):
                handler(false)
            }
        }
    }
    
    
    //MARK: - Helpers
    func didConfigureDashboard() -> Bool {
        return UserDefaults.standard.bool(forKey: .configureDashboard)
    }
    
    func handleSelection(metric: MetricModel) {
        if vitalsSelection.contains(metric) {
            vitalsSelection.remove(metric)
        } else {
            vitalsSelection.insert(metric)
        }
    }
    
    func search(string: String) {
        self.isSearching = !string.isEmpty
        guard !string.isEmpty else { return }
        searchMetrics(string: string)
        
    }
    
    fileprivate func searchMetrics(string: String) {
        self.searchMetrics = metrics.filter { metric in
            let title = metric.title ?? ""
            let matchesNetworkName = title.lowercased().localizedCaseInsensitiveContains(string)
            return matchesNetworkName
        }
    }
    
    func handleAllSelection() {
        if vitalsSelection.isEmpty {
            vitalsSelection.formUnion(allMetrics)
        } else {
            vitalsSelection.removeAll()
        }
    }
}



let train: [[String: String]] = [
    [
        "title": "Hyperbaric",
        "key": "recovery.hyperbaric",
    ],
    [
        "title": "5 Min Run",
        "key": "endurance.running"
    ],
    [
        "title": "30 Min Run",
        "key": "endurance.running"
    ],
    [
        "title": "30 Min Walk",
        "key": "activity.walking"
    ],
    [
        "title": "5 Min Bike Ride",
        "key": "endurance.cycling"
    ],
    [
        "title": "A-Skips",
        "key": "coordination.a_skips"
    ],
    [
        "title": "Active Warm-up (Full Body)",
        "key": "flexibiilty.active_warm_up_full_body"
    ],
    [
        "title": "Ankle Mobility",
        "key": "flexibiilty.ankle_mobility"
    ],
    [
        "title": "Aquatics",
        "key": "recovery.aquatics"
    ],
    [
        "title": "B-Skips",
        "key": "coordination.b_skips"
    ],
    [
        "title": "Back Hypers",
        "key": "strength.back_hypers"
    ],
    [
        "title": "Ball Work",
        "key": "coordination.ball_work"
    ],
    [
        "title": "Band Exercises",
        "key": "strength.trx"
    ],
    [
        "title": "Barbell Press",
        "key": "strength.barbell_press"
    ],
    [
        "title": "Barre",
        "key": "activity.barre"
    ],
    [
        "title": "Battle Ropes",
        "key": "endurance.battle_ropes"
    ],
    [
        "title": "Bear Crawls",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Bench Press",
        "key": "strength.bench_press"
    ],
    [
        "title": "Bicep Curls",
        "key": "strength.bicep_curls"
    ],
    [
        "title": "Biofeedback",
        "key": "cognitive.pattern.recognition"
    ],
    [
        "title": "Bird Dog",
        "key": "strength.deadbug"
    ],
    [
        "title": "Body Awareness/Patterning",
        "key": "coordination.body_awareness_patterning"
    ],
    [
        "title": "Bosu Ball",
        "key": "strength.upper_body_balance"
    ],
    [
        "title": "Box Breathing",
        "key": "breathing.down.regulation"
    ],
    [
        "title": "Box Jump",
        "key": "power.box_jump"
    ],
    [
        "title": "Breathe Protocols",
        "key": "breathing.performance.enhancement"
    ],
    [
        "title": "Bridge Series",
        "key": "strength.bridges"
    ],
    [
        "title": "Bridges",
        "key": "strength.bridges"
    ],
    [
        "title": "Broad Jump",
        "key": "power.broad_jump"
    ],
    [
        "title": "Bulgarian Split Squat",
        "key": "strength.bulgarian_split_squat"
    ],
    [
        "title": "Burpees",
        "key": "power.burpees"
    ],
    [
        "title": "Butt Kicks",
        "key": "coordination.a_skips"
    ],
    [
        "title": "C-Skips",
        "key": "coordination.c_skips"
    ],
    [
        "title": "Calf Raises",
        "key": "strength.calf_raises"
    ],
    [
        "title": "Cat - Cow",
        "key": "flexibiilty.movement_flow"
    ],
    [
        "title": "Cervical (Neck)",
        "key": "flexibiilty.cervical_neck"
    ],
    [
        "title": "Cervical ROM",
        "key": "flexibiilty.cervical_neck"
    ],
    [
        "title": "Chest Fly",
        "key": "strength.chest_fly"
    ],
    [
        "title": "Clam Shells",
        "key": "strength.clam_shells"
    ],
    [
        "title": "Clean",
        "key": "strength.clean"
    ],
    [
        "title": "Clean-Press",
        "key": "strength.clean_press"
    ],
    [
        "title": "Club Swings",
        "key": "coordination.rope_training"
    ],
    [
        "title": "Cold Exposure",
        "key": "recovery.cold_exposure"
    ],
    [
        "title": "Cold/Ice Tub",
        "key": "recovery.cold_ice_tub"
    ],
    [
        "title": "Compression Boots",
        "key": "recovery.compression_boots"
    ],
    [
        "title": "Cone drills",
        "key": "coordination.cone_drills"
    ],
    [
        "title": "Cool Mitt/Palm Cooling",
        "key": "recovery.cool_mitt_palm_cooling"
    ],
    [
        "title": "Copenhagen's",
        "key": "strength.copenhagens"
    ],
    [
        "title": "Crunches",
        "key": "strength.crunches"
    ],
    [
        "title": "Cryo Therapy",
        "key": "recovery.cryo_therapy"
    ],
    [
        "title": "Cycling",
        "key": "endurance.cycling"
    ],
    [
        "title": "Deadbug",
        "key": "strength.deadbug"
    ],
    [
        "title": "Diaphragm/Pelvic Floor",
        "key": "strength.diaphragm_pelvic_floor"
    ],
    [
        "title": "Dips",
        "key": "strength.dips"
    ],
    [
        "title": "Double Under",
        "key": "power.double_under"
    ],
    [
        "title": "Dynamic Planks",
        "key": "strength.planks_all_directions"
    ],
    [
        "title": "Dynamic Stretching",
        "key": "flexibiilty.dynamic_stretching"
    ],
    [
        "title": "E-Stim",
        "key": "recovery.e_stim"
    ],
    [
        "title": "Elbow Mobility",
        "key": "flexibiilty.elbow_mobility"
    ],
    [
        "title": "Elliptical",
        "key": "endurance.elliptical"
    ],
    [
        "title": "Explosive Push Up",
        "key": "power.explosive_push_up"
    ],
    [
        "title": "Farmers Carry",
        "key": "strength.farmers_carry"
    ],
    [
        "title": "Fine Motor Control",
        "key": "coordination.fine_motor_control"
    ],
    [
        "title": "Float Tank",
        "key": "recovery.float_tank"
    ],
    [
        "title": "Fly",
        "key": "strength.fly"
    ],
    [
        "title": "Foam Roller",
        "key": "recovery.foam_roller"
    ],
    [
        "title": "Foot-Eye Coordination",
        "key": "coordination.foot_eye_coordination"
    ],
    [
        "title": "Good Mornings",
        "key": "strength.lower_body"
    ],
    [
        "title": "Gross Motor Control",
        "key": "coordination.gross_motor_control"
    ],
    [
        "title": "Hamstring Curls",
        "key": "strength.hamstring_curls"
    ],
    [
        "title": "Hand-Eye Coordination",
        "key": "coordination.hand_eye_coordination"
    ],
    [
        "title": "Hand/Wrist Mobility",
        "key": "flexibiilty.hand_wrist_mobility"
    ],
    [
        "title": "Handstand Pushup",
        "key": "strength.upper_body_balance"
    ],
    [
        "title": "Hanging Scapular Sets",
        "key": "strength.scapular_stability"
    ],
    [
        "title": "Heel Walks",
        "key": "coordination.lower_extremity_plyometrics"
    ],
    [
        "title": "Hip Drops",
        "key": "strength.lower_body_balance"
    ],
    [
        "title": "Hip Mobility",
        "key": "flexibiilty.hip_mobility"
    ],
    [
        "title": "Hot Tub",
        "key": "recovery.hot_tub"
    ],
    [
        "title": "Inch Worm",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Jaw Mobility",
        "key": "flexibiilty.jaw_mobility"
    ],
    [
        "title": "Juggling (Feet)",
        "key": "coordination.juggling_feet"
    ],
    [
        "title": "Juggling (Hands)",
        "key": "coordination.juggling_hands"
    ],
    [
        "title": "Jump Rope",
        "key": "coordination.jump_rope"
    ],
    [
        "title": "Jump Squat",
        "key": "power.jump_squat"
    ],
    [
        "title": "Jumping Jacks",
        "key": "endurance.jumping_jacks"
    ],
    [
        "title": "Jumping Lunges",
        "key": "power.jumping_lunges"
    ],
    [
        "title": "Jumps (Box, etc.)",
        "key": "strength.jumps"
    ],
    [
        "title": "Karaoke's?",
        "key": "coordination.karaoke"
    ],
    [
        "title": "Kettlebell Swing",
        "key": "strength.kettlebell_swing"
    ],
    [
        "title": "Knee Hugs",
        "key": "flexibiilty.active_warm_up_full_body"
    ],
    [
        "title": "Ladder Drills",
        "key": "coordination.ladder_drills"
    ],
    [
        "title": "Landmine Core Rotation",
        "key": "power.landmine_core_rotation"
    ],
    [
        "title": "Lat Pull Down",
        "key": "strength.lat_pull_down"
    ],
    [
        "title": "Lateral Bounding",
        "key": "power.lateral_bounding"
    ],
    [
        "title": "Lateral Lunge",
        "key": "strength.lower_body"
    ],
    [
        "title": "Leg Press",
        "key": "strength.leg_press"
    ],
    [
        "title": "Leg Swings",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Lower Body",
        "key": "strength.lower_body"
    ],
    [
        "title": "Lower Body Balance",
        "key": "strength.lower_body_balance"
    ],
    [
        "title": "Lower Extremity Plyometrics",
        "key": "coordination.lower_extremity_plyometrics"
    ],
    [
        "title": "Lumbar (Low Back)",
        "key": "flexibiilty.lumbar_low_back"
    ],
    [
        "title": "Lumbar Stability",
        "key": "strength.lower_body_balance"
    ],
    [
        "title": "Lunges",
        "key": "strength.lunges"
    ],
    [
        "title": "Medicine Ball Chest Pass",
        "key": "power.medicine_ball_chest_pass"
    ],
    [
        "title": "Medicine Ball Slams",
        "key": "power.medicine_ball_slams"
    ],
    [
        "title": "Medicine Ball Toss",
        "key": "strength.medicine_ball_toss"
    ],
    [
        "title": "Mind-Body Coordination",
        "key": "coordination.mind_body_coordination"
    ],
    [
        "title": "Monkey Bars",
        "key": "endurance.monkey_bars"
    ],
    [
        "title": "Monster Walks",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Mountain Climbers",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Movement Flow",
        "key": "flexibiilty.movement_flow"
    ],
    [
        "title": "Multidirectional Jumps",
        "key": "coordination.multidirectional_jumps"
    ],
    [
        "title": "Muscle Snatch",
        "key": "power.muscle_snatch"
    ],
    [
        "title": "Neuro Training",
        "key": "coordination.neuro_training"
    ],
    [
        "title": "Nordic Curls",
        "key": "strength.nordic_curls"
    ],
    [
        "title": "Ocular Proprieceptive Tuning",
        "key": "cognitive.spatial.acuity"
    ],
    [
        "title": "Open Books",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "OverLifting",
        "key": "coordination.overlifting"
    ],
    [
        "title": "OverRunning",
        "key": "coordination.overrunning"
    ],
    [
        "title": "OverTraining",
        "key": "coordination.overtraining"
    ],
    [
        "title": "Paddleboarding",
        "key": "endurance.paddleboarding"
    ],
    [
        "title": "Perturbation Training",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Pilates",
        "key": "flexibiilty.pilates"
    ],
    [
        "title": "Pistol Squat",
        "key": "strength.pistol_squat"
    ],
    [
        "title": "Plank",
        "key": "strength.planks_all_directions"
    ],
    [
        "title": "Plyometric Push Up",
        "key": "power.plyometric_push_up"
    ],
    [
        "title": "Power Clean",
        "key": "power.power_clean"
    ],
    [
        "title": "Power Snatch",
        "key": "power.power_snatch"
    ],
    [
        "title": "Press",
        "key": "strength.press"
    ],
    [
        "title": "Prowler / Sled Sprint",
        "key": "power.prowler_sled_sprint"
    ],
    [
        "title": "PsychoMotor Overload",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Pull ups",
        "key": "strength.pull_ups"
    ],
    [
        "title": "Push Jerk",
        "key": "power.push_jerk"
    ],
    [
        "title": "Push Press",
        "key": "power.push_press"
    ],
    [
        "title": "Push Up",
        "key": "strength.push_up"
    ],
    [
        "title": "Push Up Progression",
        "key": "strength.push_up_progression"
    ],
    [
        "title": "RDL Walk/Inverted Hamstring Stretch",
        "key": "strength.rdls"
    ],
    [
        "title": "RDLs",
        "key": "strength.rdls"
    ],
    [
        "title": "Rear Foot Elevated Squat",
        "key": "strength.rear_foot_elevated_squat"
    ],
    [
        "title": "Reverse Fly",
        "key": "strength.reverse_fly"
    ],
    [
        "title": "Reverse Plank",
        "key": "strength.planks_all_directions"
    ],
    [
        "title": "Rhythmic Stabilization",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Rock Climb",
        "key": "endurance.rock_climb"
    ],
    [
        "title": "Rope Training",
        "key": "coordination.rope_training"
    ],
    [
        "title": "Rotational Lunge",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Rowing",
        "key": "endurance.rowing"
    ],
    [
        "title": "Rows (Bench)",
        "key": "strength.rows_bench"
    ],
    [
        "title": "Rows (Dumbbell)",
        "key": "strength.rows_dumbbell"
    ],
    [
        "title": "Rows (Kettlebell)",
        "key": "strength.rows_kettlebell"
    ],
    [
        "title": "Running",
        "key": "endurance.running"
    ],
    [
        "title": "Sauna",
        "key": "recovery.sauna"
    ],
    [
        "title": "Scapular Clocks",
        "key": "strength.scapular_stability"
    ],
    [
        "title": "Scapular Sets",
        "key": "strength.scapular_stability"
    ],
    [
        "title": "Scapular Stability",
        "key": "strength.scapular_stability"
    ],
    [
        "title": "Shoulder Mobility",
        "key": "flexibiilty.shoulder_mobility"
    ],
    [
        "title": "Shoulder Series - Bands",
        "key": "strength.shoulder_shrug"
    ],
    [
        "title": "Shoulder Shrug",
        "key": "strength.shoulder_shrug"
    ],
    [
        "title": "Side Bridges",
        "key": "strength.planks_all_directions"
    ],
    [
        "title": "Side Plank",
        "key": "strength.planks_all_directions"
    ],
    [
        "title": "Sideways Sprinting Mechanics",
        "key": "coordination.sideways_sprinting_mechanics"
    ],
    [
        "title": "Single Leg Balance",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Single Leg Bridge",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Single Leg RDL",
        "key": "strength.rdls"
    ],
    [
        "title": "Skating",
        "key": "endurance.skating"
    ],
    [
        "title": "Snatch",
        "key": "power.snatch"
    ],
    [
        "title": "Soft Tissue Mobilization",
        "key": "flexibiilty.soft_tissue_mobilization"
    ],
    [
        "title": "Spatial Awareness",
        "key": "coordination.spatial_awareness"
    ],
    [
        "title": "Speed Bench Press",
        "key": "power.speed_bench_press"
    ],
    [
        "title": "Speed Walking",
        "key": "endurance.speed_walking"
    ],
    [
        "title": "Spiderman Lunge",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Split Squat",
        "key": "strength.split_squat"
    ],
    [
        "title": "Squat Jumps",
        "key": "endurance.squat_jumps"
    ],
    [
        "title": "Squats",
        "key": "strength.squats"
    ],
    [
        "title": "Squats on Decline",
        "key": "strength.squats_on_decline"
    ],
    [
        "title": "Static Stretching",
        "key": "flexibiilty.static_stretching"
    ],
    [
        "title": "Step Ups",
        "key": "strength.step_ups"
    ],
    [
        "title": "Stretching",
        "key": "recovery.stretching"
    ],
    [
        "title": "Swimmers",
        "key": "strength.swimmers"
    ],
    [
        "title": "Swimming",
        "key": "endurance.swimming"
    ],
    [
        "title": "Tabletops",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Tai Chi",
        "key": "flexibiilty.tai_chi"
    ],
    [
        "title": "Target Training",
        "key": "coordination.target_training"
    ],
    [
        "title": "Thoracic (Trunk/Rib Cage)",
        "key": "flexibiilty.thoracic_trunk_rib_cage"
    ],
    [
        "title": "Toe Walking",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Transverse Abdominus Contraction",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Tricep Extension",
        "key": "strength.tricep_extension"
    ],
    [
        "title": "TRX",
        "key": "strength.trx"
    ],
    [
        "title": "Tuck Jump",
        "key": "power.tuck_jump"
    ],
    [
        "title": "Turkish Getup",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Unstable Surface Training",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "Upper Body",
        "key": "strength.upper_body"
    ],
    [
        "title": "Upper Body Balance",
        "key": "strength.upper_body_balance"
    ],
    [
        "title": "Upper Extremity Plyometrics",
        "key": "coordination.upper_extremity_plyometrics"
    ],
    [
        "title": "Upper Extremity Weight Bearing Stability",
        "key": "coordination.psychomotor_overload"
    ],
    [
        "title": "VO2 Max Training",
        "key": "endurance.vo2_max_training"
    ],
    [
        "title": "Walking",
        "key": "activity.walking"
    ],
    [
        "title": "Wall Ball",
        "key": "power.wall_ball"
    ],
    [
        "title": "Wall Sit",
        "key": "strength.wall_sit"
    ],
    [
        "title": "Whim Hoff",
        "key": "breathing.performance.enhancement"
    ],
    [
        "title": "Yoga",
        "key": "flexibiilty.yoga"
    ],
    [
        "title": "YOGA",
        "key": "recovery.yoga"
    ],
    [
        "title": "Zone 2 Cardio",
        "key": "recovery.zone_2_cardio"
    ],
    [
        "title": "Zone Cardio 1 - 50-60%",
        "key": "endurance.zone_cardio_1_50_60"
    ],
    [
        "title": "Zone Cardio 2 - 60-70%",
        "key": "endurance.zone_cardio_2_60_70"
    ],
    [
        "title": "Zone Cardio 3 - 70-80%",
        "key": "endurance.zone_cardio_3_70_80"
    ],
    [
        "title": "Zone Cardio 4 - 80-90%",
        "key": "endurance.zone_cardio_4_80_90"
    ],
    [
        "title": "Zone Cardio 5 - 90-100%",
        "key": "endurance.zone_cardio_5_90_100"
    ]
]

