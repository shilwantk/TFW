//
//  BannerCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct BannerCellView: View {
    
    @State var bannerUrl: String? = nil
    @State var image: Image? = nil
    @State var title: String
    @State var titleColor: Color = .white
    
    var body: some View {
        ZStack(alignment: .bottomLeading, content: {
            if let bannerUrl {
                WebImage(url: URL(string: bannerUrl)) { img in
                    img
                        .resizable()
                        .interpolation(.medium)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth:.infinity, maxHeight: 185, alignment: .center)
                } placeholder: {
                    Image.routinePlaceholder
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180, alignment: .center)
                }
                .overlay {
                    Theme.shared.black.opacity(0.3)
                }
            } else if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180, alignment: .center)
            } else {
                Image.routinePlaceholder
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180, alignment: .center)
            }
            Text(title)
                .style(color: titleColor, size: .x22, weight: .w800)
                .multilineTextAlignment(.leading)
                .padding([.leading, .bottom])
        })
        .cornerRadius(12, corners: [.topLeft, .topRight])
    }
}

#Preview {
    BannerCellView(title: "Routine")
}
