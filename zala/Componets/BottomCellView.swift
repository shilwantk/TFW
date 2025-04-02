//
//  BottomCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI

struct BottomCellItem {
    var id = UUID()
    var title: String
    var value: String
}

struct BottomCellView: View {
    @State var firstColumnWidth: CGFloat = 125
    @State var firstColumnSpacing: CGFloat = 5
    @State var color: Color = Theme.shared.mediumBlack
    @State var items: [BottomCellItem] = [
        BottomCellItem(title: "Main Focus:", value: "5"),
        BottomCellItem(title: "Vitals Tracked:", value: "3"),
        BottomCellItem(title: "Duration:", value: "180 days"),
    ]
    var body: some View {
        VStack {
            VStack(spacing: firstColumnSpacing) {
                ForEach(items, id: \.id) { item in
                    buildKeyValue(item: item)
                }
            }
            .padding([.leading, .trailing])
            .padding([.top, .bottom], 15)
        }
        .frame(maxWidth: .infinity)
        .background(color)
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])        
    }
    
    @ViewBuilder
    fileprivate func buildKeyValue(item: BottomCellItem) -> some View {
        HStack(alignment: .top) {
            Text(item.title)
                .style(color: Theme.shared.placeholderGray, size: .regular, weight: .w400)
                .frame(width: firstColumnWidth, alignment: .leading)
            Text(item.value)
                .style(color: .white, size: .regular, weight: .w500)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

#Preview {
    BottomCellView()
}
