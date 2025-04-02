//
//  StoreCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct StoreCellView: View {
    
    @State var mainImage: Image = Image("demo-store-img")
    @State var title: String = "Alpha GPC Nootropic 300mg tablets"
//    @State var price: String = "$49.99"
    @State var tag: String = "Cognitive"
    
    let name: String
    let imgUrl: String?
    let price: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imgUrl {
                WebImage(url: URL(string: imgUrl), options: .continueInBackground)
                    .resizable()
                    .interpolation(.medium)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 173, maxHeight: 173, alignment: .center)
                    .clipShape(Rectangle())
            } else {
                mainImage
            }
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(name)
                        .style(color: .white, size: .small, weight: .w700)
                        .lineLimit(2)
                        .align(.leading)
                    Text(price ?? "Free")
                        .style(color: Theme.shared.lightBlue,
                               size: .small,
                               weight: .w400)
                        .lineLimit(1)
                        .align(.leading)
                }
                .padding()
//                HStack {
//                    Image.tag
//                    Text(tag)
//                        .style(color: Theme.shared.lightBlue,
//                               size: .small,
//                               weight: .w400)
//                    Spacer()
//                }
//                .padding([.leading, .trailing, .bottom])
            }
            .frame(minHeight: 80)
            .background(Theme.shared.mediumBlack)
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        
    }
}
