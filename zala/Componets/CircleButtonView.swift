//
//  CircleButtonView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/28/24.
//

import SwiftUI

struct CircleButtonView: View {
    @State var icon: Image = .iconAdd
    @State var iconColor: Color = .white
    @State var size: CGFloat = 55.0
    @State var gradientColor: GradinetColor = Theme.shared.lightBlueGradientColor
    
    @Binding var action: Bool
    var body: some View {
        Button {
            withAnimation {
                action.toggle()
            }
            
        } label: {
            icon
                .renderingMode(.template)
                .foregroundColor(iconColor)
        }
        .frame(width: size, height: size)
        .background(
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
        )
        .padding(.trailing)
    }
}

#Preview {
    CircleButtonView(icon: .iconAdd, action: .constant(true))
}
