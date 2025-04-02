//
//  WorkoutCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct WorkoutCellView: View {
    @State var icon: Image = Image("demo-split")
    @State var title: String = ""
    @State var middleLine: String = ""
    @State var bottomLine: String = ""
    @State var isAlt: Bool = false
    var body: some View {
        HStack {
            icon
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .style(weight: .w700)
                    if isAlt {
                        Text("(ALT)")
                            .style(color:Theme.shared.orange, weight: .w700)
                    }
                }
                Text(middleLine)
                    .style(size:.small, weight: .w400)
                Text(bottomLine)
                    .style(size:.small, weight: .w400)
            }
            Spacer()
        }
        
    }
}

#Preview {
    WorkoutCellView(
        title: "Barbell - Squat",
        middleLine: "Reps: 10 - RPE: 8",
        bottomLine: "One Rep Max: 200lbs"
    )
}
