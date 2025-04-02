//
//  MarketPlaceDetailView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import ZalaAPI

struct MarketPlaceDetailView: View {
    @State var superUserOrgId: String
    @State var superUser: SuperUser
    @State var isSubscribed: Bool = false
    @Environment(StripeService.self) var service
    
    @State private var items: [SegmentedItem] = [
        SegmentedItem(title:"Profile", key: .profile),
        SegmentedItem(title:"Content", key: .content),
        SegmentedItem(title:"Routines", key: .routine),
        SegmentedItem(title:"Appointments", key: .appointment)        
    ]
//    SegmentedItem(title:"Events", key: .events),
//
    
    @State private var selectedItem: SegmentedItem = .default
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedItem) {
                ForEach(items, id: \.key) { item in
                    Text(item.title).tag(item)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing], 8)
            .padding([.bottom, .top])
//            SegmentedControlView(items: items, selection: $selectedItem)
//                .padding()
            showView(item: selectedItem)
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(superUser.fullName())
        .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    fileprivate func showView(item: SegmentedItem) -> some View {
        switch item.key {
        case .profile:
            SuperUserProfileView(superUser: superUser, isSubscribed: $isSubscribed)
        case .content:
            MarketPlaceContentView(superUser: superUser, isSubscribed: $isSubscribed)
        case .routine:
            MarketPlaceRoutinesView(superUserOrgId: superUserOrgId, superUser: superUser, isSubscribed: $isSubscribed)
        case .appointment:
            MarketPlaceAppointmentsView(superUser: superUser, superUserOrgId: superUserOrgId, isSubscribed: $isSubscribed)
        case .events:
            EmptyView()
//            MarketPlaceEventsView(isSubscribed: $isSubscribed)
        case .store:
            MarketPlaceStoreView()
        case .none:
            SuperUserProfileView(superUser: superUser, isSubscribed: $isSubscribed)
        }
    }
}

