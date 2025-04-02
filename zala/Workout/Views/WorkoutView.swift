//
//  WorkoutView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct WorkoutView: View {
    var body: some View {
        VStack {
            ScrollView {
                VStack {
//                    WorkoutSetView()
//                    WorkoutSetView(header: "SET 2")
                    EmptyView()
                }
            }
            Spacer()
            Divider().background(.gray)
            StandardButton(title: "Start Protocol").padding()
        }
    }
}

#Preview {
    WorkoutView()
}
