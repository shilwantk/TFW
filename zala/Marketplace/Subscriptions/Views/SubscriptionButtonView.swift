//
//  SubscriptionButtonView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/29/24.
//

import SwiftUI
import ZalaAPI

struct SubscriptionButtonView: View {
    
    @State var superUser: SuperUser
    @Binding var isSubscribed: Bool
    
    @State private var didTapSub: Bool = false
    @State private var didTapUnSub: Bool = false
    @State private var title: String = "Subscription Packages"    
    
    @State var service: StripeService = StripeService()
    
    var body: some View {
        VStack {
            Divider().background(.gray)
            SubscriptionButton(title: $title) {
                didTapSub.toggle()
//                showConsent.toggle()
//                if isSubscribed {
//                    didTapUnSub.toggle()
//                } else {
//                    showConsent.toggle()
//                }
            }.padding()
        }        
        .fullScreenCover(isPresented: $didTapSub, content: {
            NavigationStack {
                MarketPlaceSubscriptions(superUser: superUser, didComplete: $isSubscribed)
            }
        })
        .onAppear(perform: {
//            guard let account = Network.shared.account?.roles?.compactMap({$0.orgId}) else { return }
//            guard let superUserId = superUser.id else { return }
//            service.fetchSuperUser(id: superUserId) { user in
//                if let providerId = user?.roles?.first(where: {$0.fragments.userRole.role == .provider})?.orgId {
//                    self.isSubscribed = account.contains(providerId)
//                    updateTitle()
//                }
//            }
        })
        .alert("Unsubscribe", isPresented: $didTapUnSub) {
            Button(role: .destructive) {
                // Handle the deletion.
                self.unsubscribe()
            } label: {
                Text("Yes, Unsubscribe")
            }
            Button(role: .cancel) {
                // Handle the deletion.
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("Are you sure you want to unsubscribe? This action will cancel any subscriptions you currently have, and you will lose all appointments booked.")
        }
    }
    
    fileprivate func unsubscribe() {
        service.unsubscribe(superUserId: superUser.id!) { complete in
            self.isSubscribed = false
//            updateTitle()
        }
    }
    
//    fileprivate func updateTitle() {
//        self.title = "\(isSubscribed ? "Unsubscribe" : "Subscription Packages")"
//    }
}

#Preview {
    SubscriptionButtonView(superUser: .previewUser, isSubscribed: .constant(false))
}
