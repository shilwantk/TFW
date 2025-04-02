//
//  WorkoutPlansView.swift
//  zala
//
//  Created by Kyle Carriedo on 12/18/24.
//
import SwiftUI
import ZalaAPI
import MarkdownUI

struct WorkoutPlansView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showInstructions: Bool = true
    @State private var showEndAlert: Bool = false
    @State private var showConfirmation: Bool = false
    
    
    @State private var workoutManager: WorkoutManager? = nil
    @State private var service: WorkoutService = WorkoutService()
    @State private var workout: WorkoutRoutineModel? = nil
    @State var workoutId: String
    @State var inviteOnly: Bool
    @State private var selectedWorkoutPlan: WorkoutPlanModel?
    
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ExpandedHeaderView(title: "Instructions", expand: $showInstructions)
                    if showInstructions {
                        if let desc = workout?.plans?.nodes?.first??.desc {
                            VStack {
                                Markdown(desc)
                                    .align(.leading)
                                
                                Image.demoWorkout
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        } else {
                            Text("No Instructions for this workout.")
                                .align(.leading)
                                .padding()
                        }
                    }
                    buildPreviewExpandedView()
                    ForEach(workoutManager?.workoutPlans ?? [], id:\.id) { plan in
                        NavigationLink {
                            WorkoutReviewView(workoutPlan: plan)
                        } label: {
                            draw(plan)
                        }
                        
                    }
                }
                .alert("Great news!", isPresented: $showConfirmation) {
                    Button {
                        dismiss()
                    } label: {
                        Text("OK")
                    }
                } message: {
                    Text("Your workout has been added to My Routines, and your exclusive workout protocols are now ready for you in the My Zala section")
                }
            }
            Spacer()
            if inviteOnly {
                if workout?.status == "pending", let id = workout?.id {
                    Divider().background(.gray)
                    StandardButton(title: "Accept") {
                        service.updateWorkoutRoutine(routineId: id, status: .activate) { complete in
                            showConfirmation.toggle()
                        }
                    }.padding()
                }
            }
        }
        .onAppear(perform: {
            fetchWorkout()
        })
        .navigationDestination(item: $selectedWorkoutPlan, destination: { plan in
            NavigationView {
                WorkoutReviewView(workoutPlan: plan)
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .alert("End Workout", isPresented: $showEndAlert) {
            Button(role: .destructive) {
                service.updateWorkoutRoutine(routineId: workoutId, status: .cancel) { complete in
                    dismiss()
                }
            } label: {
                Text("Yes, End Workout")
            }
            Button(role: .cancel) {
                
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("Are you sure you want to end your workout?")
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("ZALA WORKOUT")
                        .style(color: .white, size: .x18)
                    Text(workout?.title?.capitalized ?? "Exercise")
                        .style(color: Theme.shared.grayStroke, size: .small)
                }
            }
            if !inviteOnly {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Section {
                            Button(action: {
                                showEndAlert.toggle()
                            }, label: {
                                Label("End Workout", systemImage: "exclamationmark.octagon")
                            })
                        }
                    }
                    label: {
                        Label("menu", systemImage: "ellipsis.circle")
                    }
                }
            }
        })
    }
    
    @ViewBuilder
    fileprivate func buildPreviewExpandedView() -> some View {
        HStack {
            Text("Sessions")
                .style(color: .white, size: .x18, weight: .w700)
            Spacer()
        }
    }
    
    fileprivate func draw(_ workoutPlan: WorkoutPlanModel) -> some View {
        DashboardCellView(
            icon: .training,
            title: workoutPlan.title ?? "",
            subtitle: "Protocols - \(workoutPlan.groups?.count ?? 0)",
            complete: false,
            routine: true,
            url: workoutPlan.creator?.attachments?.last?.contentUrl,
            intials: workoutPlan.creator?.initials)
    }
    
    //MARK: - Api
    fileprivate func fetchWorkout() {
        service.invitedRoutines(id: workoutId) { result in
            if let workout = result {
                self.workoutManager = WorkoutManager(workout: workout)
                self.workout = workout
            }
        }
    }
}
