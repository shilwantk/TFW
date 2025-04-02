//
//  WorkoutRestView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI
import ZalaAPI

struct WorkoutRestView: View {
    @State var didTapNext: Bool = false
    @State var didTapBack: Bool = false
    @State var showInfo: Bool = true
    @State var isComplete: Bool = false
    @State var isSaving: Bool = false
    
    let time:Int
    
    @Environment(WorkoutManager.self) var workoutManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
    @State var nextItem: WorkoutSetModel? = nil
    
    var body: some View {
        VStack {
            ZStack(alignment:.top) {
                if isSaving {
                    LoadingBannerView(message: "Saving...")
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            Text("Rest: \(time.restTimer())")
                .style(size: .x22, weight: .w800)
                .align(.leading)
                .padding()
            CountdownTimerView(timeRemaining: CGFloat(time),
                               totalTime: CGFloat(time))
            .padding()
            Spacer()
            StandardButton(title: "CONTINUE") {
                workoutManager.next()
                self.nextItem = workoutManager.currentSet
                if workoutManager.completed {
                    self.isSaving = true
                    workoutManager.save { complete in
                        self.isSaving = false
                        self.isComplete = true
                    }
                }
            }.padding()
        }
        .navigationDestination(item: $nextItem, destination: { workout in
            WorkoutExerciseView(exercise: workout)
                .environment(workoutManager)
        })
        .navigationDestination(isPresented: $isComplete, destination: {
            WorkoutCompleteView()
                .environment(workoutManager)
        })
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("CRAZY WORKOUT DAY")
                        .style(color: .white, size: .x18)
                    Text("Strength and Power - \(workoutManager.idx + 1) of \(workoutManager.workouts.count)")
                        .style(color: Theme.shared.grayStroke, size: .small)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    workoutManager.endWorkout.toggle()
                }, label: {
                    Image.close
                })
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
//                    workoutManager.back()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image.arrowLeft
                })
            }
        })
    }
}

#Preview {
    WorkoutRestView(time: 30)
}
