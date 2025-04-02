//
//  MarketPlaceContentView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import ZalaAPI

struct MarketPlaceContentView: View {
    @State var superUser: SuperUser
    @State var liked: Bool = false
    @Binding var isSubscribed: Bool
    var body: some View {
        VStack {
            ZalaContentView(superUserId: superUser.id)
            Spacer()
            if !isSubscribed {
                SubscriptionButtonView(superUser: superUser, isSubscribed: $isSubscribed)
            }
        }
    }
}
