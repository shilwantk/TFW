//
//  MarketPlaceSubscriptions.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI
import ZalaAPI

struct MarketPlaceSubscriptions: View {
    @State var superUser: SuperUser
    @Environment(\.dismiss) var dismiss
    @State var service: StripeService = StripeService()
    @State var accountService: AccountService = AccountService()
    @Binding var didComplete: Bool
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(service.subscriptions, id:\.id) { sub in
                    NavigationLink {
                        SubscriptionDetailView(superUser: superUser,
                                               product: sub,
                                               url: service.urlFor(product: sub),
                                               didComplete: $didComplete)
                        .environment(service)
                    } label: {
                        SubscriptionCellView(product: sub,
                                             url: service.urlFor(product: sub),
                                             isCurrentSubscription: service.isCurrent(sub))
                    }
                }
            }
        }
        .onChange(of: didComplete, { oldValue, newValue in
            didComplete = newValue
            dismiss()
        })
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Select Subscription")
                        .style(color:.white, size:.regular, weight: .w800)
                    Text(superUser.fullName())
                        .style(color: Theme.shared.lightBlue,
                               size:.small, weight: .w400)
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    dismiss()
                } label: {
                    Image.close
                }
            }
        })
        .task {
            service.fetchCustomerSubscriptions(status: .active) { complete in
                service.allAttachmentsFor(superUser: superUser.id!, handler: { complete in
                    service.stripeProductsFor(superUser: superUser.id!, category: .subscription)
                })
            }
            
            accountService.fetchAccount { complete in
                guard let account = accountService.account else { return }
                if !account.hasStripeCustomerId() {
                    createCustomer() //what happens if the member has not created there stripe account? where do we collect address?
                }
            }
        }
        .onOpenURL { url in
            handleURL(url: url)
        }
    }
    
    private func handleURL(url: URL) {
        switch url.host {
        case "post": break
            
        default:
            break
        }
    }
    
    fileprivate func createCustomer() {
        //if member is not strip
        accountService.fetchAccount { complete in
            guard let name = accountService.account?.fullName else { return }
            guard let email = accountService.account?.formattedEmail() else { return }
            guard let phone = accountService.account?.formattedPhone() else { return }
            guard let userId = accountService.account?.id else { return }
            service.createCustomer(name: name, email: email, phone: phone) { customer in
                if let id = customer?.id {
                    accountService.addPreference(userId: userId, input: PreferenceInput(key: .stripeCustomerId, value: [id])) { complete in                        
                    }
                }
            }
        }
    }
}
