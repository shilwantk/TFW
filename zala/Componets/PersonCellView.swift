//
//  PersonCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct SUPersonCellView: View {
    @Binding var url:String?
    @Binding var title: String
    @State var tags: [String] = []
    var body: some View {
        HStack {
            ProfileIconView(url: url, size: 30)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .style(size: .regular, weight: .w500)
                if !tags.isEmpty {
                    TagsView(tags: tags, total: tags.count)
                }
            }
            Spacer()
        }
        .frame(minHeight: 55)
        .padding([.leading, .trailing])
        .background(
            RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
        )
    }
}

struct PersonCellView: View {
    @State var url:String? = nil
    @State var title: String = ""
    @State var tags: [String] = []
    var body: some View {
        HStack {
            ProfileIconView(url: url, size: 30)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .style(size: .regular, weight: .w500)
                if !tags.isEmpty {
                    TagsView(tags: tags, total: tags.count)
                }
            }
            Spacer()
        }
        .frame(minHeight: 55)
        .padding([.leading, .trailing])
        .background(
            RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
        )
    }
}

#Preview {
    PersonCellView()
}
