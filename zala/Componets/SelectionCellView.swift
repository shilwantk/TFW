//
//  SelectionCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI

struct SelectionCellView: View {
    
    @State var label: String
    @State var subTitle: String? = nil
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 8, content: {
            if isSelected {
                Image.selected
            } else {
                Image.unselected
            }
            VStack(alignment: .leading) {
                Text(label)
                    .style(color: isSelected ? .white : Theme.shared.placeholderGray,
                           size: .x18,
                           weight: isSelected ? .w700 : .w400)
                if let subTitle {
                    Text(subTitle)
                        .style(color: isSelected ? .white : Theme.shared.placeholderGray,
                               size: .regular,
                               weight: .w400)
                }
            }
        })
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        
    }
}

#Preview {
    SelectionCellView(label: "2-3 days per month", isSelected: .constant(false)).background(.black)
}
