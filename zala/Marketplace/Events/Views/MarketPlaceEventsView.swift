//
//  MarketPlaceEventsView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI

struct MarketPlaceEventsView: View {
    @State var service: EventService = EventService()
    @Binding var isSubscribed: Bool
    @Binding var state: SessionTransitionState
    var body: some View {
        VStack {
            ZStack(alignment:.top) {
                if service.isLoading {
                    LoadingBannerView()
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            if service.events.isEmpty {
                ZalaEmptyView(icon: .emptyEvents, title: "No Events", msg: "This SuperUser does not have any events coming up at the moment.")
            } else {
                ScrollView {
                    ForEach(service.events, id: \.self) { event in
                        NavigationLink {
                            EventDetailView(event: event)
                        } label: {
                            EventCellView(event: event)
                        }
                    }
                }
            }
            Spacer()
            if !isSubscribed {
                SubscriptionButtonView(superUser: .previewUser, isSubscribed: $isSubscribed)
            }
        }
        .toolbarWith(title: "EVENTS", session: $state)
        .task {
            service.globalEvents()
        }
    }
}
