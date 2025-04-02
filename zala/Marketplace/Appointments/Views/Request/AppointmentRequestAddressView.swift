//
//  AppointmentRequestAddressView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI
import ZalaAPI

struct AdditionalInfoRequest {
    var info: String
}

struct AddressRequest {
    var street: String
    var street2: String?
    var city: String
    var state: PickerItem
    var zipcode: String
    
    func formattedStreet() -> String {
        if let street2 {
            return "\(street) \(street2)"
        } else {
            return street
        }
    }
    
    func fullAddress() -> String {
        return "\(formattedStreet()) \(city) \(state.title.lowercased()) \(zipcode)"
    }
}

struct AppointmentRequestAddressView: View {
    
    @State var superUser: SuperUser
    @State var appointment: MarketplaceAppointmentService
    @State var selectedTime: Date
    @Environment(AppointmentService.self) var service
    
    @State var didTapNext: Bool =  false
    
    @State var street: String = ""
    @State var street2: String = ""
    @State var city: String = ""
    @State var state: PickerItem = PickerItem(title: "Florida", key: "fl")
    @State private var stateItems: [PickerItem] = [PickerItem(title: "Florida", key: "fl")]
    @State var zipcode: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Travel Appointment")
                .style(size:.x22, weight: .w700)
                .underline().padding(.bottom, 10)
            Text("Where would you like the appointment to take place? Please specify an address.")
                .style(size:.x18, weight: .w400)
            VStack(alignment: .leading, spacing: 8) {
                KeyValueField(key: "Street 1", value: $street, placeholder: "Enter Street 1")
                KeyValueField(key: "Apt or Suite #", value: $street2, placeholder: "Enter apt or suite # (optional)")
                KeyValueField(key: "City", value: $city, placeholder: "Enter city")
                DropDownView(selectedOption: $state, items: $stateItems)
                KeyValueField(key: "Zip Code", value: $zipcode, placeholder: "Enter zip code")
            }
            Spacer()
            StandardButton(title: "Continue") {
                didTapNext.toggle()
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $didTapNext) {
            AdditionalInfoView(address: AddressRequest(street: street,
                                                       street2: street2,
                                                       city: city,
                                                       state: state,
                                                       zipcode: zipcode),
                               superUser: superUser,
                               appointment: appointment,
                               selectedTime: selectedTime,
                               minHeight: 350)
            .environment(service)
        }
    }
}
