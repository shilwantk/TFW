//
//  AdditionalInfoView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI
import ZalaAPI

struct AdditionalInfoView: View {
        
    @State var address: AddressRequest? = nil
    @State var superUser: SuperUser
    @State var appointment: MarketplaceAppointmentService
    @State var selectedTime: Date
    @Environment(AppointmentService.self) var service
    
    @State var msg: String = ""
    @State var didTapNext: Bool = false
    @State var minHeight: CGFloat = 45
    @State var isFirst: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Is there any additional information you would like to add?")
                    .style(size: .x18, weight: .w400)
                VStack(alignment: .leading, spacing: 0.0) {
                    TextEditor(text: $msg)
                        .scrollContentBackground(.hidden)
                        .background(Theme.shared.mediumBlack)
                        .frame(maxHeight: minHeight)
                }
                .frame(minHeight: minHeight)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack))
            }
            .padding([.leading, .trailing])
            Spacer()
            StandardButton(title: "CONTINUE") {
                didTapNext.toggle()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $didTapNext) {
            AppointmentReviewView(superUser: superUser, 
                                  appointment: appointment,
                                  selectedTime: selectedTime,
                                  addressRequest: address,
                                  additionalInfoRequest: AdditionalInfoRequest(info: msg))
            .environment(service)
        }
    }
}
