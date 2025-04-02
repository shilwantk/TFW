//
//  MessagesView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct MessagesView: View {
    @Environment(\.dismiss) var dismiss
    @State var showNewMessage: Bool = false
    @State var service: MessageService = MessageService()
    @State var selectedConvo: Conversation? = nil
    var body: some View {
        NavigationStack {
            VStack {
                if service.conversations.isEmpty {
                    ZalaEmptyView(title: "Messages", msg: "You have no new messages")
                } else {
                    List {
                        ForEach(service.conversations, id:\.self) { conversation in
                            MessageCellView(
                                name: conversation.latestSender()?.name,
                                title: conversation.title ?? "",
                                msg: conversation.latestMessage ?? "",
                                date: conversation.createAtDate(),
                                isRead: conversation.isRead()).onTapGesture {                                    
                                    service.markAsRead(id: "\(conversation.id)")                                    
                                    selectedConvo = conversation
                                }
                                .swipeActions(edge: .trailing) {
                                    
                                    Button {
                                        service.markAsRead(id: "\(conversation.id)")
                                        
                                    } label: {
                                        Label("Read", systemImage: "envelope.open.fill")
                                            .tint(Theme.shared.blue)
                                    }
                                    .tint(Theme.shared.blue)
                                    
                                    Button(role: .destructive) {
                                        service.deleteConversation(conversation: conversation)
                                    } label: {
                                        Label("More", systemImage: "trash")
                                    }
                                    .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.zalaRed))
                                }
                        }
                    }
                    .listStyle(.plain)
                }
                Spacer()
                Divider().background(.gray)
                StandardButton(title: "+ New Message") {
                    showNewMessage.toggle()
                }
                    .padding()
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image.close
                    }

                }
            }
            .navigationDestination(item: $selectedConvo, destination: { conversation in
                MessageDetailView(conversationId: conversation.id)
            })
            .fullScreenCover(isPresented: $showNewMessage) {
                NavigationStack {
                    NewMessageView { complete in
                        service.fetchConversations()
                    }
                }
            }
            .onAppear(perform: {
                service.fetchConversations()
            })            
        }
    }
}

#Preview {
    MessagesView()
}
