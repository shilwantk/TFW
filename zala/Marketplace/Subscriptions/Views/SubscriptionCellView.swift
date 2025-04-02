//
//  SubscriptionCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

enum SubscriptionType {
    case platinum
    case gold
    case bronze
    case none
}

struct SubscriptionCellView: View {
    
    @State var product: StripeProduct
    @State var url: String? = nil
    let isCurrentSubscription: Bool
    
    var body: some View {        
        VStack(spacing: 0) {
            BannerView(url: url)
            BottomCellView(firstColumnWidth: 50, items: [
                BottomCellItem(title: "Title", value: product.name ?? "Subscription"),
                BottomCellItem(title: "Cost", value: product.formattedPrice())
            ])
        }
        .overlay(alignment: .topTrailing) {
            if isCurrentSubscription {
                Text("Active")
                    .style(color: .white, size: .small, weight: .w400)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Theme.shared.green))
                    .padding([.trailing, .top], 5)
            }
        }
    }
}
