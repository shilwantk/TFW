//
//  MyAppointmentDetailView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/4/24.
//

import SwiftUI
import ZalaAPI
import SDWebImageSwiftUI
//
struct MyAppointmentNotificationView: View {
    var apptId: String
    
    @State var showAlert: Bool = false
    @State var showMapOption: Bool = false
    @State var selectedAddress: String = ""
    
    @State var notificationService: NotificationService = NotificationService()
    
    @State var service: AppointmentService = AppointmentService()
    
    let topBottomPadding:CGFloat = 8.0
    
    @State private var showEventEditView: Bool = false
    @State private var showMaps: Bool = false
    @State private var address: String = ""
    @State var appointment: PersonAppointment?
    
    @State private var fullName: String = ""
    @State private var url: String? = nil
    
    @Environment(\.dismiss) var dismiss
    var onComplete: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                ScrollView {
                    
                    appointmentCell().padding([.top, .bottom])
                    
                    buildType().padding([.top, .bottom])
                    
                    VStack(alignment: .leading) {
                        Text("Superuser")
                            .style(size:.x22, weight: .w800)
                        SUPersonCellView(
                            url: $url,
                            title: $fullName)
                    }.padding([.top, .bottom])
                    
                    if let schedule = appointment?.scheduleDate()  {
                        VStack(alignment: .leading) {
                            Text(appointment?.isTravel() ?? false ? "Suggested Date & Time" : "Date & Time")
                                .style(size:.x22, weight: .w800)
                            BookTimeCellView(viewOnly: true, bookDate: schedule)
                        }
                        .padding([.top, .bottom])
                        .onTapGesture {
                            showEventEditView.toggle()
                        }
                    }
                    
                    if let addressRequest = appointment?.addressRequest() {
                        VStack(alignment: .leading) {
                            Text("Suggested Address")
                                .style(size:.x22, weight: .w800)
                            VStack(alignment: .leading) {
                                Text("Entered Address")
                                    .style(size: .regular, weight: .w500)
                                Text("\(addressRequest.street)\n\(addressRequest.city) \(addressRequest.state.title) \(addressRequest.zipcode)")
                                    .style(color: Theme.shared.lightBlue, size: .regular, weight: .w400)
                                    .italic()
                            }
                            .padding([.top, .bottom], topBottomPadding)
                            .frame(maxWidth: .infinity, minHeight: 55, alignment: .leading)
                            .padding([.leading, .trailing])
                            .background(
                                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
                            )
                            .onTapGesture {
                                selectedAddress = addressRequest.fullAddress()
                                showMapOption.toggle()
                            }
                        }.padding([.top, .bottom])
                    }
                    if let additionalInfoRequest = appointment?.additionalInfoRequest()  {
                        VStack(alignment: .leading) {
                            Text("Additional Information")
                                .style(size:.x22, weight: .w800)
                            VStack(alignment: .leading) {
                                Text(additionalInfoRequest.info)
                                    .style(size: .regular, weight: .w400)
                                    .lineLimit(nil)
                            }
                            .padding([.top, .bottom], topBottomPadding)
                            .frame(maxWidth: .infinity, minHeight: 55, alignment: .leading)
                            .padding([.leading, .trailing])
                            .background(
                                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
                            )
                        }.padding([.top, .bottom])
                    }
                }
            }
            Spacer()
            VStack {
                if !(appointment?.isPast ?? false) {
                    if appointment?.isVirtual() ?? false {
                        StandardButton(title: "JOIN VIDEO SESSION", rightIcon: .virtualVisit) {
                            
                        }
                        .disabled(true)
                        .opacity(0.3)
                    }
                    BorderedButton(title: "CANCEL", titleColor: Theme.shared.orange, color: Theme.shared.orange) {
                        showAlert.toggle()
                    }
                }
            }
        }
        .padding()
        .navigationTitle("APPOINTMENT DETAILS")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cancel Appointment?", isPresented: $showAlert) {
            Button(role: .destructive) {
                // Handle the deletion.
                if let id = appointment?.id {
                    service.cancelAppointment(id: id)
                }
            } label: {
                Text("Yes, Cancel")
            }
            Button(role: .cancel) {
                // Handle the deletion.
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("Are you sure you want to cancel the appointment? This action will cancel your existing appointment, and you could potentially be charged a cancellation fee.")
        }
        .showMap(showMapOption: $showMapOption, address: $selectedAddress, name: appointment?.formattedServiceTitle() ?? "")
        .onAppear(perform: {
            service.fetchAppointmentByService(apptId: apptId) { personAppointment in
                self.appointment = personAppointment
                self.fullName = personAppointment?.formattedProvider() ?? ""
                self.url =  personAppointment?.formattedProviderProfile()
            }
        })
        .onChange(of: service.didUpdateAppointment, { oldValue, newValue in
            self.sendNotification()
        })
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    dismiss()
                } label: {
                    Image.close
                }
            }
        }
        .sheet(isPresented: $showEventEditView, content: {
            if let appointment {
                EventEditViewController(eventData: .personAppointment(appointment: appointment,
                                                                      selectedTime: appointment.scheduleDate(),
                                                                      additionalInfoRequest: appointment.additionalInfoRequest(),
                                                                      travelAddress: service.optionalTravelAddress()))
            } else {
                ZalaEmptyView(title: "Not Appointment Found")
            }
        })
    }
    
    fileprivate func iconView() -> some View {
        WebImage(url: URL(string: appointment?.banner() ?? "")) { img in
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
    
    fileprivate func appointmentCell() -> some View {
        VStack(alignment: .leading) {
            Text("Appointment")
                .style(size:.x22, weight: .w800)
            HStack {
                iconView()
                VStack(alignment: .leading, spacing: 6) {
                    Text(appointment?.formattedServiceTitle() ?? "")
                        .style(size: .regular, weight: .w500)
                    VStack(alignment: .leading) {
                        Text(appointment?.formattedServicePrice() ?? "")
                            .style(color: Theme.shared.grayStroke, size: .small, weight: .w400)
                        Text(appointment?.formattedServiceDuration() ?? "")
                            .style(color: Theme.shared.grayStroke, size: .small, weight: .w400)
                    }
                }
                .padding([.top, .bottom], topBottomPadding)
                Spacer()
            }
            .frame(minHeight: 55)
            .padding([.leading, .trailing])
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
        }
    }
    
    @ViewBuilder
    fileprivate func buildType() -> some View {
        if appointment?.isTravel() ?? false {
            HStack {
                Image.travelType
                VStack(alignment: .leading) {
                    Text("Travel")
                        .style(size: .regular, weight: .w500)
                    Text(service.travelAddress())
                        .style(color:Theme.shared.placeholderGray, size: .small, weight: .w400)
                }
                .padding([.top, .bottom], topBottomPadding)
                Spacer()
            }
            .frame(minHeight: 55)
            .padding([.leading, .trailing])
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
            .onTapGesture {
                selectedAddress = service.travelAddress()
                showMapOption.toggle()
            }
        } else if appointment?.isVirtual() ?? false {
            HStack {
                Image.virtualType
                VStack(alignment: .leading) {
                    Text("Virtual Appointment")
                        .style(size: .regular, weight: .w500)
                    Text("URL link will be provided before appointment")
                        .style(size: .regular, weight: .w400)
                        .italic()
                }
                .padding([.top, .bottom], topBottomPadding)
                Spacer()
            }
            .frame(minHeight: 55)
            .padding([.leading, .trailing])
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
        } else {
            //
            HStack(alignment: .top) {
                Image.locationType.padding(.top, 8)
                VStack(alignment: .leading, spacing: 6) {
                    Text("In Person")
                        .style(size: .regular, weight: .w500)
                    Text(appointment?.getAddress(type: .main)?.formattedAddressNewLines() ?? "")
                        .style(color:Theme.shared.lightBlue, size: .regular, weight: .w400)
                        .underline()
                }
                .padding([.top, .bottom], topBottomPadding)
                Spacer()
            }
            .frame(minHeight: 55)
            .padding([.leading, .trailing])
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
            .onTapGesture {
                selectedAddress = appointment?.getAddress(type: .main)?.formattedAddressNewLines() ?? ""
                showMapOption.toggle()
            }
            
        }
    }
    
    //MARK: - Notifications
    fileprivate func sendNotification() {
        guard let providerId = appointment?.provider?.id else { return }
        guard let userName = Network.shared.account?.fullName else { return }
        guard let apptId = appointment?.id else { return }
        let title = appointment?.formattedServiceTitle() ?? ""
        let scheduleDate = appointment?.formattedDateAndTime() ?? ""
        let subject = "\(userName) has cancelled the \(title) session scheduled for \(scheduleDate)"
        notificationService.createNotification(receiverId: providerId, subject: subject, content: ["apptId": apptId])
        dismiss()
        onComplete?()
    }
}

struct MyAppointmentDetailView: View {
    @State var appointment: PersonAppointment
    
    @State var showAlert: Bool = false
    @State var showMapOption: Bool = false
    @State var selectedAddress: String = ""
    
    @State var notificationService: NotificationService = NotificationService()
    
    @State var service: AppointmentService = AppointmentService()
    
    let topBottomPadding:CGFloat = 8.0
    
    @State private var showEventEditView: Bool = false
    @State private var showMaps: Bool = false
    @State private var address: String = ""
    
    @Environment(\.dismiss) var dismiss
    var onComplete: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                ScrollView {
                    
                    appointmentCell().padding([.top, .bottom])
                    
                    buildType().padding([.top, .bottom])
                    
                    VStack(alignment: .leading) {
                        Text("Superuser")
                            .style(size:.x22, weight: .w800)
                        PersonCellView(
                            url: appointment.formattedProviderProfile(),
                            title: appointment.formattedProvider())
                    }.padding([.top, .bottom])
                    
                    VStack(alignment: .leading) {
                        Text(appointment.isTravel() ? "Suggested Date & Time" : "Date & Time")
                            .style(size:.x22, weight: .w800)
                        BookTimeCellView(viewOnly: true, bookDate: appointment.scheduleDate())
                    }
                    .padding([.top, .bottom])
                    .onTapGesture {
                        showEventEditView.toggle()
                    }
                    
                    if let addressRequest = appointment.addressRequest() {
                        VStack(alignment: .leading) {
                            Text("Suggested Address")
                                .style(size:.x22, weight: .w800)
                            VStack(alignment: .leading) {
                                Text("Entered Address")
                                    .style(size: .regular, weight: .w500)
                                Text("\(addressRequest.street)\n\(addressRequest.city) \(addressRequest.state.title) \(addressRequest.zipcode)")
                                    .style(color: Theme.shared.lightBlue, size: .regular, weight: .w400)
                                    .italic()
                            }
                            .padding([.top, .bottom], topBottomPadding)
                            .frame(maxWidth: .infinity, minHeight: 55, alignment: .leading)
                            .padding([.leading, .trailing])
                            .background(
                                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
                            )
                            .onTapGesture {
                                selectedAddress = addressRequest.fullAddress()
                                showMapOption.toggle()
                            }
                        }.padding([.top, .bottom])
                    }
                    if let additionalInfoRequest = appointment.additionalInfoRequest()  {
                        VStack(alignment: .leading) {
                            Text("Additional Information")
                                .style(size:.x22, weight: .w800)
                            VStack(alignment: .leading) {
                                Text(additionalInfoRequest.info)
                                    .style(size: .regular, weight: .w400)
                                    .lineLimit(nil)
                            }
                            .padding([.top, .bottom], topBottomPadding)
                            .frame(maxWidth: .infinity, minHeight: 55, alignment: .leading)
                            .padding([.leading, .trailing])
                            .background(
                                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
                            )
                        }.padding([.top, .bottom])
                    }
                }
            }
            Spacer()
            VStack {
                if !appointment.isPast {
                    if appointment.isVirtual() {
                        StandardButton(title: "JOIN VIDEO SESSION", rightIcon: .virtualVisit) {
                            
                        }
                        .disabled(true)
                        .opacity(0.3)
                    }
                    BorderedButton(title: "CANCEL", titleColor: Theme.shared.orange, color: Theme.shared.orange) {
                        showAlert.toggle()
                    }
                }
            }
        }
        .padding()
        .navigationTitle("APPOINTMENT DETAILS")
        .navigationBarTitleDisplayMode(.inline)           
        .alert("Cancel Appointment?", isPresented: $showAlert) {
            Button(role: .destructive) {
                // Handle the deletion.
                if let id = appointment.id {
                    service.cancelAppointment(id: id)
                }
            } label: {
                Text("Yes, Cancel")
            }
            Button(role: .cancel) {
                // Handle the deletion.
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("Are you sure you want to cancel the appointment? This action will cancel your existing appointment, and you could potentially be charged a cancellation fee.")
        }
        .showMap(showMapOption: $showMapOption, address: $selectedAddress, name: appointment.formattedServiceTitle())
        .onAppear(perform: {
            service.superUserAddress = appointment.travelAddress()
            service.selectedAppointment = appointment.appointmentService()
        })
        .onChange(of: service.didUpdateAppointment, { oldValue, newValue in
            self.sendNotification()
        })
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    dismiss()
                } label: {
                    Image.close
                }
            }
        }
        .sheet(isPresented: $showEventEditView, content: {
            EventEditViewController(eventData: .personAppointment(appointment: appointment,
                                                                  selectedTime: appointment.scheduleDate(),
                                                                  additionalInfoRequest: appointment.additionalInfoRequest(),
                                                                  travelAddress: service.optionalTravelAddress()))
        })
    }
    
    fileprivate func iconView() -> some View {
        WebImage(url: URL(string: appointment.banner() ?? "")) { img in
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
    
    fileprivate func appointmentCell() -> some View {
        VStack(alignment: .leading) {
            Text("Appointment")
                .style(size:.x22, weight: .w800)
            HStack {
                iconView()
                VStack(alignment: .leading, spacing: 6) {
                    Text(appointment.formattedServiceTitle())
                        .style(size: .regular, weight: .w500)
                    VStack(alignment: .leading) {
                        Text(appointment.formattedServicePrice())
                            .style(color: Theme.shared.grayStroke, size: .small, weight: .w400)
                        Text(appointment.formattedServiceDuration())
                            .style(color: Theme.shared.grayStroke, size: .small, weight: .w400)
                    }
                }
                .padding([.top, .bottom], topBottomPadding)
                Spacer()
            }
            .frame(minHeight: 55)
            .padding([.leading, .trailing])
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
        }
    }
    
    @ViewBuilder
    fileprivate func buildType() -> some View {
        if appointment.isTravel() {
            HStack {
                Image.travelType
                VStack(alignment: .leading) {
                    Text("Travel")
                        .style(size: .regular, weight: .w500)
                    Text(service.travelAddress())
                        .style(color:Theme.shared.placeholderGray, size: .small, weight: .w400)
                }
                .padding([.top, .bottom], topBottomPadding)
                Spacer()
            }
            .frame(minHeight: 55)
            .padding([.leading, .trailing])
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
            .onTapGesture {
                selectedAddress = service.travelAddress()
                showMapOption.toggle()
            }
        } else if appointment.isVirtual() {
            HStack {
                Image.virtualType
                VStack(alignment: .leading) {
                    Text("Virtual Appointment")
                        .style(size: .regular, weight: .w500)
                    Text("URL link will be provided before appointment")
                        .style(size: .regular, weight: .w400)
                        .italic()
                }
                .padding([.top, .bottom], topBottomPadding)
                Spacer()
            }
            .frame(minHeight: 55)
            .padding([.leading, .trailing])
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
        } else {
            //
            HStack(alignment: .top) {
                Image.locationType.padding(.top, 8)
                VStack(alignment: .leading, spacing: 6) {
                    Text("In Person")
                        .style(size: .regular, weight: .w500)
                    Text(appointment.getAddress(type: .main)?.formattedAddressNewLines() ?? "")
                        .style(color:Theme.shared.lightBlue, size: .regular, weight: .w400)
                        .underline()
                }
                .padding([.top, .bottom], topBottomPadding)
                Spacer()
            }
            .frame(minHeight: 55)
            .padding([.leading, .trailing])
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
            .onTapGesture {
                selectedAddress = appointment.getAddress(type: .main)?.formattedAddressNewLines() ?? ""
                showMapOption.toggle()
            }
            
        }
    }
    
    //MARK: - Notifications
    fileprivate func sendNotification() {
        guard let providerId = appointment.provider?.id else { return }
        guard let userName = Network.shared.account?.fullName else { return }
        guard let apptId = appointment.id else { return }
        let title = appointment.formattedServiceTitle()
        let scheduleDate = appointment.formattedDateAndTime()
        let subject = "\(userName) has cancelled the \(title) session scheduled for \(scheduleDate)"
        notificationService.createNotification(receiverId: providerId, subject: subject, content: ["apptId": apptId])
        dismiss()
        onComplete?()
    }
}


extension ZalaAPI.JSON {
    func addressRequest() -> AddressRequest? {        
        guard let data = self._jsonValue as? [String: AnyHashable] else { return nil }
        guard let travel = data["travel"] as? [String: Any] else { return nil }
        guard let street = travel["address"] as? String else { return nil }
        guard let city = travel["city"] as? String else { return nil }
        guard let state = travel["state"] as? String else { return nil }
        guard let zip = travel["zip"] as? String else { return nil }
        return AddressRequest(street: street, city: city, state: PickerItem(title: state, key: state), zipcode: zip)
    }
    
    func additionalInfoRequest() -> AdditionalInfoRequest? {
        guard let data = self._jsonValue as? [String: AnyHashable] else { return nil }
        guard let travel = data["travel"] as? [String: Any] else { return nil }
        guard let info = travel["info"] as? String else { return nil }
        return AdditionalInfoRequest(info: info)
    }
}
