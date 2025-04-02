//
//  AppointmentsCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI

struct AppointmentsCellView: View {
    
    @State var banner: String? = nil
    @State var title: String
    @State var duration: String
    @State var type: String
    @State var cost: String
    @State var isActive: Bool
    
    var body: some View {
        VStack(spacing:0) {
            BannerCellView(bannerUrl: banner, title: title)
            BottomCellView(items: [
                BottomCellItem(title: "Cost:", value: cost),
                BottomCellItem(title: "Type:", value: type),
                BottomCellItem(title: "Duration:", value: duration)
            ])
        }
        .overlay(alignment: .topTrailing) {
            if isActive {
                Text("Available")
                    .style(color: .white, size: .small, weight: .w400)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Theme.shared.green))
                    .padding([.trailing, .top])
            }
        }
    }
}
