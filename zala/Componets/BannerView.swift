//
//  SwiftUIView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct BannerView: View {
    
    @State var url: String? = nil
    @State var fullScreen: Bool = false
    
    var body: some View {
        if let url {
            WebImage(url: URL(string: url), options: .continueInBackground)
                .resizable()
                .interpolation(.medium)
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 195.5, alignment: .center)
                .ignoresSafeArea(.all, edges: [.leading, .trailing])
                .cornerRadius( fullScreen ? 0 : 8, corners: [.topLeft, .topRight])
        } else {
            VStack(alignment: .center) {
                Spacer()
                Image.zalaCardLogo
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 195.5, maxHeight: 195.5, alignment: .center)
            .ignoresSafeArea(.all, edges: [.leading, .trailing])
//            Image.routinePlaceholder
//                .aspectRatio(contentMode: .fill)
//                .frame(maxWidth: .infinity, maxHeight: 195.5, alignment: .center)
//                .ignoresSafeArea(.all, edges: [.leading, .trailing])
        }
    }
}

#Preview {
    BannerView()
}
