//
//  SuperUserSelectionView.swift
//  zala
//
//  Created by Kyle Carriedo on 6/11/24.
//

import SwiftUI
import ZalaAPI

struct SuperUserSelectionView: View {
    
    @State var selectedItem: SegmentedValue = SegmentedValue(title:"Superusers", key: "all")
    @State var stripeService: StripeService = StripeService()
    @State var isLoading: Bool = false
    
    @Environment(MySuperUsersService.self) var service
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment:.top) {
                if isLoading {
                    LoadingBannerView()
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            ScrollView {
                ForEach(service.superUsers, id: \.id) { user in
                    SuperUserCellView(title: user.fullName(),
                                      subtitle: user.bio?.strippingMarkdown() ?? "",
                                      profileUrl: user.profileUrl(),
                                      tagString: user.formattedTags).onTapGesture {
                        service.selectedSuperUsers = [user]
                        dismiss()
                    }
                    if user.id != service.superUsers.last?.id {
                        Divider().background(.gray)
                    }
                }
            }
        }
        .navigationTitle("SELECT SUPERUSER")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    dismiss()
                } label: {
                    Image.close
                }

            }
        })
        .task {
            updateLoading()
            stripeService.getCustomer()
            stripeService.fetchCustomerSubscriptions(status: .active) { complete in
                service.browseAllSuperUsers(orgId: .zalaOrg)
                fetchData()
                updateLoading()
            }
        }
    }
    
    fileprivate func fetchData() {
        Task {
            stripeService.fetchCustomerSubscriptions(status: .active) { complete in}
        }
    }
    
    fileprivate func updateLoading() {
        withAnimation {
            isLoading.toggle()
        }
    }
}

#Preview {
    SuperUserSelectionView()
}
