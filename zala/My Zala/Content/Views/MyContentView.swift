//
//  MyContentView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/29/24.
//

import SwiftUI
import AVKit

struct ZalaContentView: View {
    
    var service: ContentService = ContentService()
    @State var stripeService: StripeService = StripeService()
    @State var selectedItem: SegmentedValue = SegmentedValue(title:"Browse All", key: "browse")
    @State var superUserId: String? = nil
    
    var body: some View {
        VStack(alignment: .center) {
            if superUserId == nil {
                SegmentedControlButtonView(items: [
                    SegmentedValue(title:"Browse All", key: "browse"),
                    SegmentedValue(title:"For You", key: "you")],
                                           selection: $selectedItem).padding([.leading, .trailing])
            }
            if service.content.isEmpty {
                ZalaEmptyView(title: "No Content")
            } else {
                ScrollView {
                    ForEach(service.content, id:\.contentId) { content in
                        ContentCellView(content: content, liked: content.liked ?? false)
                            .environment(service)
                            .padding()
                        if service.content.last?.id != content.id {
                            Divider().background(.gray)
                                .padding([.bottom, .top])
                        }
                    }
                }
            }
        }
        .onFirstAppear {
            stripeService.fetchCustomerSubscriptions(status: .active, handler: { complete in
                
            })
        }
        .task {
            if let superUserId {
                service.getContentFor(superUserId: superUserId)
            } else {
                service.browseAll()
            }
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            if newValue.key == "browse" {
                service.browseAll()
            } else {
                service.forYou(subscribers: Array(stripeService.subscribedToIds))
            }
        }
    }
}

struct MyContentView: View {
    
    @Binding var state: SessionTransitionState
    
    var body: some View {
        ZalaContentView()
            .toolbarWith(title: "CONTENT", session: $state, completion: { type in })
    }
}
