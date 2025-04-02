//
//  DescriptionView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import MarkdownUI
import SwiftHTMLtoMarkdown

struct DescriptionView: View {
    
    @State var title: String = "Description"
    @State var desc: String = "If you are more than just a beginner, this routine is for you. First, we establish a baseline for your strength goals and then we adjust the plan accordingly.\n\nThis routine can be performed with bodyweight but if you have access to a pull up bar and a weighted vest that is ideal.\n"
    
    @State private var showText: Bool = true
    @State var showMarkDown: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .style(color: .white, size: .x18, weight: .w700)
                    Spacer()
                    Image.arrowUp
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 27)
                        .rotationEffect(.degrees(showText ? 0 : 180))
                }
                .contentShape(RoundedRectangle(cornerRadius: 0))
                .onTapGesture {
                    withAnimation {
                        showText.toggle()
                    }
                }
                if showText {
                    if showMarkDown {
                        Markdown(desc)
                    } else {
                        Text(desc)
                            .style(color: Theme.shared.placeholderGray, size: .regular, weight: .w400)
                    }
                }
            }
            .task {
                Task {
                    let result = try desc.markdown()
                    self.desc = result
                }
                
            }
        }
    }
}

#Preview {
    DescriptionView()
}


extension String {
    func markdown() throws -> String {
        var document = BasicHTML(rawHTML: self)
        try document.parse()                
        let markdown = try document.asMarkdown()
        return markdown
    }
}
