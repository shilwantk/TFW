//
//  AppointmentRequestPaymentMethodView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct AppointmentRequestPaymentMethodView: View {
    @State var didTapNext: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Select payment method")
            PaymentMethodCellView()
            BorderedButton(title: "+ Add new payment method")
            Divider().background(.gray)
            HStack {
               Spacer()
                SquareButton(action: $didTapNext, icon: .arrowUp, borderOnly: true)
            }
            Spacer()
        }.padding()
    }
}

#Preview {
    AppointmentRequestPaymentMethodView()
}
