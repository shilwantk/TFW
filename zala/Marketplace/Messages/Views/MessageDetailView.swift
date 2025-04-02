//
//  MessageDetailView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct MessageDetailView: View {
    @State var conversationId: Int
//    @State private var userLookup: [String: ConversationUser] = [:]
    @State var showAttachments: Bool = false
    @State var service: MessageService = MessageService()
    @State var notificationService: NotificationService = NotificationService()
    
    @State private var typingMessage: String = ""
    @State private var title: String = ""
    @State private var navTitle: String = "Conversation"
    @State private var cameraSelected: Bool = false
    @State private var sendTapped: Bool = false
    @State private var selectedImage: UIImage = UIImage()
    @State private var attachments: [AttachmentItem] = []
    @State private var conversation: Conversation? = nil
    
//    @Environment(MessageService.self) var service
    
    var body: some View {
        VStack {
            ScrollViewReader { value in
                ScrollView {
                    ForEach(service.messages, id:\.messageId) { message in
                        let user = service.userLookup[message.senderId ?? ""]
                        MessageDetailCellView(
                            person: user?.name.initials() ?? "",
                            title: message.isYou() ? "You" : user?.name ?? "-",
                            msg: message.markdown ?? "",
                            date: message.date(),
                            isYou: message.isYou(),
                            files: message.files ?? [],
                            content: message.content ?? [])
                        Divider()
                            .background(.gray)
                            .padding([.top, .bottom], 5)
                            .id(message.messageId)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        withAnimation {
                            value.scrollTo(service.messages.last?.messageId)
                        }
                    })
                }
                .onChange(of: service.messages.count) { _, _ in
                    value.scrollTo(service.messages.count - 1)
                }
            }
            Spacer()
            Divider().background(.gray)
            VStack {
                MessageInputView(
                    placeholder: "Write message...",
                    typingMessage: $typingMessage,
                    cameraSelected: $cameraSelected,
                    sendTapped: $sendTapped,
                    minHeight: 55)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(attachments, id: \.id) { item in
                            AttachmentImageView(attachment: item) { attachment in
                                withAnimation {
                                    attachments.removeAll(where: {$0.id == attachment.id })
                                }                                
                            }
                            .padding(.leading)
                        }
                    }
                }
                .frame(height: attachments.isEmpty ? 0.0 : 140.0)
            }
        }
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            service.fetchConversation(id: conversationId) { conversations in
                if let conversation = conversations?.last {
                    self.conversation = conversation
                    self.navTitle = conversation.title ?? "Conversation"
                    service.fetchMessages(id: "\(conversationId)")
                    service.markAsRead(id: "\(conversationId)")
                }
            }
        }
        .onChange(of: selectedImage, { oldValue, newValue in
            attachments.append(AttachmentItem(uiImage: newValue))
        })
        .onChange(of: service.uploadCompleted, { oldValue, newValue in
            if newValue {
                service.fetchMessages(id: "\(conversationId)")
            }
        })
        .onChange(of: sendTapped) { oldValue, newValue in
            guard !typingMessage.isEmpty else { return }
            guard let conversation else { return }
            guard let userId = Network.shared.userId() else { return }
            guard let me = conversation.users.first(where: ({$0.uuid.lowercased() == userId.lowercased() })) else { return }
            let userIds = Array(conversation.usersLookup.keys).filter({$0.lowercased() != userId.lowercased()})
            let files = attachments.compactMap({MultipartFileUpload(filename: $0.id.uuidString.lowercased(), file: $0.uiImage.pngData()!)})
            service.createMessage(input: .init(conversationId: "\(conversationId)", msg: typingMessage, files: files))
            notifications(ids: userIds, convoId: conversation.id, name: me.name)
            typingMessage = ""
            
        }
        .imageSelection(image: $selectedImage, showPhoto: $cameraSelected)
    }
    
    fileprivate func notifications(ids:[String], convoId: Int, name: String) {
        let queue = DispatchQueue(label: "notifications_send", qos: .background, attributes: .concurrent)
        let group = DispatchGroup()
        queue.async(group: group, execute: {
            for id in ids {
                group.enter()
                notificationService.createNotification(receiverId: id,
                                                       subject: "New Message from \(name)",
                                                       content: ["conversationId": convoId]) { complete in
                    group.leave()
                }
            }
        })
        group.notify(queue: .main) {}
    }
}



extension Conversation {
    var usersLookup: [String: ConversationUser] {
        return users.reduce(into: [String: ConversationUser](), { json, user in
            json[user.uuid] = user
        })
    }
}
