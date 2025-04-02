//
//  MetaView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI

struct MetaItem {
    var title: String
    var subtitle: String
    var image: Image
    var size: CGSize = CGSize(width: 27, height: 27)
}

struct MetaView: View {
    
    @State var itemOne: MetaItem
    @State var itemTwo: MetaItem
    @State var itemThree: MetaItem?
    
    var body: some View {
        HStack {
            buildView(item: itemOne)
            Spacer()
            buildDivider()
            Spacer()
            buildView(item: itemTwo)
            Spacer()
            if let itemThree {
                buildDivider()
                Spacer()
                buildView(item: itemThree)
            }
        }
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing])
    }
    
    @ViewBuilder
    fileprivate func buildDivider() -> some View {
        Rectangle().fill(.gray).frame(width: 0.5, height: 60)
    }
    
    @ViewBuilder
    fileprivate func buildView(item: MetaItem) -> some View {
        VStack(alignment: .center, spacing: 10) {
            item.image
                .resizable()
                .frame(width: item.size.width, height: item.size.height)
            Text(item.title)
                .style(color: Theme.shared.placeholderGray, size: .small, weight: .w400)
            Text(item.subtitle)
                .style(color: .white, size: .small, weight: .w700)
        }
        .frame(maxWidth: 200)
    }
}

#Preview {
    MetaView(itemOne: MetaItem(title: "Cost", subtitle: "$150.0", image: .dollarSign),
             itemTwo: MetaItem(title: "Duration", subtitle: "120min", image: .clockRoutine),
             itemThree: MetaItem(title: "Type", subtitle: "In Person", image: .location))
}
