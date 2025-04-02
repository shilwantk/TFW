//
//  ComplianceCircleView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI


struct ComplianceCircleView: View {
    @Binding var progress: Double
    @State var lineWidth: CGFloat = 20.0
    @Binding var title: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Theme.shared.mediumBlack,
                    lineWidth: lineWidth
                )
            VStack(alignment: .center,spacing: 5) {
                Text("OVERALL COMPLIANCE")
                    .style(size: .small, weight: .w400)
                Text(title)
                    .style(size: .x55, weight: .w800)
            }
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                      stops: dynamicScore(),
                      startPoint: UnitPoint(x: 0.5, y: 0),
                      endPoint: UnitPoint(x: 0.5, y: 1)
                    ),
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .square
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: progress)
        }
    }
    
    fileprivate func dynamicScore() -> [Gradient.Stop] {
        if progress < 0.49 {
            return [
                Gradient.Stop(color: Theme.shared.orangeGradientColor.primary, location: 0.00),
                Gradient.Stop(color: Theme.shared.orangeGradientColor.secondary, location: 1.00),
            ]
        } else if progress > 0.49 && progress < 0.74 {
            return [
                Gradient.Stop(color: Theme.shared.lightBlueGradientColor.primary, location: 0.00),
                Gradient.Stop(color: Theme.shared.lightBlueGradientColor.secondary, location: 1.00),
            ]
        } else {
            return [
                Gradient.Stop(color: Theme.shared.greenGradientColor.primary, location: 0.00),
                Gradient.Stop(color: Theme.shared.greenGradientColor.secondary, location: 1.00),
            ]
        }
    }
}

#Preview {
    ComplianceCircleView(progress: .constant(0.50), title: .constant("55%"))
}
