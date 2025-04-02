//
//  WorkoutCompleteView.swift
//  zala
//
//  Created by Kyle Carriedo on 9/27/24.
//

import SwiftUI

struct WorkoutCompleteView: View {
    
    @Environment(WorkoutManager.self) var manager
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image.checkmarkLarge.padding(.top, 50)
            Text("Protocol Complete!")
                .style(color: .white,
                       size: .extra,
                       weight: .w800)
            Text("Great job on completing your workout!")
                .style(color: Theme.shared.grayStroke,
                       size: .regular,
                       weight: .w400)
            Spacer()
            StandardButton(title: "RETURN TO DASHBOARD") {
                manager.endWorkout.toggle()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    fileprivate func data() {
//        let input = UserAddDataInput(user: .some(userId),
//                                     kind: .some(baseline?.kind ?? "zala_baseline"),
//                                     name: .some(baseline?.name ?? "Zala Baseline"),
//                                     beginEpoch: .some(Int(surveyStartTime.timeIntervalSince1970)),
//                                     data: .some(allAnswers))
    }
}

#Preview {
    WorkoutCompleteView()
}
