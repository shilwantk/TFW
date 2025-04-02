//
//  AppointmentConfirmationView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct AppointmentConfirmationView: View {
    
    @State var type: AppointmentType
    
    @Environment(AppointmentService.self) var service
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image.checkmarkLarge
            Text(type.title)
                .style(size: .x28, weight: .w800)
            Text(type.msg)
                .style(color: Theme.shared.grayStroke, size: .regular, weight: .w400).padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            Spacer()
            StandardButton(title: "RETURN TO SUPERUSER APPOINTMENTS") {
                service.dismissView.toggle()
            }
        }
        .navigationBarBackButtonHidden()
        .padding()
    }
}
