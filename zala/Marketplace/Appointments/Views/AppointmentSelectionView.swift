//
//  AppointmentSelectionView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct AppointmentSelectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Select a time slot for")
                    .style(size:.x18, weight: .w400)
                Text("Fri, Apr 20, 2023")
                    .style(color:Theme.shared.lightBlue, size:.x22, weight: .w400)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("Next Available")
                    .style(size: .x22, weight: .w800)
                BookTimeCellView(showTotal: true)
                BookTimeCellView(showTotal: true)
                BookTimeCellView(showTotal: true)
            }
            Spacer()
        }
    }
}

#Preview {
    AppointmentSelectionView()
}
