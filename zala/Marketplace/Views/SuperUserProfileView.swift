//
//  SuperUserProfileView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import ZalaAPI
import MarkdownUI
import RegexBuilder

struct SuperUserProfileView: View {
    
    @State var superUser: SuperUser
    @State var showVideo: Bool = false
    @Binding var isSubscribed: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            ScrollView {
                ProfileIconView(url: superUser.profileUrl(), size: .superUserProfileLarge)
                VStack(spacing: 12) {
                    Text("About Me")
                        .style(color: .white, size: .x22, weight: .w700)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    if let bio = superUser.bio {
                        Markdown(bio)
                            .lineSpacing(8.0)
                            .padding()
                    }
                }
                .padding(.bottom)
                if superUser.hasWelcomeVideo() {
                    VStack {
                        Text("Welcome Video")
                            .style(color: .white, size: .x22, weight: .w700)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        Image.profileVideoPlaceholder
                            .resizable()
                            .frame(minHeight: 175)
                            .padding([.leading, .trailing])
                            .overlay(alignment: .center, content: {
                                Image("play-btn")
                            })
                            .onTapGesture {
                                showVideo.toggle()
                            }
                    }
                    .padding(.bottom)
                }
                VStack(alignment: .leading) {
                    Text("Interests")
                        .style(color: .white, size: .x22, weight: .w700)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    TagGridView(tags: superUser.tags()).padding(.leading)
                }
                .padding(.bottom)
                VStack {
                    Text("Licenses & Certifications")
                        .style(color: .white, size: .x22, weight: .w700)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .padding(.bottom, 2)
                    ForEach(superUser.certificates(), id: \.self) { cert in
                        VStack(alignment: .leading) {
                            Text(cert.title)
                                .style(color: .white, size: .regular, weight: .w500)
                            HStack {
                                Text(cert.location)
                                    .style(color: Theme.shared.placeholderGray, size: .small, weight: .w400)
                                Text(cert.date)
                                    .style(color: Theme.shared.placeholderGray, size: .small, weight: .w400)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom])
                    }
                }.padding(.top)
            }
            Spacer()
            SubscriptionButtonView(superUser: superUser, isSubscribed: $isSubscribed)
        }
        .fullScreenCover(isPresented: $showVideo, content: {
            NavigationStack {
                FullScreenVideoView(videoURL: URL(string:superUser.welcomeVideo() ?? "")!)
            }            
        })
    }
}

#Preview {
    SuperUserProfileView(superUser: .previewUser, isSubscribed: .constant(false))
}


extension String {
    func htmlToMarkDown() -> String {
        
        var text = self
        
        var loop = true

        // Replace HTML comments, in the format <!-- ... comment ... -->
        // Stop looking for comments when none is found
        while loop {
            
            // Retrieve hyperlink
            let searchComment = Regex {
                Capture {
                    
                    // A comment in HTML starts with:
                    "<!--"
                    
                    ZeroOrMore(.any, .reluctant)
                    
                    // A comment in HTML ends with:
                    "-->"
                }
            }
            if let match = text.firstMatch(of: searchComment) {
                let (_, comment) = match.output
                text = text.replacing(comment, with: "")
            } else {
                loop = false
            }
        }

        // Replace line feeds with nothing, which is how HTML notation is read in the browsers
        text = self.replacing("\n", with: "")
        
        // Line breaks
        text = text.replacing("<div>", with: "\n")
        text = text.replacing("</div>", with: "")
        text = text.replacing("<p>", with: "\n")
        text = text.replacing("</p>", with: "")
        text = text.replacing("<ol>", with: "\n")
        text = text.replacing("</ol>", with: "")
        text = text.replacing("<br>", with: "\n")

        // Text formatting
        text = text.replacing("<strong>", with: "**")
        text = text.replacing("</strong>", with: "**")
        text = text.replacing("<b>", with: "**")
        text = text.replacing("</b>", with: "**")
        text = text.replacing("<em>", with: "*")
        text = text.replacing("</em>", with: "*")
        text = text.replacing("<i>", with: "*")
        text = text.replacing("</i>", with: "*")
        
        text = text.replacing("<ul>", with: "\n")
        text = text.replacing("</ul>", with: "")
        text = text.replacing("<li>", with: "\n")
        text = text.replacing("</li>", with: "\n")
        
        
        // Replace hyperlinks block
        
        loop = true
        
        // Stop looking for hyperlinks when none is found
        while loop {
            
            // Retrieve hyperlink
            let searchHyperlink = Regex {

                // A hyperlink that is embedded in an HTML tag in this format: <a... href="<hyperlink>"....>
                "<a"

                // There could be other attributes between <a... and href=...
                // .reluctant parameter: to stop matching after the first occurrence
                ZeroOrMore(.any)
                
                // We could have href="..., href ="..., href= "..., href = "...
                "href"
                ZeroOrMore(.any)
                "="
                ZeroOrMore(.any)
                "\""
                
                // Here is where the hyperlink (href) is captured
                Capture {
                    ZeroOrMore(.any)
                }
                
                "\""

                // After href="<hyperlink>", there could be a ">" sign or other attributes
                ZeroOrMore(.any)
                ">"
                
                // Here is where the linked text is captured
                Capture {
                    ZeroOrMore(.any, .reluctant)
                }
                One("</a>")
            }
                .repetitionBehavior(.reluctant)
            
            if let match = text.firstMatch(of: searchHyperlink) {
                let (hyperlinkTag, href, content) = match.output
                let markDownLink = "[" + content + "](" + href + ")"
                text = text.replacing(hyperlinkTag, with: markDownLink)
            } else {
                loop = false
            }
        }

        return text
    }
}
