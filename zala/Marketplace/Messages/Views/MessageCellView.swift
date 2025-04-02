//
//  MessageCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct MessageCellView: View {
    @State var profile: Image = Image("demo-profile")
    @State var name: String? = nil
    @State var title: String
    @State var msg: String
    @State var date: Date
    @State var isRead: Bool
    
    var body: some View {
        HStack {
            if !isRead {
                DotView(gradientColor: Theme.shared.lightBlueGradientColor)
            }
            InitalsView(initials: name?.initials(), size: 55, textSize: .x18)
//            profile
//                .resizable()
//                .frame(width: 55, height: 55)
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .style(weight: .w700)
                    Spacer()
                    Text(DateFormatter.monthDay(date: date))
                        .style(size:.small, weight: .w400)
                    Image.arrowRight
                }
                HTMLText(htmlContent: msg).renderText()
                    .style(size: .small, weight: .w400)
//                Text(msg)
//                    .style(size: .small, weight: .w400)
            }
        }
        
    }
}
