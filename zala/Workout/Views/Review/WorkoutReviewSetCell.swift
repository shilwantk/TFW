//
//  WorkoutReviewSetCell.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct WorkoutReviewSetCell: View {
    
    @State var header: String = "SET 1"
    
    @State private var expanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ExpandedHeaderView(title: header, expand: $expanded)                
                .padding()
            }
            .frame(height: 50)
            .background(Theme.shared.darkText)
            .cornerRadius(8, corners: expanded ? [.topLeft, .topRight] : .allCorners)
            .onTapGesture {
                withAnimation {
                    expanded.toggle()
                }                
            }
            if expanded {
                VStack {
                    VStack {
                        WorkoutReviewCell()
                        WorkoutReviewCell(isRest: true)
                        WorkoutReviewCell()
                        WorkoutReviewCell()
                        WorkoutReviewCell(isRest: true)
                    }
                    .padding()
                }
                .background(Theme.shared.mediumBlack)
                .cornerRadius(8, corners: expanded ? [.bottomLeft, .bottomRight] : .allCorners)
            }
        }
    }
}

#Preview {
    WorkoutReviewSetCell()
}
