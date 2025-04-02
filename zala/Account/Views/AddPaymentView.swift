//
//  AddPaymentView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct AddPaymentView: View {
    
    @State var name: String = "Allen Appleseed"
    @State var card: String = "1234 5678 8901 2345"
    @State var exp: String = "Select Expiration Date"
    @State var ccv: String = ""
    @State var zipcode: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    KeyValueField(key: "Name on Card",
                                  value: $name)
                    KeyValueField(key: "Card Number",
                                  value: $card)
                    BorderedButton(title: exp)
                    KeyValueField(key: "CCV",
                                  value: $ccv)
                    KeyValueField(key: "Zip Code",
                                  value: $zipcode)
                }.padding()
            }
            Spacer()
            Divider().background(.gray)
            StandardButton(title: "Done").padding()
        }
    }
}

#Preview {
    AddPaymentView()
}
