//
//  RoutineComplianceCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct RoutineComplianceCellView: View {
    @State var icon: Image = .pills
    @State var title: String
    @State var subtitle: String
    @State var complete: Bool = false
    @State var iconSize: CGSize = CGSize(width: 27, height: 19)
    @State var percent: Double = 0.75
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            if complete {
                Image.selected
                    .frame(width: 36, height: 36)
                    .padding(.leading)
            } else {
                IconView(icon: icon,
                         iconSize: iconSize,
                         imageColor: .black,
                         backgroundSize: 40,
                         gradinetColor: Theme.shared.lightBlueGradientColor)
                .padding(.leading)
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(title)
                        .style(color: .white, size: .regular, weight: .w500)
                        .strikethrough(complete)
                        .lineLimit(1)
                    Spacer()
                    HStack {
                        Text(percent, format: .percent)
                            .style(color: dynamicScore(),
                                   size: .regular,
                                   weight: .w700)                        
                    }
                }
                
                HStack(alignment: .center) {
                    Text(subtitle)
                        .style(color:Theme.shared.placeholderGray,
                               size: .regular,
                               weight: .w400)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack))
    }
    
    fileprivate func dynamicScore() -> Color {
        if percent < 0.49 {
            return Theme.shared.purple
        } else if percent > 0.49 && percent < 0.74 {
            return Theme.shared.orange
        } else if percent > 0.74 && percent < 0.85 {
            return Theme.shared.blue
        } else {
            return Theme.shared.green
        }
    }
}

#Preview {
    RoutineComplianceCellView(title: "Supplement - Tongkat Ali - 250mg", subtitle: "Daily • 1 times • Anytime")
}
