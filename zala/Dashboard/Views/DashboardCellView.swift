//
//  DashboardCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/21/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct DashboardCellView: View {
    @State var icon: Image = .pills
    @State var title: String
    @State var subtitle: String
    @State var complete: Bool = false
    @State var iconSize: CGSize = CGSize(width: 27, height: 19)
    @State var routine: Bool = false
    @State var isMarketplace: Bool = false
    @State var isAppointment: Bool = false
    @State var url: String?
    @State var intials: String? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            if complete {
                Image.selected
                    .frame(width: 36, height: 36)
                    .padding(.leading)
            } else {
                IconView(icon: icon,
                         iconSize: iconSize,
                         imageColor: isMarketplace ? .white : .black,
                         backgroundSize: 40,
                         gradinetColor: isMarketplace ? Theme.shared.grayGradientColor : Theme.shared.lightBlueGradientColor)
                .padding(.leading)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .style(color: .white, size: .regular, weight: .w400)
                    .strikethrough(complete)
                
                HStack(alignment: .center) {
                    HStack {
                        if !isAppointment {
                            buildProfileView(url: url, initials: intials ?? "AA")
                        }                        
                        Text(subtitle)
                            .style(color:Theme.shared.placeholderGray,
                                   size: .small,
                                   weight: .w400)
                    }
                    if !routine {
                        Text(complete ? "Complete - 9:00am" : "- Pending")
                            .style(color: complete ? Theme.shared.green : Theme.shared.placeholderGray,
                                   size: .regular,
                                   weight: .w400)
                    }
                }
            }
            Spacer()
        }
        .padding([.top, .bottom], 5)
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack))
    }
    
    @ViewBuilder
    fileprivate func buildProfileView(url: String?, initials: String) -> some View {
        if let url, !url.isEmpty {
            WebImage(url: URL(string: url),
                     options: .continueInBackground)
                .resizable()
                .interpolation(.high)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 15, height: 15, alignment: .center)
        } else {
            InitalsView(initials: initials, size: 15, textSize: .xSmall)
        }
    }
}

#Preview {
    DashboardCellView(title: "Supplement - Tongkat Ali - 250mg", subtitle: "Strength Routine")
}
