//
//  MySubscriptionsView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct MySubscriptionsView: View {
    @State var notificationService: NotificationService = NotificationService()
    @Environment(StripeService.self) var service
    @State var showAlert: Bool = false
    @State var selectedItem: StripeSubscription? = nil
    @State var isLoading: Bool = false
    var body: some View {
        VStack {
            ZStack(alignment:.top) {
                if isLoading {
                    LoadingBannerView()
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            if service.customerSubscriptions.isEmpty {                
                ZalaEmptyView(title: "No Subscriptions",
                              msg: "You haven't subscribed to any Super Users. Explore the marketplace to find yours!")
            }
            ScrollView {
                VStack(alignment: .leading) {
                    if service.customerSubscriptions.isEmpty {
                        
                    } else {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Active (\(service.customerSubscriptions.count))")
                                .style(size: .x19, weight: .w700)
                            ForEach(service.customerSubscriptions, id:\.id) { sub in
                                VStack {
                                    MySubscriptionCellView(plan: sub).environment(service)
                                    BorderedButton(title: "CANCEL", titleColor: Theme.shared.orange, color: Theme.shared.orange) {
                                        self.selectedItem = sub
                                        showAlert.toggle()
                                    }
                                }
                                Divider().background(.gray).padding(.bottom)
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                }
            }
        }
        .task {
            fetchData()
        }
        .navigationTitle("Subscriptions")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cancel Subscription?", isPresented: $showAlert) {
            Button(role: .destructive) {
                // Handle the deletion.
                guard let sub = self.selectedItem else { return }
                self.isLoading = true
                service.cancel(subscription: sub) { complete in
                    self.sendNotification(sub: sub)
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
            Text("Are you sure you want to cancel the subscription? This action will terminate your existing subscription, and you will no longer receive all discounts and benefits that are part of this subscription plan.")
        }
        .onChange(of: notificationService.didUpdateNotification) { oldValue, newValue in
            fetchData()
        }
    }
    
    //MARK: - Notifications
    fileprivate func sendNotification(sub: StripeSubscription) {
        guard let providerId = sub.superUserId() else { return }
        guard let userName = Network.shared.account?.fullName else { return }
        let title = sub.plan.product_name
        let subject = "\(userName) has cancelled \(title) plan."
        notificationService.createNotification(receiverId: providerId, subject: subject, content: ["subscription": sub.id])
    }
    
    fileprivate func fetchData() {
        let superusersIds: [String] = service.customerSubscriptions.compactMap({$0.superUserId()})
        isLoading = true
        attachments(ids: superusersIds)
    }
    
    
    fileprivate func attachments(ids:[String]) {
        let queue = DispatchQueue(label: "attachments_options", qos: .background, attributes: .concurrent)
        let group = DispatchGroup()
        queue.async(group: group, execute: {
            for id in ids {
                group.enter()
                service.allAttachmentsFor(superUser: id) { complete in
                    group.leave()
                }
            }
        })
        group.notify(queue: .main) {
            Task {
                service.fetchCustomerSubscriptions(status: .active) { complete in
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    MySubscriptionsView()
}


