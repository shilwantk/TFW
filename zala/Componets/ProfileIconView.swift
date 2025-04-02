//
//  ProfileIconView.swift
//  zala
//
//  Created by Kyle Carriedo on 4/9/24.
//

import SwiftUI
import SDWebImageSwiftUI


struct ProfileIconView: View {
    
    var url:String?
    var color:String?
    var size:CGFloat
    var image:UIImage? = nil
    @State var dataDidUpdate: Bool = false
    
    var body: some View {
        ZStack {
            if dataDidUpdate {
                profileView(url: url, color: color, image: image)
            } else {
                profileView(url: url, color: color, image: image)
            }            
        }
        .onChange(of: url) { _, newValue in
            dataDidUpdate.toggle()
        }
    }
    
    @ViewBuilder
    func profileView(url: String?, color: String?, image:UIImage? = nil) -> some View {
//            let size:CGFloat = isMessage() ? 34 : 60
            let corner:CGFloat = size / 2
        if let img = image {
            Image(uiImage: img)
                .resizable()
                .frame(width:size, height:size)
                .clipShape(Circle())
                .overlay(
                    RoundedRectangle(cornerRadius: corner).stroke(Theme.shared.unselectedGray, lineWidth: 0.5)
                )
        } else if let profileUrl = url, !profileUrl.isEmpty {
            WebImage(url: URL(string: profileUrl)) { image in
                image
                    .resizable()
                    .interpolation(.medium)
                    .aspectRatio(contentMode: .fill)
                    .frame(width:size, height:size, alignment: .center)
                    .clipShape(Circle())
                    .overlay(
                        RoundedRectangle(cornerRadius: corner).stroke(Theme.shared.unselectedGray, lineWidth: 0.5)
                    )
            } placeholder: {
                Image.profilePlaceholder
                    .resizable()
                    .frame(width:size, height:size)
            }
        } else {
            Image.profilePlaceholder
                .resizable()
                .frame(width:size, height:size)
        }
    }
}

