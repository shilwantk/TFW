//
//  MySuperUsers.swift
//  zala
//
//  Created by Kyle Carriedo on 3/29/24.
//

import SwiftUI
import ZalaAPI

struct MySuperUsers: View {
    
    @State var service: MySuperUsersService = MySuperUsersService()
    @State var selectedItem: SegmentedValue = SegmentedValue(title:"Superusers", key: "all")
    @State var selectedSuperUser: SuperUser? = nil
    @State var selectedSuperUserOrg: SuperUserOrg? = nil
    @State var stripeService: StripeService = StripeService()
    @State var isLoading: Bool = false
    @Binding var state: SessionTransitionState
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment:.top) {
                if isLoading {
                    LoadingBannerView()
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            SegmentedControlButtonView(items: [
                SegmentedValue(title:"Superusers", key: "all"),
                SegmentedValue(title: "Zala Store", key: "store")
            ],selection: $selectedItem)
            ScrollView {
                if selectedItem.key == "all" {
                    ForEach(service.superUsers, id: \.id) { user in
                        SuperUserCellView(title: user.fullName(),
                                          subtitle: user.bio?.strippingMarkdown() ?? "",
                                          profileUrl: user.profileUrl(),
                                          tagString: user.formattedTags)
                        .onTapGesture {
                            selectedSuperUser = user
                        }
                        if user.id != service.superUsers.last?.id {
                            Divider().background(.gray)
                        }
                    }
                }
                else {
                    MarketPlaceStoreView()
                }
            }
        }
        .navigationDestination(item: $selectedSuperUser, destination: { user in
            if let superUserId = user.id, let org = user.myOrg?.id {
                MarketPlaceDetailView(superUserOrgId: org,
                                      superUser: user,
                                      isSubscribed: stripeService.isSubscribed(superuserId: superUserId)).environment(stripeService)
            }
        })
        .toolbarWith(title: "MARKETPLACE", session: $state, completion: { type in })
        .task {
            updateLoading()
            stripeService.getCustomer()
            stripeService.fetchCustomerSubscriptions(status: .active) { complete in
                service.browseAllSuperUsers(orgId: .zalaOrg)
                updateLoading()
            }
        }
    }
    
    fileprivate func updateLoading() {
        withAnimation {
            isLoading.toggle()
        }
    }
}
