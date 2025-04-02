//
//  DotView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/5/24.
//

import SwiftUI

struct DotView: View {
    
    var gradientColor:GradinetColor
    
    var body: some View {
        Circle().fill(
            LinearGradient(
              stops: [
                  Gradient.Stop(color: gradientColor.primary, location: 0.00),
                Gradient.Stop(color: gradientColor.secondary, location: 1.00),
              ],
              startPoint: UnitPoint(x: 0.5, y: 0),
              endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        .frame(width: 8, height: 8)
    }
}
