//
//  SuperUserCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/21/24.
//

import SwiftUI
import MarkdownUI

struct SuperUserCellView: View {
    
    @State var title: String = "Marcus Stroman"
    @State var subtitle: String = "Marcus Earl Stroman (born May 1, 1991) is an American professional baseball..."
    @State var profileUrl: String? = nil
    @State var tagString: String = ""
    var body: some View {
        HStack {
            ProfileIconView(url:profileUrl, size: 88)
            VStack(alignment: .leading, spacing: 5) {                
                Text(title)
                    .style(color: .white, size: .regular, weight: .w700)
                HTMLText(htmlContent: subtitle).renderText()
                    .style(color: Theme.shared.grayStroke, size: .x13, weight: .w400)
                    .lineSpacing(5)
                    .lineLimit(3)
//                Markdown(MarkdownContent(subtitle).renderPlainText())
//                    .markdownTextStyle(\.text) {
//                      FontSize(15)
//                      ForegroundColor(Theme.shared.placeholderGray)
//                    }
//                    .lineLimit(3)
                if !tagString.isEmpty {
                    HStack {
                        Image.tag
                        Text(tagString)
                            .style(color: .white,
                                   size: .small,
                                   weight: .w400)
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    SuperUserCellView()
}
