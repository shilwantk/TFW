//
//  RoutineComplianceDetailCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct RoutineComplianceDetailCellView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Jan 1, 2023")
                        .style(size:.regular, weight: .w500)
                    Text("Complete")
                        .style(color: Theme.shared.green, size:.regular, weight: .w500)
                }
                Spacer()
                Text("181 lbs")
                    .style(size:.x22, weight: .w700)
            }
            .padding(.top, 6)
            Divider().background(.gray).padding(.top, 6)
        }
    }
}

#Preview {
    RoutineComplianceDetailCellView()
}
