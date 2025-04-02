//
//  TintButton.swift
//  zala
//
//  Created by Kyle Carriedo on 3/24/24.
//

import SwiftUI

struct TintButton: View {
    @State var icon: Image? = .stopwatch
    @State var title: String = "Button"
    @State var color: Color = Theme.shared.orange
    @State var minHeight: CGFloat = 55
    @State var centerAlign: Bool = true
    var onTapped: (() -> Void)?
    var body: some View {
        Button(action: {
            onTapped?()
        }, label: {
            if centerAlign {
                ZStack(alignment:.center) {
                    if let icon {
                        HStack {
                            icon
                                .renderingMode(.template)
                                .foregroundColor(color)
                            Spacer()
                        }
                        .padding(.leading)
                    }
                    Text(title)
                        .style(color: color, weight: .w700)
                }
            } else {
                HStack {
                    if let icon {
                        icon
                            .renderingMode(.template)
                            .foregroundColor(color)
                        Text(title)
                            .style(color: color, weight: .w700)
                        Spacer()
                    }
                }
                .padding(.leading)
            }
        })
        .frame(maxWidth: .infinity, minHeight: minHeight)
        .background(
            RoundedRectangle(cornerRadius: 8).fill(color.opacity(0.12))
        )
    }
}

#Preview {
    TintButton()
}
