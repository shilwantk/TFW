//
//  AppointmentDetailsView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import ZalaAPI
import Observation

struct AppointmentCellTypeView: View {
    enum AppointmentType {
        case inperson
        case travel
        case virutal
        case none
        
        func title() -> String {
            switch self {
            case .inperson: return "in person"
            case .travel: return "travel"
            case .virutal: return "virtual"
            case .none: return "in person"
            }
        }
        
        func image() -> Image {
            switch self {
            case .inperson: return .locationMini
                
            case .travel:  return .travel
                
            case .virutal:  return .video
                
            case .none:  return .locationMini
            }
        }
        
        func color() -> Color {
            switch self {
            case .inperson: return Theme.shared.lightBlue
            case .travel: return Theme.shared.placeholderGray
            case .virutal: return Theme.shared.placeholderGray
            case .none: return Theme.shared.lightBlue
            }
        }
    }
    
    @State var type: AppointmentType = .inperson
    @State var address: String
    @State var cost: String
    @State var duration: String
    @State var subs: [String]
    @Binding var isSubscribed: Bool
    
    var onTapped: (() -> Void)?
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                type.image()
                Text(type.title().capitalized)
                    .style(size:.regular, weight: .w500)
                Spacer()
                Text("\(duration) | \(cost)")
                    .style(size:.small, weight: .w400)
            }
            Text(address)
                .style(color: type.color(), size: .regular, weight: .w400)
                .lineLimit(nil)
                .underline(type == .inperson)
                .italic(type != .virutal)
            if !subs.isEmpty {
                Text("Subscriptions: \(subs.joined(separator: ","))")
                    .style(size:.small, weight: .w400)
            }
            if isSubscribed {
                BorderedButton(title: "BOOK APPOINTMENT", titleColor: Theme.shared.zalaGreen, color: Theme.shared.zalaGreen) {
                    onTapped?()
                }
            } else {
                StandardButton(title: "Subscription Needed",
                               titleColor: Theme.shared.orange,
                               color: Theme.shared.baseSlate,
                               leftIcon: .lockFill)
            }
        }
    }
}

struct AppointmentDetailsView: View {
    
    @State var superUser: SuperUser
    @State var group: AppointmentGroup
    
    @State var showBookingview: Bool = false
    @State var showAppointments: Bool = true
    @Binding var isSubscribed: Bool
    @State var services: [String] = []
    @State private var subscriptions: [String] = []
    
    
    @Environment(AppointmentService.self) private var appointmentService
    @Environment(StripeService.self) private var stripeService
    @State private var selectedService: MarketplaceAppointmentService? = nil
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ScrollView {
                BannerView(url: group.banner)
                MetaView(itemOne: MetaItem(title: "Cost", subtitle: group.formattedCost(), image: .dollarSign),
                         itemTwo: MetaItem(title: "Duration", subtitle: group.formattedDuration(), image: .clockRoutine),
                         itemThree: MetaItem(title: "Type", subtitle: "\(group.types.count)", image: .location))
                DescriptionView(desc: group.desc).padding([.leading, .trailing])
                VStack {
                    HStack {
                        Text("Appointment Types")
                            .style(color: .white, size: .x18, weight: .w700)
                        Spacer()
                        Image.arrowUp
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 27)
                            .rotationEffect(.degrees(showAppointments ? 0 : 180))
                    }
                    .padding(.bottom)
                    .onTapGesture {
                        withAnimation {
                            showAppointments.toggle()
                        }
                    }
                    if showAppointments {
                        VStack(spacing: 8) {
                            ForEach(group.services, id: \.self) { service in
                                if service.isTravel() {
                                    AppointmentCellTypeView(type:.travel,
                                                            address: service.formattedTravelDistance(),
                                                            cost: service.formattedPrice(),
                                                            duration: service.duration(),
                                                            subs: stripeService.subscriptionsFor(service: group.groupId),
                                                            isSubscribed: $isSubscribed) {
                                        handleSelection(service: service)
                                    }
                                }
                                if service.isVirtual() {
                                    AppointmentCellTypeView(type:.virutal,
                                                            address: "URL link will be provided before appointment",
                                                            cost: service.formattedPrice(),
                                                            duration: service.duration(),
                                                            subs: stripeService.subscriptionsFor(service: group.groupId),
                                                            isSubscribed: $isSubscribed) {
                                        handleSelection(service: service)
                                    }
                                }
                                ForEach(service.addresses, id: \.self) { address in
                                    AppointmentCellTypeView(address: address.fragments.addressModel.formattedAddressNewLines(),
                                                            cost: service.formattedPrice(),
                                                            duration: service.duration(),
                                                            subs: stripeService.subscriptionsFor(service: group.groupId),
                                                            isSubscribed: $isSubscribed) {
                                        handleSelection(service: service)
                                    }
                                }
                            }
                            .padding(5)
                        }
                    }
                }.padding([.leading, .trailing, .top])
            }
            if !isSubscribed {
                SubscriptionButtonView(superUser: superUser, isSubscribed: $isSubscribed)
                .padding()
            }
        }
        .navigationTitle(group.title)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $selectedService, onDismiss: {
            selectedService = nil
        }, content: { apt in
            NavigationStack {
                BookAppointmentView(superUser: superUser, selection: apt)
                    .environment(appointmentService)
            }
        })
        .onAppear {
            appointmentService.selectedGroup = group
        }
    }
    
    fileprivate func handleSelection(service: MarketplaceAppointmentService) {
        if isSubscribed {
            self.selectedService = service
        }
    }
}
