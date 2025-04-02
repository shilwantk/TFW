//
//  WorkoutReviewCell.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct WorkoutReviewCell: View {
    @State var title: String = "Barbell - Squat"
    @State var isRest: Bool = false
    var body: some View {
        HStack {
            if isRest {
                Image.restMini
            } else {
                Image("demo-squat")
            }
            Text(title)
                .style(size: .small, weight: .w700)
            Spacer()
        }
        
    }
}

#Preview {
    WorkoutReviewCell()
}
