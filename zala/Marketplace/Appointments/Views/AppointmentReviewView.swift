//
//  AppointmentReviewView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI
import ZalaAPI
import SDWebImageSwiftUI

extension MarketplaceAppointmentService {
    var apptType: AppointmentType {
        if isTravel() {
            return .travel
        } else if isVirtual() {
            return .virtual
        } else {
            return .inPerson
        }
    }
}

struct AppointmentReviewView: View {
    @State var superUser: SuperUser
    @State var appointment: MarketplaceAppointmentService
    @State var selectedTime: Date
    @State var addressRequest: AddressRequest?
    @State var additionalInfoRequest: AdditionalInfoRequest?
    @State var didComplete: Bool = false
    @State var notificationService: NotificationService = NotificationService()
    @State var stripeService: StripeService = StripeService()
    @State private var showEventEditView: Bool = false
    @State private var showMaps: Bool = false
    @State private var isLoading: Bool = false
    
    @State private var address: String = ""
    
    @Environment(AppointmentService.self) var service
    @Environment(\.dismiss) var dismiss
    
    let topBottomPadding:CGFloat = 8.0
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment:.top) {
                if isLoading {
                    LoadingBannerView()
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            Text("Please confirm your appointment.")
                .style(size:.x18, weight: .w400)
            VStack(alignment: .leading) {
                ScrollView {
                    
                    appointmentCell().padding([.top, .bottom])
                    
                    buildType().padding([.top, .bottom])
                    
                    VStack(alignment: .leading) {
                        Text("Superuser")
                            .style(size:.x22, weight: .w800)
                        PersonCellView(url: superUser.profileUrl(),
                                       title:superUser.fullName())
                    }.padding([.top, .bottom])
                    
                    VStack(alignment: .leading) {
                        Text(appointment.isTravel() ? "Suggested Date & Time" : "Date & Time")
                            .style(size:.x22, weight: .w800)
                        BookTimeCellView(viewOnly: true, bookDate: selectedTime)
                    }
                    .padding([.top, .bottom])
                    .onTapGesture {
                        showEventEditView.toggle()
                    }
                    
                    if let addressRequest {
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
                        }
                        .padding([.top, .bottom])
                        .onTapGesture {
                            self.address = "\(addressRequest.street)\n\(addressRequest.city) \(addressRequest.state.title) \(addressRequest.zipcode)"
                            showMaps.toggle()
                        }
                    }
                    if let additionalInfoRequest, !additionalInfoRequest.info.isEmpty {
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
            StandardButton(title: "CONFIRM REQUEST - \(appointment.formattedPrice())") {
                if let product = appointment.stripeProduct() {
                    showLoading()
                    stripeService.purchaseAndSubscribe(stripeProduct: product, type: .simple)
                } else {
                    //most likely free.
                    book()
                }
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $didComplete) {
            AppointmentConfirmationView(type: appointment.apptType).environment(service)
        }
        .sheet(isPresented: $showEventEditView, content: {
            EventEditViewController(eventData: .appointment(appointment: appointment, selectedTime: selectedTime, additionalInfoRequest: additionalInfoRequest, travelAddress: service.optionalTravelAddress()))
        })
        .showMap(showMapOption: $showMaps, address: $address, name: "Appointment location")
        .fullScreenCover(item: .constant(stripeService.checkoutSession), onDismiss: {
            stripeService.checkoutSession = nil
        }, content: { session in
            NavigationStack {
                WebView(url: URL(string: session.url)!)
                    .navigationTitle("Checkout")
                    .toolbar(content: {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {
                                stripeService.checkoutSession = nil
                                book()
                            }, label: {
                                Image.close
                            })
                        }
                    })
            }
        })
    }
    
    fileprivate func showLoading() {
        withAnimation(Animation.easeIn(duration: TimeInterval(0.3))) {
            isLoading.toggle()
        }
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
                    Text(appointment.formattedTitle())
                        .style(size: .regular, weight: .w500)
                    VStack(alignment: .leading) {
                        Text(appointment.formattedPrice())
                            .style(color: Theme.shared.grayStroke, size: .small, weight: .w400)
                        Text(appointment.duration())
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
                self.address = service.travelAddress()
                showMaps.toggle()
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
                self.address = appointment.getAddress(type: .main)?.formattedAddressNewLines() ?? ""
                showMaps.toggle()
            }
        }
    }
    
    func book() {
        service.createAppointment(groupId: service.selectedGroup?.groupId,
                                  superUser: superUser,
                                  appointment: appointment,
                                  selectedTime: selectedTime,
                                  addressRequest: addressRequest,
                                  additionalInfoRequest: additionalInfoRequest) { apptId in
            
            if let apptId {
                let subject: String =  appointment.isTravel() ? .newTravelAppointment : .newAppointment
                notificationService.createNotification(receiverId: superUser.id!, subject: subject, content: ["apptId": apptId])
                isLoading.toggle()
                didComplete.toggle()
            } else {
                isLoading.toggle()
            }
        }
    }
}
