//
//  DashboardProgressBarView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/21/24.
//

import SwiftUI

struct DashboardProgressBarView: View {
    @State var icon: Image = .walking
    @State var title: String
    var body: some View {
        ZStack {
            Text(title)
                .style(color: .white, size: .regular, weight: .w700)
            HStack {
                icon.padding(.leading)
                Spacer()
            }
        }
        .frame(height: 50)
        .background(
            LinearGradient(
              stops: [
                  Gradient.Stop(color: Theme.shared.orangeGradientColor.primary, location: 0.00),
                Gradient.Stop(color: Theme.shared.orangeGradientColor.secondary, location: 1.00),
              ],
              startPoint: UnitPoint(x: 0.5, y: 0),
              endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
    }
}

#Preview {
    DashboardProgressBarView(title: "Workout in Progress - 00:34")
}
