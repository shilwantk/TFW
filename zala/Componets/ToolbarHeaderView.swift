//
//  ToolbarHeaderView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/29/24.
//

import SwiftUI

struct ToolbarHeaderView: View {
    @State var title: String
    @State var subtitle: String
    var body: some View {
        VStack {
            Text(title)
                .style(size: .x18, weight: .w800)
            Text(subtitle)
                .style(color: Theme.shared.placeholderGray, size: .small, weight: .w400)
        }
    }
}

#Preview {
    ToolbarHeaderView(title: "Hello", subtitle: "World")
}
