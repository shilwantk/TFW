//
//  MessageDetailCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI
import SDWebImageSwiftUI
import MarkdownUI

struct MessageDetailCellView: View {
    
    @State var profile: Image = Image("demo-profile")
    @State var person: String = ""
    @State var title: String = ""
    @State var msg: String = ""
    @State var date: Date = .now
    @State var isRead: Bool = false
    @State var isYou: Bool = false
    @State var files: [MessageAttachment] = []
    @State var content: [ZalaContent] = []
    @State private var selImage: PreviewImage? = nil
    @State private var selectedContent: ZalaContent? = nil
    
    
    var body: some View {
        HStack(alignment: .top) {
            InitalsView(initials: person, size: 27, textSize: .xSmall)
//            profile
//                .resizable()
//                .frame(width: 27, height: 27)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .style(color: isYou ?  Theme.shared.lightBlue : .white, size:.small,
                               weight: .w700)
                    Spacer()
                    Text(DateFormatter.monthDay(date: date))
                        .style(size:.small, weight: .w400)
                        .padding(.trailing)
                }
                Markdown(msg)
                if !files.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(files, id:\.fileId) { file in
                                WebImage(url: URL(string: file.url)) { image in
                                    image
                                        .resizable()
                                        .interpolation(.high)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 140, height: 140, alignment: .center)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 8.0)).onTapGesture {
                                            selImage = PreviewImage(img: image)
                                        }
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
                                        .frame(width: 140, height: 140)
                                }
                            }
                        }
                        .previewImage(image: $selImage)
                    }
                }
                if !content.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(content, id:\.contentId) { content in
                                WebImage(url: URL(string: content.thumbnail ?? "")) { image in
                                    image
                                        .resizable()
                                        .interpolation(.high)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 140, height: 140, alignment: .center)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 8.0)).onTapGesture {
                                            selectedContent = content
                                        }
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
                                        .frame(width: 140, height: 140)
                                }
                            }
                        }
                        .fullScreenCover(item: $selectedContent) {
                            selectedContent = nil
                        } content: { zalaContent in
                            NavigationStack {
                                FullScreenVideoView(videoURL: URL(string: zalaContent.video ?? "")!)
                            }
                        }
                    }
                }
            }
        }
    }    
}

#Preview {
    MessageDetailCellView()
}
