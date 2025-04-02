//
//  EventCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI

struct EventCellView: View {
    @State var event: EventbriteEvent
    var body: some View {
        VStack(spacing:0) {
            BannerCellView(bannerUrl: event.imageUrl(),
                           title: event.formattedTitle(),
                           titleColor: .white)
            BottomCellView(firstColumnSpacing:10, items: itemsForEvent())
        }
    }
    
    fileprivate func itemsForEvent() -> [BottomCellItem] {
        var data = [
            BottomCellItem(title: "Cost:", value: "$100.00"),
            BottomCellItem(title: "Type:", value: "Jan 15, 2023 - 10:00AM")
        ]
        if event.isLocation() {
            data.append(BottomCellItem(title: "Location:", value: event.venue?.address?.cellFormat() ?? "-"))
        }
        return data
    }
}
