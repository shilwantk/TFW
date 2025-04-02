//
//  WorkoutExerciseView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI
import ZalaAPI

struct WorkoutExerciseView: View {
    
    @Environment(WorkoutManager.self) var service
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let exercise: WorkoutSetModel
    @State private var nextItem: WorkoutSetModel? = nil
    
    @State var selection: String = ""
    @State var value: String = ""
    @State var reps: String = ""
    @State var weight: String = ""
    @State var note: String = ""
    @State private var restTime: Int? = nil
    
    @State var didTapNext: Bool = false
    @State var didTapBack: Bool = false
    @State var isComplete: Bool = false
    @State var isSaving: Bool = false
    
    var onComplete: ((_ planId: String) -> Void)?
    @State private var rpe: PickerItem = .init(title: "Select RPE", key: "-99")
    @State private var rpeItems: [PickerItem] = [
        .init(title: "8", key: "8"),
        .init(title: "7", key: "7"),
        .init(title: "6", key: "6"),
        .init(title: "5", key: "5"),
        .init(title: "4", key: "4"),
        .init(title: "3", key: "3"),
        .init(title: "2", key: "2"),
        .init(title: "1", key: "1")
    ]
    
    
    init(exercise: WorkoutSetModel, onComplete: ( (_: String) -> Void)? = nil) {
        self.exercise = exercise
        self.onComplete = onComplete
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment:.top) {
                if isSaving {
                    LoadingBannerView(message: "Saving...")
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            ScrollView {
                VStack{
                    //                    if let alternates = exercise?.alternates,
                    //                        !alternates.isEmpty {
                    //                        HStack(spacing: 0) {
                    //                            ForEach(alternates, id:\.self) { item in
                    //                                Button(action: {
                    //                                    selection = item
                    //                                }, label: {
                    //                                    Text(item)
                    //                                        .style(color: selection == item ? Theme.shared.upDownButton : Theme.shared.placeholderGray,
                    //                                               size: .regular,
                    //                                               weight: .w700)
                    //                                        .padding([.leading, .trailing], 10)
                    //                                        .padding([.top, .bottom], 5)
                    //                                })
                    //                                .selectionBackground(selected: .constant(selection == item))
                    //                            }
                    //                            Spacer()
                    //                        }
                    //                    }
                    WorkoutExerciseInfoCellView(title: service.currentWorkout?.formattedTitle ?? "",
                                                isMain: true)
                    .frame(height: 70)
                    Divider().background(.gray)
                    VStack(alignment: .leading) {
                        Text(exercise.middleLine)
                            .style(size: .x20,
                                   weight: .w700)
                            .align(.leading)
                        if exercise.kind == .rpe {
                            Text(exercise.bottomLine)
                                .style(color: Theme.shared.grayStroke,
                                       size: .xSmall,
                                       weight: .w400)
                            if let max = getMax() {
                                Text("Suggested Weight: \(Int(calculate(max)))lbs | 1RM: \(Int(max)) lbs")
                                    .style(color: Theme.shared.orange,
                                           size: .xSmall,
                                           weight: .w400)
                            }
                            Text("Make sure you don’t exceed your RPE")
                                .style(color: Theme.shared.grayStroke,
                                       size: .xSmall,
                                       weight: .w400)
                                .align(.leading)
                                .italic()
                        }
                    }.padding(.bottom)
                    VStack(alignment: .leading) {
                        Text("Enter Results")
                            .style(size: .x20,
                                   weight: .w400)
                        if exercise.kind == .rpe || exercise.kind == .weight {
                            
                            KeyValueField(key: exercise.key(reps: true),
                                          value: $reps,
                                          placeholder: exercise.placeholder(reps: true),
                                          keyboardType: UIKeyboardType.decimalPad)
                            
                            if exercise.kind == .rpe {
                                DropDownView(selectedOption: $rpe, items: $rpeItems)
                            }
                            
                            if !isBodyWeight() {
                                KeyValueField(key: "Enter Weight",
                                              value: $weight,
                                              placeholder: "Weight",
                                              keyboardType: UIKeyboardType.decimalPad)
                            }
                            
                        } else {
                            KeyValueField(key: exercise.key(),
                                          value: $value,
                                          placeholder: exercise.placeholder())
                        }
                    }.padding(.bottom)
                    VStack(alignment: .leading) {
                        Text("Want to add a note?")
                            .style(size: .x18, weight: .w400)
                            .align(.leading)
                        VStack(alignment: .leading, spacing: 0.0) {
                            TextEditor(text: $note)
                                .scrollContentBackground(.hidden)
                                .background(Theme.shared.mediumBlack)
                                .frame(maxHeight: 350)
                        }
                        .frame(minHeight: 350)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack))
                    }.padding(.top)
                }.padding()
            }
            Spacer()
            StandardButton(title: "Continue") {
                //                if let rest = service.currentWorkout?.hasRest, rest > 0 {
                //                    //timer
                //                    self.restTime = rest
                //                } else {
                //                    service.next()
                //                    self.nextItem = service.currentWorkout
                //                }
                storeAnswer()
                
                if exercise.hasRest {
                    //timer
                    self.restTime = Int(exercise.restValue)
                } else {
                    
                    service.next()
                    
                    if service.completed {
                        self.isSaving = true
                        service.save { complete in
                            guard let planId = service.workoutPlan?.id else { return }
                            let key = "\(Constants.WORKOUT)_\(planId)"
                            self.isSaving = false
                            onComplete?(key)
                            isComplete.toggle()
                        }
                    } else {
                        self.nextItem = service.currentSet
                    }
                }
            }.padding()
        }
        .onAppear(perform: {
            if exercise.kind == .rpe {
                let value = String(self.exercise.rpe ?? 0)
                self.rpe = .init(title: value, key: value)
            }
            
            if let reps = service.currentSet?.reps {
                self.reps = String(reps)
            }
            
            if let weight = service.currentSet?.weight {
                self.weight = String(weight)
            }
            
            //            self.selection = exercise?.alternates.first ?? ""
        })
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $nextItem, destination: { workout in
            WorkoutExerciseView(exercise: workout)
                .environment(service)
        })
        .navigationDestination(item: $restTime, destination: { time in
            WorkoutRestView(time: time)
                .environment(service)
        })
        .navigationDestination(isPresented: $isComplete, destination: {
            WorkoutCompleteView()
                .environment(service)
        })
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("ZALA WORKOUT")
                        .style(color: .white, size: .x18)
                    Text("\(service.workoutPlan?.title ?? "") - \(service.setIdx + 1) of \(service.sets.count)")
                        .style(color: Theme.shared.grayStroke, size: .small)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    service.endWorkout.toggle()
                }, label: {
                    Image.close
                })
            }
            
            ToolbarItem(placement: .cancellationAction) {
                if !service.atStartOfGroups() {
                    Button(action: {
                        service.back()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image.arrowLeft
                    })
                }
            }
        })
    }
    
    fileprivate func isBodyWeight() -> Bool {
        guard let weight = self.exercise.weight else { return true }
        return weight.isEmpty
    }
    
    //MARK: - Helpers
    fileprivate func getMax(rpe: Double = 1.0) -> Double? {
        guard let actvityKey = service.currentWorkout?.activity?.key else { return nil }
        if actvityKey.contains("bench_press") || actvityKey.contains("bench press") {
            return (service.benchMax ?? 0) * rpe
        } else if actvityKey.contains("squat") {
            return (service.squatMax ?? 0) * rpe
        } else if actvityKey.contains("deadlift") {
            return (service.deadliftMax ?? 0) * rpe
        } else {
            return nil
        }
    }
    
    fileprivate func calculate(_ max: Double) -> Double {
        return max * (Double(exercise.rpe ?? 0) / 10)
    }
    
    //MARK: - API
    fileprivate func storeAnswer() {
        guard let setId  = exercise.id else { return }        
        guard let actvityKey = service.currentWorkout?.activity?.key else { return }
        guard let answer = buildDataInput() else { return }
        let key = "\(actvityKey)_\(setId.lowercased())"
        service.store(key: key, answer: answer)
    }
    
    fileprivate func buildDataInput() -> AnswerInput? {
        guard let setId  = exercise.id else { return nil }
//        guard let userId = Network.shared.userId() else { return nil }
        guard let actvityKey = service.currentWorkout?.activity?.key  else { return nil }
        
        let name = service.currentWorkout?.formattedTitle ?? "Zala Workout"
        let currentSet = service.setIdx + 1
        let key = "\(actvityKey)_\(setId.lowercased())"
        let sourceInput = DataValueSourceInput(name: .some("zala_\(name.lowercased())"), identifier: nil)
        let dataValue = weight.isEmpty ? value : weight
        let beganAt = service.clcualteWorkoutTime() ?? .now
        let dataInput = AnswerInput(key:        key,
                                    data:       .some([dataValue]),
                                    unit:       .some("count"),
                                    beginEpoch: .some(Int(beganAt.timeIntervalSince1970)),
                                    endEpoch:   .some(Int(Date.now.timeIntervalSince1970)),
                                    source:     .some(sourceInput))
        
        var json: [String: Any] = [
            "title": name,
            "key": actvityKey,
            "weight": weight,
            "reps": reps,
            "value": value,
            "set": currentSet,
            "note": note,
            "activity": "\(name) - \(exercise.middleLine)",
            "acutal_time": Int(Date.now.timeIntervalSince1970)
        ]
        
        if rpe.key != "-99" {
            json["rpe"] = rpe.key
        }
                
        return dataInput
    }        
}
