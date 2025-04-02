//
//  RoutinesCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import ZalaAPI

struct RoutinesCellView: View {
    @State var routine: MinCarePlan
    @State var subscription: Bool = false
    
    var body: some View {
        VStack(spacing:0) {
            if routine.isHabitPlan() {
                BannerCellView(image: Image.habitBanner, title: routine.name ?? "Routine")
            } else {
                BannerCellView(bannerUrl: routine.banner(), title: routine.name ?? "Routine")
            }
            BottomCellView(items: subscription ? subscriptionItems() : myRoutine())
        }
    }
    
    fileprivate func myRoutine() -> [BottomCellItem] {
        return [
//            BottomCellItem(title: "Compliance:", value: routine.complianceScore?.percent ?? "0%"),
            BottomCellItem(title: "Remaining:", value: "\(routine.numberOfDaysRemaining()) days")
        ]
    }
    fileprivate func subscriptionItems() -> [BottomCellItem] {
        return [BottomCellItem(title: "Main Focus:", value: routine.focus?.capitalized ?? "-"),
                BottomCellItem(title: "Vitals Tracked:", value: "\(routine.monitors?.count ?? 0)"),
                BottomCellItem(title: "Duration:", value: "\(routine.durationInDays ?? 0) days")]
    }
}

#Preview {
    RoutinesCellView(routine: .previewPlan)
}



struct WorkoutRoutineView: View {
    @State var routine: WorkoutRoutineModel
    
    var body: some View {
        VStack(spacing:0) {
            BannerCellView(image: Image.habitBanner, title: routine.title ?? "Workout")
            BottomCellView(items: [
                BottomCellItem(title: "Duration:", value: "\(routine.duration ?? 0) days")
            ])
        }
    }
}
