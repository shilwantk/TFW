//
//  MySubscriptionCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MySubscriptionCellView: View {
    @State var plan: StripeSubscription
    @State var url: String? = nil
    @State var superUserId: String? = nil
    @Environment(StripeService.self) var service
    var body: some View {
        HStack {
            if let url {
                WebImage(url: URL(string: url), options: .continueInBackground)
                    .resizable()
                    .interpolation(.medium)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 105, maxHeight: 55, alignment: .center)
                    .cornerRadius( 8, corners: .allCorners)
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    Image.subscriptionPlaceholder
                    Spacer()
                }
                .frame(maxWidth: 105, minHeight: 55, maxHeight: 55, alignment: .center)
                .cornerRadius( 8, corners: .allCorners)
    //            Image.routinePlaceholder
    //                .aspectRatio(contentMode: .fill)
    //                .frame(maxWidth: .infinity, maxHeight: 195.5, alignment: .center)
    //                .ignoresSafeArea(.all, edges: [.leading, .trailing])
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(plan.plan.product_name)
                        .style(weight: .w700)
                    Spacer()
                }
                Text(plan.plan.formattedNextBill())
                    .style(size:.small, weight: .w400)
            }
        }
        .onAppear(perform: {
            if let superUserId = plan.superUserId() {
                service.allAttachmentsFor(superUser: superUserId) { complete in
                    self.url = service.urlFor(images: plan.plan.product.images)
                }
            }
        })
    }
}
