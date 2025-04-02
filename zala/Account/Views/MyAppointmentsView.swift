//
//  MyAppointmentsView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/4/24.
//

import SwiftUI
import ZalaAPI
import SDWebImageSwiftUI

struct MyAppointmentsView: View {
    
    @Environment(AccountService.self) var accountService
    
    var body: some View {
        ScrollView {
            ForEach(Array(accountService.personAppointmentsByStatus.keys), id: \.self) { status in
                LazyVStack(alignment: .leading) {
                    Text(status.capitalized)
                        .style(size: .x19, weight: .w700).padding(.leading)
                    ForEach((accountService.personAppointmentsByStatus[status] ?? []), id: \.self) { appointment in
                        NavigationLink {
                            MyAppointmentDetailView(appointment: appointment)
                        } label: {
                            HStack {
                                iconView(service: appointment.appointmentService())
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(appointment.appointmentService()?.formattedTitle() ?? "")
                                        .style(size: .regular, weight: .w500)
                                    VStack(alignment: .leading) {
                                        HStack{
                                            Text(appointment.formattedProvider())
                                                .style(color: Theme.shared.grayStroke, size: .small, weight: .w400)
                                            Text("|")
                                                .style(color: Theme.shared.grayStroke, size: .small, weight: .w400)
                                            Text(appointment.formattedStatus().capitalized)
                                                .style(color: appointment.statusColor(), size: .small, weight: .w400)
                                        }
                                        Text(appointment.formattedTime())
                                            .style(color: Theme.shared.grayStroke, size: .small, weight: .w400)
                                    }
                                }
                                Spacer()
                            }
                            .frame(minHeight: 55)
                            .padding([.leading, .trailing])
                        }
                    }
                }
                .navigationTitle("APPOINTMENTS & EVENTS")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    fileprivate func iconView(service: MarketplaceAppointmentService?) -> some View {
        WebImage(url: URL(string: service?.banner() ?? "")) { img in
            img
                .resizable()
                .interpolation(.medium)
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth:96, maxHeight: 48, alignment: .center)
        } placeholder: {
            Image.routinePlaceholder
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth:96, maxHeight: 48, alignment: .center)
        }
    }
}
