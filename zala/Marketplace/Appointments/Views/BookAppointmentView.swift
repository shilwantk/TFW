//
//  BookAppointmentView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI
import ZalaAPI

struct BookTravelAppointmentView: View {
    var body: some View {
        AppointmentRequestTypeView()
    }
}

struct BookAppointmentView: View {
    
    @State var superUser: SuperUser
    @State var selection: MarketplaceAppointmentService
    @State var selectedDate: Date = Date()
    
    @Environment(AppointmentService.self) var service
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Select a day that works best for you")
                .style(size: .x18, weight: .w400)
            DateDropDownView(selectedDate: $selectedDate, 
                             dateAndTime: .constant(false))
            ScrollView {
                if let nextAvaiable = service.slots.first?.first {
                    VStack(alignment: .leading) {
                        Text("Next Available")
                            .style(size: .x22, weight: .w800)
                        appointmentSelection(selectedTime: nextAvaiable)
                    }.padding(.top)
                }
                
                if !service.slots.isEmpty {
                    VStack(alignment: .leading) {
                        Text("More Options")
                            .style(size: .x22, weight: .w800)
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(service.slots, id: \.self) { day in
                                if let dt = day.first {
                                    appointmentSelection(selectedTime: dt, times: day, showTotal: true)
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text("BOOK APPOINTMENT")
                    .style(color: Theme.shared.lightBlue, size: .x18, weight: .w700)
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image.close
                })
            }
        })
        .task {
            fetchTimesFor(date: .now)
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            if !Date.isSameMonth(date1: oldValue, date2: selectedDate) {
                fetchTimesFor(date: newValue)
            }
        }
        .onChange(of: service.dismissView) { oldValue, newValue in
            dismiss()
        }
    }
    
    fileprivate func fetchTimesFor(date: Date) {
        guard let organizationId = selection.organizationId else { return }
        guard let serviceId = selection.id else { return }
        service.fetchMoreOptions(superUserOrgId: organizationId,
                                      serviceId: serviceId,
                                      date: date,
                                      superUserId: superUser.id!)
    }
    
    @ViewBuilder
    fileprivate func appointmentSelection(selectedTime: Date, times:[Date]? = nil, showTotal: Bool = false) -> some View {
        NavigationLink {
            if let times {
                AppointmentTimesView(slots: times,
                                     selectedTime: selectedTime,
                                     superUser: superUser,
                                     appointment: selection)
                .environment(service)
            } else {
                if selection.isTravel() {
                    AppointmentRequestAddressView(superUser: superUser,
                                                  appointment: selection,
                                                  selectedTime: selectedTime)
                    .environment(service)
                } else {
                    AdditionalInfoView(superUser: superUser,
                                       appointment: selection,
                                       selectedTime: selectedTime,
                                       minHeight: 350)
                    .environment(service)
                }
            }
        } label: {
            BookTimeCellView(showTotal: showTotal,
                             bookDate: selectedTime,
                             total: times ?? [])
        }.accentColor(.white)
    }
}


extension Date {
    
    static var tomorrow:  Date { return Date().dayAfter }
    
    static var today: Date {return Date()}
    
    var dayAfter: Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: Date())!
    }
    
    var dayBefore: Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: Date())!
    }
    
    static func isSameMonth(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.autoupdatingCurrent
        let month1 = calendar.component(.month, from: date1)
        let month2 = calendar.component(.month, from: date2)
        return month1 == month2
    }
    
    func isToday() -> Bool {
        return Calendar.autoupdatingCurrent.isDateInToday(self)
    }
    
}
