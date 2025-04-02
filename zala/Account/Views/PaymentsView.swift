//
//  PaymentsView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct PaymentsView: View {
    @State var isEmpty: Bool = true
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Spacer()
            Image.paymentIcon
            Text("There are no payment methods listed.")
                .style(color: Theme.shared.placeholderGray, weight: .w400)
                .multilineTextAlignment(.center)
            StandardButton(title: "+ Add Payment Method", height: 44).padding([.leading, .trailing])
            Spacer()
        }
    }
}

#Preview {
    PaymentsView()
}
