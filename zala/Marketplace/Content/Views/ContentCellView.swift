//
//  ContentCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentCellView: View {
    
    @State var content: ZalaContent
    @State var liked: Bool = false
    @State var selectedContent: ZalaContent? = nil
    
    @State private var tappedPoint: CGPoint?
    @State private var isImageVisible = false
    @Environment(ContentService.self) var service
    
    var body: some View {
        VStack(alignment:.leading) {
            ContentHeaderView(name: content.creatorName ?? "",
                              url: content.creatorUrl,
                              date: content.dateTime(),
                              liked: $liked)
            VStack(alignment:.leading, spacing: 12) {
                Text(content.title)
                    .style(color: .white, size: .large, weight: .w700)
                    .multilineTextAlignment(.leading)
                Text(content.description)
                    .style(color: Theme.shared.placeholderGray, size: .regular, weight: .w400)
                    .multilineTextAlignment(.leading)
            }
            if let thumbnail = content.thumbnail, !thumbnail.isEmpty {
                WebImage(url: URL(string: thumbnail)) { image in
                    image
                        .resizable()
                        .interpolation(.medium)
                        .frame(height: 185, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, 5)
                        .overlay(alignment: .center, content: {
                            if content.isVideo {
                                Image("play-btn")
                            }
                        })
                        .onTapGesture(count: 1, perform: {
                            if content.isVideo {
                                self.selectedContent = content
                            }
                        })
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.shared.mediumBlack)
                        .frame(height: 185, alignment: .center)
                        .padding(.top, 5)
                        .onTapGesture(count: 1, perform: {
                            self.selectedContent = content
                        })
                }
            }
        }
        .fullScreenCover(item: $selectedContent) {
            selectedContent = nil
        } content: { zalaContent in
            NavigationStack {
                FullScreenVideoView(videoURL: URL(string: zalaContent.video ?? "")!)
            }
            .onAppear {
                service.updatePost(engagement: .viewed, id: "\(content.id)")
            }
        }
        .onChange(of: liked) { oldValue, newValue in
            updateCount(liked: newValue)
        }
    }
    
    fileprivate func updateCount(liked: Bool) {
        service.updatePost(engagement: liked ? .like : .dislike, id: "\(content.id)")
    }
}
