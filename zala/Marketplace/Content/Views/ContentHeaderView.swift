//
//  ContentHeaderView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentHeaderView: View {
    
    @State var name: String
    @State var url: String?
    @State var date: String
    @Binding var liked: Bool
    
    var body: some View {
        HStack {
            HStack {
                if let url, 
                    let profile = URL(string: url),  
                    let scheme = profile.scheme,
                    scheme.hasPrefix("http") || scheme.hasPrefix("https") {
                    WebImage(url: profile, options: .continueInBackground)
                        .resizable()
                        .interpolation(.medium)
                        .aspectRatio(contentMode: .fill)
                        .frame(width:45, height: 45, alignment: .center)
                        .clipShape(Circle())
                } else {
                    Image("profile-empty").resizable().frame(width: 27, height: 27)
                }
                Text(name)
                    .style(color: .white, size: .small, weight: .w700)
            }
            Spacer()
            HStack {
                Text(date)
                    .style(color: .white, size: .small, weight: .w400)
                Button(action: {
                    liked.toggle()
                }, label: {
                    if liked {
                        Image.liked
                            .renderingMode(.template)
                            .tint(Theme.shared.blue)
                    } else {
                        Image.disliked
                    }
                })
            }
            .onTapGesture {
                liked.toggle()
            }
        }
    }
}
