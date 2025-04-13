//
//  BaselineSurveyView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/29/24.
//

import SwiftUI

enum BaselineKind {
    case multi
    case single
    case dropdown
    case singleWithDropdown
    case multiWithDropdown
    case checkboxSingle
    case checkboxMulti
    case scale
    case none
}

struct BaselineQuestion: Hashable, Identifiable {
    var id = UUID()
    var question: String
    var kind: BaselineKind
    var selectionOptions:[String] = []
    var dropdownOptions:[PickerItem] = []
    var sliderOptions: [BaselineSlider] = []
    var dropDownRevealKey: String = "-99"
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ZalaQuestion: Codable, Hashable {
    var id = UUID()
    var key: String
    var kind: String
    var text: String
    var choices: [String: String]
    var prefill: Bool
    var required: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decode(String.self, forKey: .key)
        self.kind = try container.decode(String.self, forKey: .kind)
        self.text = try container.decode(String.self, forKey: .text)
        self.choices = try container.decode([String : String].self, forKey: .choices)
        self.prefill = try container.decode(Bool.self, forKey: .prefill)
        self.required = try container.decode(Bool.self, forKey: .required)
    }
    
    var isOther: Bool {
        key.contains("other")
    }
    
    func zalaKind() -> BaselineKind {
        
        if self.kind.lowercased() == "single_select" {
          return .single
        } else if self.kind.lowercased() == "multi_select" {
          return .multi
        } else if self.kind.lowercased() == "checkbox_select" {
            return .checkboxSingle
        } else if self.kind.lowercased() == "checkbox_multi_select" {
            return .checkboxMulti
        } else {
            return .single
        }
        
    }
    
    func isMulti() -> Bool {
        return self.zalaKind() == .multi || self.zalaKind() == .checkboxMulti
    }
    
    //handle case where other should be last
    func sortedKeys() -> [String] {
        let keys = Array(choices.keys).sorted { first, second in
            // Check if both can be converted to numbers
            if let firstNumber = Int(first), let secondNumber = Int(second) {
                return firstNumber < secondNumber
            }
            // If one is a number and the other isn't, prioritize numbers
            if Int(first) != nil {
                return true
            }
            if Int(second) != nil {
                return false
            }
            // Both are strings, sort lexicographically
            return first < second
        }
        
        let nonOtherWords = keys.filter({!$0.lowercased().contains("other")})
        let containsOther = keys.filter { $0.lowercased().contains("other") }
        return nonOtherWords + containsOther
    }
}

extension String {
    func titleAndSubtitle() -> (title: String, subtitle: String)? {
        // Check if the input contains a newline character
        if let newlineRange = self.range(of: "\n") {
            // Split the string into title and subtitle
            let title = String(self[..<newlineRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            let subtitle = String(self[newlineRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            return (title, subtitle)
        }
        return nil
    }
}


struct BaselineSurveyView: View {
    
    @Environment(\.dismiss) var dismiss
        
    @State var currentQuestion: ZalaQuestion?
    
    @State private var didTapNext: Bool = false
    @State private var didTapBack: Bool = false
    @Binding var didDismiss: Bool            
    
    @Environment(SurveyService.self) private var service
    
    var body: some View {
        VStack {
            if let current = currentQuestion, !service.complete  { //service.readyForNextQuestion() ,
                build(question: current)
            }
        }
        .navigationDestination(isPresented: $didTapNext, destination: {
            if !service.complete {
                BaselineSurveyView(didDismiss: $didDismiss)
                    .environment(service)
            } else {
                BaselineCompleteView(dismiss: $didDismiss)
                    .environment(service)
            }
        })
        .onChange(of: didTapBack) { oldValue, newValue in
            if newValue {
                service.moveBack()
                dismiss()
            }
        }
        .onChange(of: didTapNext) { oldValue, newValue in
            if newValue {
                service.moveForward()
            }
        }
        .onChange(of: didDismiss) { oldValue, newValue in
            service.currentQuestionIndex = 0
            dismiss()
        }
        .onAppear(perform: {
            Task {
                    while currentQuestion == nil && !service.complete {
                        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 sec
                        currentQuestion = service.getQuestion()
                    }
                }
        })
    }
    
    @ViewBuilder
    fileprivate func build(question: ZalaQuestion) -> some View {
        let current =  Double(service.currentQuestionIndex)
        let total =  Double(service.questionsForGroup().count)
        if question.zalaKind() == .single {
            BaselineQuestionView(baselineQuestion: question,
                                 isMuti: question.isMulti(),
                                 current: current,
                                 total: total,
                                 didTapNext: $didTapNext,
                                 didTapBack: $didTapBack, 
                                 didDismiss: $didDismiss)
        }
        else if question.zalaKind() == .multi {
            BaselineQuestionView(baselineQuestion: question,
                                 isMuti: question.isMulti(),
                                 current: current,
                                 total: total,
                                 didTapNext: $didTapNext,
                                 didTapBack: $didTapBack,
                                 didDismiss: $didDismiss)
            .environment(service)
        }
        else if question.zalaKind() == .checkboxSingle {
            BaselineCheckboxQuestionView(baselineQuestion: question,
                                         isMuti: question.isMulti(),
                                         current: current,
                                         total: total,
                                         didTapNext: $didTapNext,
                                         didTapBack: $didTapBack,
                                         didDismiss: $didDismiss)
            .environment(service)
        }
        else if question.zalaKind() == .checkboxMulti {
            BaselineCheckboxQuestionView(baselineQuestion: question,
                                         isMuti: question.isMulti(),
                                         current: current,
                                         total: total,
                                         didTapNext: $didTapNext,
                                         didTapBack: $didTapBack,
                                         didDismiss: $didDismiss)
            .environment(service)
        }
        else {
            EmptyView()
        }
    }
}

let questionnaireData: [String: Any] = [
    "actions": [
        [
            "group",
            [
                "label": "General"
            ],
            [
                [
                    "question",
                    [
                        "key": "baseline.lifestyle",
                        "kind": "single_select",
                        "text": "How would you best describe your lifestyle?",
                        "choices": [
                            "professional_athlete": "Professional Athlete\nMy life and career are dedicated to optimizing performance.",
                            "collegiate_athlete": "Collegiate Athlete\nI compete at the college level and manage both academics and athletics.",
                            "youth_athlete": "Youth Athlete\nI’m young and committed to improving my skills to reach higher levels.",
                            "enthusiast": "Aspiring Health & Wellness Enthusiast\nI am working toward building a consistent health and wellness lifestyle through sports, fitness, and personal well-being practices.",
                            "high_performer": "Executive or High-Performer\nI’m not a professional athlete, but I have high demands on my time and need to perform at my best.",
                            "parent": "Parent/Family Focused\nI’m looking for solutions that help me or my family (e.g., kids’ activities, parent support, family wellness)."
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.journey",
                        "kind": "single_select",
                        "text": "What is your Health & Wellness Journey Current Focus? (Past 30 Days)",
                        "choices": [
                            "sport": "Sport",
                            "yogic": "Yogic Arts & Science",
                            "health": "Health & Wellness",
                            "mental": "Mental Performance",
                            "recovery": "Injury Recovery",
                            "strength": "Strength ",
                            "endurance": "Endurance"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.night.routine",
                        "kind": "single_select",
                        "text": "Do you have a Morning and/or Night Routine?",
                        "choices": [
                            "both": "Both",
                            "night": "Night",
                            "morning": "Morning",
                            "neither": "Neither"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.hours.sleep",
                        "kind": "single_select",
                        "text": "How many hours of Sleep do you get per night?",
                        "choices": [
                            "0-4": "0-4",
                            "10+": "10+",
                            "4-6": "4-6",
                            "6-8": "6-8",
                            "8-10": "8-10"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.characteristics.sleep",
                        "kind": "multi_select",
                        "text": "Do you have any of these Sleep characteristics?",
                        "choices": [
                            "naps": "I take Naps",
                            "none": "None of the Above",
                            "groggy": "Wake up Feeling Groggy",
                            "restless": "Restless Sleep",
                            "refreshed": "Wake up Refreshed and Ready for the Day",
                            "falling_asleep": "Trouble Falling Asleep",
                            "staying_asleep": "Trouble Staying Asleep"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.prefer.exercise",
                        "kind": "multi_select",
                        "text": "What kind of settings would you prefer for exercise? Choose all that apply",
                        "choices": [
                            "partner": "Partner ",
                            "individual": "Individual",
                            "large_group": "Large Group (8+)",
                            "small_group": "Small Group (3-7 people)"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.type.exercise",
                        "kind": "multi_select",
                        "text": "What is your preferred type of exercise? Choose all that apply",
                        "choices": [
                            "gym": "Gym",
                            "hitt": "HIIT",
                            "dance": "Dance",
                            "sports": "Sports",
                            "endurance": "Endurance (Walking, Running, Cycling, Rowing)",
                            "meditation": "Meditation",
                            "dont_exercise": "I don't exercise",
                            "cognitive_games": "Cognitive Games",
                            "flexibility_mobility": "Flexibility & Mobility"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ]
            ]
        ],
        [
            "group",
            [
                "label": "General"
            ],
            [
                [
                    "question",
                    [
                        "key": "baseline.type.exercise",
                        "kind": "multi_select",
                        "text": "What type of Exercise do you currently do? You can select more than one option",
                        "choices": [
                            "sport": "Sport",
                            "classes": "Classes and Flexibility",
                            "cognitive": "Cognitive Games",
                            "endurance": "Endurance",
                            "meditation": "Meditation",
                            "dont_exercise": "I don't exercise",
                            "resistance_training": "Resistance Training"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.when.exercise",
                        "kind": "single_select",
                        "text": "When do you Exercise",
                        "choices": [
                            "midday": "Midday",
                            "multiple": "Multi-Times per Day",
                            "weekends": "Weekends",
                            "regularly": "I don't exercise regularly",
                            "after_work": "After Work or School",
                            "before_work": "Before Work or School"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.overall.daily",
                        "kind": "single_select",
                        "text": "How would you describe your overall daily nutrition habits?",
                        "choices": [
                            "a+": "My nutrition habits are great! (A+)",
                            "b+": "My nutrition habits are mostly good, but there are areas I could improve. (B+)",
                            "c+": "My nutrition habits are OK, but I think they could be a lot better. (C+)",
                            "not_sure": "I'm not sure if my nutrition habits are good or need support.",
                            "habit_support": "My nutrition habits need a lot of support. "
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ]
            ]
        ],
        [
            "group",
            [
                "label": "General"
            ],
            [
                [
                    "question",
                    [
                        "key": "baseline.food.avoid",
                        "desc": "",
                        "kind": "multi_select",
                        "text": "Do you have any specific foods you avoid (individual preferences, dietary restrictions, religious reasons, allergies, etc.)?",
                        "choices": [
                            "soy": "Soy",
                            "beef": "Beef",
                            "corn": "Corn",
                            "eggs": "Eggs",
                            "fish": "Fish",
                            "milk": "Milk",
                            "pork": "Pork",
                            "wheat": "Wheat",
                            "peanuts": "Peanuts",
                            "poultry": "Poultry",
                            "shellfish": "Shellfish",
                            "tree_nuts": "Tree Nuts",
                            "not_listed": "The food(s) I avoid are not listed. ",
                            "avoid_foods": "I do not avoid any foods or food groups. "
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.nutrition.supplements",
                        "kind": "multi_select",
                        "text": "Are you currently taking any supplements?",
                        "choices": [
                            "option_1": "ACE Inhibitor for Blood Pressure (example: Lisinopril)",
                            "option_2": "Levothyroxine (Synthroid)",
                            "option_3": "Statin Drugs for High Cholesterol (Lipitor/Atorvastatin)",
                            "option_4": "Metformin for Diabetes",
                            "option_5": "Insulin for Diabetes",
                            "option_6": "Proton Pump Inhibitors (Prilosec) for Heartburn/Peptic Ulcer",
                            "option_7": "NSAID Pain Relievers (Acetominophen, Ibuprofen, etc.)",
                            "option_8": "Corticosteroids",
                            "option_9": "Omega-3 Fish Oil Supplement",
                            "option_10": "Multivitamin Supplement",
                            "option_11": "Vitamin D Supplement",
                            "option_12": "B-Complex Vitamin Supplement",
                            "option_13": "Magnesium Supplement",
                            "option_14": "Melatonin Supplement"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.performance.goal",
                        "kind": "single_select",
                        "text": "Do you have a specific nutrition/performance goal? If Yes, choose all that apply:",
                        "choices": [
                            "mantain": "Maintain Weight But Improve Body Composition (Lose Fat, Gain Muscle)",
                            "cognitive": "Support Cognitive Performance and Brain Health",
                            "gut_health": "Optimize Gut Health",
                            "postpartum": "Support Postpartum / Lactation Needs",
                            "gain_weight": "Gain Weight",
                            "lose_weight": "Lose Weight",
                            "healthy_aging": "Understand Nutrition for Healthy Aging",
                            "macronutrient": "Develop a specific meal / portion / macronutrient plan",
                            "not_currently": "Not Currently",
                            "portion_sizes": "Understand / Optimize Appropriate Portion Sizes for Meals & Snacks",
                            "cooking_skills": "Develop Cooking Skills ",
                            "meals_&_snacks": "Understand / Optimize Timing of Meals & Snacks",
                            "healthy_recipes": "Find New Healthy Recipes",
                            "support_overall": "Support Overall Health / Longevity",
                            "healthy_pregnacy": "Support Healthy Pregnancy",
                            "improve_physical": "Improve Physical Energy for Lifestyle",
                            "chronic_condition": "Support Chronic Condition or Recovery From Illness",
                            "general_nutrition": "Understand General Nutrition for Healthy Living",
                            "improve_performance": "Improve Physical Performance in Sports or Activities",
                            "general_child_health": "Understand General Nutrition for Children & Healthy Families",
                            "recovery_from_injury": "Support Recovery From Injury",
                            "nutritional_supplements": "Understand Nutritional Supplements"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ],
                [
                    "question",
                    [
                        "key": "baseline.wearable",
                        "kind": "multi_select",
                        "text": "Do you have a wearable? If so, choose all that apply:",
                        "choices": [
                            "coros": "Coros",
                            "other": "Other",
                            "oura ": "Oura ",
                            "polar": "Polar",
                            "whoop": "Whoop",
                            "fitbit": "Fitbit",
                            "garmin": "Garmin",
                            "samsung": "Samsung",
                            "biostrap": "Biostrap",
                            "withings": "Withings",
                            "apple_watch": "Apple Watch"
                        ],
                        "prefill": true,
                        "required": true
                    ]
                ]
            ]
        ]
    ]
]
