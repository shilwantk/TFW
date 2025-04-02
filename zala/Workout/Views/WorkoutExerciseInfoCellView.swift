//
//  WorkoutExerciseInfoCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct WorkoutExerciseInfoCellView: View {
    @State var title: String
    @State var isMain: Bool
    
    var body: some View {
        HStack {
            Image.workout
            VStack(alignment: .leading) {
                Text(isMain ? "MAIN" : "ALTERNATE")
                    .style(
                        color: isMain ? Theme.shared.lightBlue : Theme.shared.orange,
                        size: .small,
                        weight: .w400)
                Text(title)
                    .style(
                        size: .x18,
                        weight: .w700)
            }
            Spacer()
            Button(action: {
                
            }, label: {
                Image.infoCircle
                    .renderingMode(.template)
                    .foregroundColor(.white)
            })
        }        
    }
}
