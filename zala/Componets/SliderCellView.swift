//
//  SliderCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI

struct SliderCellView: View {
    @State private var value: Double = 0
    var body: some View {
        VStack(spacing: 10) {
            Text("Weight Loss")
                .style(color: .white, size: .regular, weight: .w700)
                .frame(maxWidth:.infinity,  alignment: .leading)
                .padding(.bottom)
            Slider(value: $value, in: 0...5, step: 1.0).tint(Theme.shared.blue)
            HStack(alignment: .center, content: {
                Text("0")
                    .style(color: .white, size: .small)
                Spacer()
                Text("1")
                    .style(color: .white, size: .small)
                Spacer()
                Text("2")
                    .style(color: .white, size: .small)
                Spacer()
                Text("3")
                    .style(color: .white, size: .small)
                Spacer()
                Text("4")
                    .style(color: .white, size: .small)
                Spacer()
                Text("5")
                    .style(color: .white, size: .small)
            })
            HStack(alignment: .center, content: {
                if value == 0 {
                    Text("I could’nt care less")
                        .style(color: Theme.shared.lightBlue, size: .small)
                    Spacer()
                } else if value == 1 {
                    Text("So so")
                        .style(color: Theme.shared.lightBlue, size: .small)
                        .padding(.leading, 59)
                    Spacer()
                } else if value == 2 {
                    Spacer()
                    Text("")
                    Text("Doing Ok")
                        .style(color: Theme.shared.lightBlue, size: .small)
                        .padding(.trailing, 70)
                    Spacer()
                } else if value == 3 {
                    Spacer()
                    Text("")
                    Text("")
                    Text("Kinda important")
                        .style(color: Theme.shared.lightBlue, size: .small)
                        .padding(.leading,40)
                    Spacer()
                } else if value == 4 {
                    Spacer()
                    Text("")
                    Spacer()
                    Text("")
                    Spacer()
                    Text("Oh Yea!")
                        .style(color: Theme.shared.lightBlue, size: .small)
                        .padding(.leading,60)
                    Spacer()
                } else if value == 5 {
                    Spacer()
                    Text("Extremely Important to me")
                        .style(color: Theme.shared.lightBlue, size: .small)
                }
            })
        }
    }
    
}

#Preview {
    SliderCellView().background(.black)
}
