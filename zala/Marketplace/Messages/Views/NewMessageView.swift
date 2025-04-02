//
//  NewMessageView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct AttachmentItem {
    var id = UUID()
    var uiImage: UIImage
}

struct NewMessageView: View {
    
    @State var selectedUser: Bool = false
    @State var service: MySuperUsersService = MySuperUsersService()
    @State var messageService: MessageService = MessageService()
    
    @State var typingMessage: String = ""
    @State var title: String = ""
    @State var cameraSelected: Bool = false
    @State var sendTapped: Bool = false
    @State var selectedImage: UIImage = UIImage()
    @State var attachments: [AttachmentItem] = []
    
    var onComplete: ((_ complete: Bool) -> Void)?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Superuser")
                    .style(size:.x19,weight: .w400)
                HStack {
                    if service.selectedSuperUsers.isEmpty {
                        Text("Select Super User")
                            .style(color:Theme.shared.blue, weight: .w400)
                    } else {
                        if let user = service.selectedSuperUsers.first {
                            HStack(alignment: .center) {
                                ProfileIconView(url:user.profileUrl(), size: 28)
                                Text(user.fullName())
                                    .style(weight: .w400)
                                Spacer()
                            }
                        } else {
                            Text("missing user")
                                .style(color:Theme.shared.blue, weight: .w400)
                        }                        
                    }
                    Spacer()
                    Button {
                        selectedUser.toggle()
                    } label: {
                        Image.plus
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack))
                .onTapGesture {
                    selectedUser.toggle()
                }
            }
            
            VStack(alignment: .leading) {
                Text("Title")
                    .style(size:.x19,weight: .w400)
                InputView(placeholder: "Enter Message Title", msg: $title, showProfile: false, minHeight: 55)
            }
            Spacer()
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
                                attachments.removeAll(where: {$0.id == attachment.id })
                            }
                            .padding(.leading)
                        }
                    }
                }
                .frame(height: attachments.isEmpty ? 0.0 : 140.0)
            }
        }
        .padding()
        .navigationTitle("NEW MESSAGE")
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
        .fullScreenCover(isPresented: $selectedUser) {
            NavigationStack {
                SuperUserSelectionView().environment(service)
            }
        }
        .onChange(of: selectedImage, { oldValue, newValue in            
            attachments.append(AttachmentItem(uiImage: newValue))
        })
        .onChange(of: sendTapped) { oldValue, newValue in
            guard !service.selectedSuperUsers.isEmpty else { return }
            guard !typingMessage.isEmpty else { return }
            guard !title.isEmpty else { return }
           var users = service.selectedSuperUsers.compactMap({ConversationUser(name: $0.fullName(), uuid: $0.id ?? "")})
            users.append(Network.shared.convoUser)
            let files = attachments.compactMap({MultipartFileUpload(filename: $0.id.uuidString.lowercased(), file: $0.uiImage.pngData()!)})
            messageService.createConversation(input: .init(title: title,
                                                           msg: typingMessage,
                                                           users: users,
                                                           files: files))
            
        }
        .imageSelection(image: $selectedImage, showPhoto: $cameraSelected)
        .onChange(of: messageService.uploadCompleted) { old, newValue in
            onComplete?(true)
            dismiss()
        }
    }
}

#Preview {
    NewMessageView()
}
