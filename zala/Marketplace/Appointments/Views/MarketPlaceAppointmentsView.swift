//
//  MarketPlaceAppointmentsView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import ZalaAPI
import Observation

struct MarketPlaceAppointmentsView: View {
    var superUser: SuperUser
    var superUserOrgId: String
    @State private var service: AppointmentService = AppointmentService()
    @State private var stripeService: StripeService = StripeService()
    @Binding var isSubscribed: Bool
    @State private var isLoading: Bool = false
    @State private var services: [String] = []
    @State private var serviceLookup: [String:String] = [:]
    
    
    var body: some View {
        VStack {
            ZStack(alignment:.top) {
                if isLoading {
                    LoadingBannerView()
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            if service.groups.isEmpty {
                ZalaEmptyView(title: "No Appointments")
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(service.groups, id:\.self) { group in
                            NavigationLink {
                                AppointmentDetailsView(superUser: superUser,
                                                       group: group,
                                                       isSubscribed: .constant(services.contains(group.groupId)),
                                                       services: services)
                                    .environment(service)
                                    .environment(stripeService)
                            } label: {
                                AppointmentsCellView(banner: group.banner,
                                                     title: group.title,
                                                     duration: group.formattedDuration(),
                                                     type: group.types.joined(separator: ", ").capitalized,
                                                     cost: group.formattedCost(),
                                                     isActive: serviceLookup[group.groupId] != nil)
                            }
                        }
                    }
                }
            }
        }
        .onFirstAppear {
            fetchData(showLoader: true)
        }        
    }
    
    fileprivate func fetchData(showLoader: Bool) {
        serviceLookup = [:]
        if showLoader {
            isLoading  = true
        }
        stripeService.stripeProductsFor(superUser: superUser.id!, category: .subscription) { complete in
            stripeService.fetchCustomerSubscriptions(status: .active) { complete in
                let data = stripeService.customerSubscriptions.compactMap({$0.services}).flatMap({$0})
                self.services = data
                for item in data {
                    serviceLookup[item] = item
                }
                
                let isSubscribed = stripeService.isSubscribed(superuserId: superUser.id!)
                if complete {
                    service.fetchMarketplaceAppointmentsFor(orgId: superUserOrgId,
                                                            isSubscribed: isSubscribed,
                                                            subscriptionServices: services)
                    isLoading  = false
                }
            }
        }
    }
    
}
