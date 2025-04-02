//
//  PaymentMethodCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct PaymentMethodCellView: View {
    @State var isSelected: Bool = true
    var body: some View {
        HStack {
            if isSelected {
                Image.selected
            } else {
                Image.unselected
            }
            Text("Visa **** **** **** 3456")
                .style(size: .x18, weight: .w400)
        }
    }
}

#Preview {
    PaymentMethodCellView()
}
