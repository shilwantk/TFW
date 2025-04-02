//
//  CalloutCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/21/24.
//

import SwiftUI

struct CalloutCellView: View {
    @State var title: String
    @State var timestamp: String
    @State var value: String
    @State var msg: String
    @State var elevated: Bool
    @Binding var isSelected: Bool
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    if isSelected {
                        DotView(gradientColor: colorGradient())                            
                    }
                    Text(title)
                        .style(color: .white, size: .regular, weight: .w400)
                }
                Spacer()
                Text(value)
                    .style(color: color(), size: .regular, weight: .w700)
                        .multilineTextAlignment(.trailing)
            }
            HStack {
                Text(timestamp)
                    .style(color: Theme.shared.placeholderGray,
                           size: .small,
                           weight: .w400)
                Spacer()
                Text(msg)
                    .style(color: .white,
                           size: .small,
                           weight: .w400)
                    .multilineTextAlignment(.trailing)
            }
        }
        .frame(maxHeight: 52)
        .padding()
        .background(RoundedRectangle(cornerRadius: 8)
            .fill(isSelected ? .black : Theme.shared.mediumBlack)
            .stroke(isSelected ? color() : Theme.shared.mediumBlack, lineWidth: isSelected ? 1 : 0))
    }
    
    fileprivate func color() -> Color {
        return elevated ? Theme.shared.orange : Theme.shared.lightBlue
    }
    
    fileprivate func colorGradient() -> GradinetColor {
        return elevated ? Theme.shared.orangeGradientColor : Theme.shared.lightBlueGradientColor
    }
}
