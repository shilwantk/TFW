//
//  MyRoutinesView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/28/24.
//

import SwiftUI

struct MyRoutinesView: View {
    @State var service: RoutineService = RoutineService()
    @State var workoutService: WorkoutService = WorkoutService()
    
    @Binding var state: SessionTransitionState
    
    var body: some View {
        ZStack {
            if isEmpty() {
                ZalaEmptyView(title: "No Routines")
            } else {
                ScrollView {
                    ForEach(service.routines, id:\.self) { routine in
                        NavigationLink {
                            RoutineComplianceView(routine: routine)
//                            RoutineDetailView(protocolType: .activeOnly,
//                                              routineId: routine.id ?? "",
//                                              state: .myroutine)
                        } label: {
                            RoutinesCellView(routine: routine)
                        }
                    }
                    ForEach(workoutService.workoutRoutines, id:\.self) { routine in
                        NavigationLink {
                            WorkoutPlansView(workoutId: routine.id!, inviteOnly: false)                            
                        } label: {
                            WorkoutRoutineView(routine: routine)                            
                        }
                    }
                }
                .padding()
            }
        }
        .toolbarWith(title: "ROUTINES", session: $state, completion: { type in })
        .onAppear {
            service.myRoutines()
            workoutService.myWorkoutRoutines(status: .active)
        }
    }
    
    fileprivate func isEmpty() -> Bool {
        return self.service.routines.isEmpty && self.workoutService.workoutRoutines.isEmpty
    }
}
