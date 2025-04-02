//
//  InputView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct InputView: View {
    @State var placeholder: String = "Message..."
    @Binding var msg: String
    @FocusState var isMessageFocused: Bool
    @State var showProfile: Bool = true
    @State var minHeight: CGFloat = 45.0
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                if showProfile {
                    Image("demo-profile")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding(.top, 11)
                        .padding(.leading, 5)
                }
                VStack {
                    TextField(placeholder, text: $msg, axis: .vertical)
                        .frame(minHeight: minHeight)
                        .focused($isMessageFocused)
                        .padding(msg.isEmpty ? 0 : 5)
                }
                .padding(.leading, showProfile ? 0 : 15)
            }
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
        }.frame(minHeight: minHeight)
    }
}
