//
//  CardView.swift
//  zala
//
//  Created by Kyle Carriedo on 4/15/24.
//

import SwiftUI

enum CardKey {
    case baselinse
    case habits
    case superuser
    case sleep
    case none
}

struct CardView: View {
    
    @State var title: String
    @State var subtitle: String
    @State var key: CardKey = .none
    @State var isPending: Bool = false
    @State var gradientColor: GradinetColor = Theme.shared.orangeGradientColor
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if isPending {
                VStack {
                    HStack {
                        Spacer()
                        Text("PENDING")
                            .style(size: .small, weight: .w700)
                            .padding([.leading, .trailing], 8)
                            .padding([.top, .bottom], 2)
                            .background(RoundedRectangle(cornerRadius: 4).fill(Theme.shared.zalaRed))
                    }
                    .padding([.top, .trailing], 6)
                    Spacer()
                }
            }
            VStack(alignment: .leading) {
                Text(title)
                    .style(size: .x20, weight: .w600)
                Text(subtitle.uppercased())
                    .style(size: .xSmall, weight: .w400)
            }
            .padding([.bottom, .leading], 15)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image.zalaCardLogo
                }
            }
        }
        .frame(width: 275,height: 140)
        .background(
            RoundedRectangle(cornerRadius: 8).fill(
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
        
    }
}

#Preview {
    CardView(title: "", subtitle: "")
}
