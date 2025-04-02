//
//  MessageInputView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct MessageInputView: View {
    
    @FocusState private var isMessageFocused: Bool
    @State var placeholder: String = "Message..."
    @Binding var typingMessage: String
    @Binding var cameraSelected: Bool
    @Binding var sendTapped: Bool
    @State var minHeight: CGFloat = 45.0
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    TextField(placeholder, text: $typingMessage, axis: .vertical)
                        .frame(minHeight: minHeight)
                        .focused($isMessageFocused)
                        .padding(typingMessage.isEmpty ? 0 : 5)
                        .padding([.leading, .trailing])
                }
                .background(
                    RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
                )
            }.frame(minHeight: minHeight)
            HStack {
                Button(action: {
                    cameraSelected.toggle()
                }, label: {
                    Image.camera
                })
                .frame(width: 44, height: 44)
                .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
                )
                StandardButton(title: "Send", height: 44){                    
                        sendTapped.toggle()
                }
                .frame(height: 44)
            }
        }
    }
    
    @ViewBuilder
    func buildSendButton() -> some View {
        Button(action: {
            sendTapped.toggle()
        }) {
            Image.send
                .renderingMode(.template)
                .frame(width: 40, height: 40)
                .foregroundColor(typingMessage.isEmpty ? Theme.shared.gray : .white)
                .background(typingMessage.isEmpty ? Theme.shared.graySplit : Theme.shared.lightBlue)
                .clipShape(Circle())
        }
    }
}
