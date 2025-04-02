//
//  AppointmentTimesView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/4/24.
//

import SwiftUI
import ZalaAPI

struct AppointmentTimesView: View {
    
    @State var slots: [Date]
    @State var selectedTime: Date = .now
    @State var superUser: SuperUser
    @State var appointment: MarketplaceAppointmentService
    @Environment(AppointmentService.self) var service
    @State var didTapNext: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading) {            
            Text("Select a time slot for:")
                .style(size: .x19, weight: .w400)
            Text(selectedDate())
                .style(color:Theme.shared.lightBlue, size: .x19, weight: .w400)
            ScrollView {
                ForEach(slots, id: \.self) { date in
                    SelectionCellView(label: DateFormatter.timeOnly(date: date), isSelected: .constant(selectedTime == date)).onTapGesture {
                        selectedTime = date
                    }
                }
            }
            Spacer()
            StandardButton(title: "Continue") {
                didTapNext.toggle()
            }.padding()
        }
        .padding()
        .navigationDestination(isPresented: $didTapNext) {
            if appointment.isTravel() {
                AppointmentRequestAddressView(superUser: superUser,
                                              appointment: appointment,
                                              selectedTime: selectedTime)
                .environment(service)
            } else {
                AdditionalInfoView(superUser: superUser,
                                   appointment: appointment,
                                   selectedTime: selectedTime,
                                   minHeight: 350)
                .environment(service)
            }
        }
//        VStack {
//            Text("BOOK APPOINTMENT")
//                .style(color: Theme.shared.lightBlue, size: .x18, weight: .w700)
//           
//            
//        }
        .navigationTitle("BOOK APPOINTMENT")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    fileprivate func selectedDate() -> String {
        guard let date = slots.first else { return "" }
        return date.formatted(date: .complete, time: .omitted)
    }
}
