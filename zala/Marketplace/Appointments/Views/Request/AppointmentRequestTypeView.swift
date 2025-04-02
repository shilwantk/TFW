//
//  AppointmentRequestTypeView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct AppointmentRequestTypeView: View {
    
    @State var didTapDown: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading,spacing: 20) {
                AppointmentRequestTypeCellView()
                AppointmentRequestTypeCellView(subtitle: "890 Sunrise Blvd, Suite 404\nSunrise, FL 33100")
                AppointmentRequestTypeCellView(title: "Zala Hub West Palm", subtitle: "9849 Leonard Blvd, Suite 555\nSunrise, FL 33100")
                AppointmentRequestTypeCellView(title: "Travel", subtitle: "Suggest a location", price: "$400", duration: "120m", isSelected: true)
                AppointmentRequestTypeCellView(title: "Tele-visit / Remote", subtitle: "We can meet online", price: "$60", duration: "30m")
                Divider().background(.gray).padding(.top)
                HStack {
                    Spacer()
                    SquareButton(action: $didTapDown, color: Theme.shared.blue)
                }                
            }
        }
    }
}

#Preview {
    AppointmentRequestTypeView()
}
