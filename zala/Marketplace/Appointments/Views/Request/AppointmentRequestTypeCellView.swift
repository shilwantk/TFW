//
//  AppointmentRequestTypeCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct AppointmentRequestTypeCellView: View {
    @State var title: String = "In Person"
    @State var subtitle: String = "555 Cherry Street,\nWest Palm Beach, FL 33123"
    @State var price: String = "$200"
    @State var duration: String = "60m"
    @State var isSelected: Bool = false
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if isSelected {
                Image.selected
            } else {
                Image.unselected
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .style(color: isSelected ? .white : Theme.shared.placeholderGray,
                               size: .x18, weight: isSelected ? .w700 : .w400)
                    Spacer()
                    buildBuyButton()
                }
                Text(subtitle)
                    .style(color: isSelected ? .white : Theme.shared.placeholderGray,
                           size: .regular, weight: isSelected ? .w700 : .w400)
            }
            
        }
    }
    
    @ViewBuilder
    fileprivate func buildBuyButton() -> some View {
        Button {
            
        } label: {
            Text(duration)
                .style(color: isSelected ? Theme.shared.mediumBlack : Theme.shared.placeholderGray,
                       size: .xSmall, weight: .w400)
            Divider().background(Theme.shared.placeholderGray).frame(height: 10)
            Text(price)
                .style(color: isSelected ? Theme.shared.mediumBlack : Theme.shared.placeholderGray,
                       size: .xSmall, weight: .w400)
        }
        .padding([.leading, .trailing],10)
        .padding(.vertical,5)
        .background(
            Capsule()
                .stroke(isSelected ? .black : Theme.shared.placeholderGray, lineWidth: 1)
                .fill(isSelected ? .white : .black)
        )
    }
}

#Preview {
    AppointmentRequestTypeCellView()
}
