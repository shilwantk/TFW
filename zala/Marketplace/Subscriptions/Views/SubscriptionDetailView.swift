//
//  SubscriptionDetailView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI
import ZalaAPI
import SDWebImageSwiftUI

struct ConsentSelection: Identifiable {
    let id = UUID()
    let consent: String
}

struct SubscriptionDetailView: View {
    @State var superUser: SuperUser
    @State var product: StripeProduct
    @State var url: String? = nil
    @State private var buttonTitle: String = "PURCHASE SUBSCRIPTION"
    
    @Environment(\.dismiss) var dismiss
    @Environment(StripeService.self) var service
    @Binding var didComplete: Bool
    @State private var isLoading: Bool = false
    @State private var showConsent: Bool = false
    @State private var showAppointments: Bool = true
    @State var consentUrl: ConsentSelection? = nil
    @State private var appointmentService: AppointmentService = AppointmentService()
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack(alignment:.top) {
                    BannerView(url: url, fullScreen: true).padding(.bottom)
                    if isLoading {
                        LoadingBannerView()
                            .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    }
                }
                MetaView(itemOne: MetaItem(title: "Cost Per Month", subtitle: product.formattedPrice(), image: .dollarSign),
                         itemTwo: MetaItem(title: "Appointments", subtitle: "\(product.appointmentCount)", image: .appointments),
                         itemThree: nil)
                .padding(.bottom)
                DescriptionView(desc: product.description, showMarkDown: true).padding()
                Spacer()
                if product.appointmentCount > 0 {
                    VStack(alignment:.leading) {
                        ExpandedHeaderView(title: "Appointment Access", expand: $showAppointments).padding([.leading, .trailing])
                        if showAppointments {
                            ForEach(appointmentService.groups, id: \.self) { group in
                                HStack {
                                    WebImage(url: URL(string: group.banner ?? "")) { img in
                                        img
                                            .resizable()
                                            .interpolation(.medium)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 96, height: 48, alignment: .center)
                                            .clipShape(Rectangle())
                                    } placeholder: {
                                        Image.routinePlaceholder
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 96, height: 48, alignment: .center)
                                    }
                                    .overlay {
                                        Theme.shared.black.opacity(0.3)
                                    }
                                    VStack(alignment:.leading) {
                                        Text(group.title)
                                        Text(group.formattedCost())
                                    }
                                    Spacer()
                                }.padding([.leading, .trailing])
                                if appointmentService.groups.last != group {
                                    Divider().background(.gray)
                                }
                            }
                        }
                    }
                }
            }
            Divider().background(.gray)
            SubscriptionButton(title: $buttonTitle) {
                if let consent = superUser.consent() {
                    self.consentUrl =  ConsentSelection(consent: consent)
                } else {
                    showLoading()
                    subscribe()
                }
            }.padding()
        }
        .task {
            if let orgId = superUser.myOrg?.id,
                let appointments = product.metadata?.totalAppointments {
                appointmentService.subAppointmentsFor(orgId: orgId,isSubscribed: true, subscriptionServices: appointments)
            }
        }
        .onChange(of: service.checkoutSession, { oldValue, newValue in
            isLoading.toggle()
        })
        .navigationTitle(product.name ?? "Subscription")
        .fullScreenCover(item: .constant(service.checkoutSession), onDismiss: {
            service.checkoutSession = nil
        }, content: { session in
            NavigationStack {
                WebView(url: URL(string: session.url)!)
                    .navigationTitle("Checkout")
                    .toolbar(content: {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {
                                showLoading()
                                self.checkAndSubscribeIfNeeded()
                            }, label: {
                                Image.close
                            })
                        }
                    })
            }
        })
        .onOpenURL { url in
            handleURL(url: url)
        }
        .fullScreenCover(item: $consentUrl, onDismiss: {
            consentUrl = nil
            showLoading()
            subscribe()
            
        }, content: { data in
            NavigationStack {
                SafariWebView(url: URL(string: data.consent)!)
                    .ignoresSafeArea()
            }
        })
    }
    
    private func handleURL(url: URL) {
        switch url.host {
        case "post": break
            
        default:
            break
        }
    }
    fileprivate func showLoading() {
        withAnimation(Animation.easeIn(duration: TimeInterval(0.3))) {
            isLoading.toggle()
        }
    }
    
    fileprivate func autoSubscribe() {
        service.subscribe(superUser: superUser) { complete in
            isLoading.toggle()
            dismiss()
        }
    }
    
    fileprivate func subscribe() {
        service.purchaseAndSubscribe(stripeProduct: product, type: .subscription)
    }
    
    
    fileprivate func checkAndSubscribeIfNeeded() {
        service.checkoutSession = nil
        service.fetchCustomerSubscriptions(status: .active) { complete in
            ///if we have subscription then we subscrive
            if service.subscribedToIds.contains(superUser.id ?? "") {
                service.subscribe(superUser: superUser) { complete in
                    isLoading.toggle()
                    dismiss()
                }
            } else {
                isLoading.toggle()
                dismiss()
            }
        }
    }
}
