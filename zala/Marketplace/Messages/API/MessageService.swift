//
//  MessageService.swift
//  zala
//
//  Created by Kyle Carriedo on 6/10/24.
//

import Foundation
import Alamofire
import Combine
import KeychainSwift

struct MultipartFileUpload {
    var filename: String
    var file: Data
}

struct ConversationInput {
    var title: String
    var msg: String
    var users:[ConversationUser]
    var files:[MultipartFileUpload]
}

struct MessageResponse: Codable {
    var message: String
}

struct MessageInput {
    var conversationId: String
    var msg: String
    var files:[MultipartFileUpload]
}

protocol MessageAPIProtocol {
    func fetchConversations() -> AnyPublisher<[Conversation], AFError>
    func fetchConversation(id:Int) -> AnyPublisher<[Conversation], AFError>
    func fetchConversationMessages(id: String) -> AnyPublisher<[ConversationMessage], AFError>
    func markAsRead(id: String) -> AnyPublisher<MessageResponse, AFError>
    func deleteConversation(id: String) -> AnyPublisher<MessageResponse, AFError>
}


struct MessageAPI: MessageAPIProtocol {
    
    func deleteConversation(id: String) -> AnyPublisher<MessageResponse, Alamofire.AFError> {
        let url = "\(Enviorment.zalaMessages)conversation/deleteForUser/\(id)"
        return AF.request(url, method: .delete,
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
        .validate()
        .publishDecodable(type:MessageResponse.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func markAsRead(id: String) -> AnyPublisher<MessageResponse, Alamofire.AFError> {
        let url = "\(Enviorment.zalaMessages)readMessage/\(id)"
        return AF.request(url, method: .post,
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
        .validate()
        .publishDecodable(type:MessageResponse.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
//https://messaging-microservice-stg-022ac415e1e4.herokuapp.com/readMessage/136
    
    func fetchConversationMessages(id: String) -> AnyPublisher<[ConversationMessage], Alamofire.AFError> {
        let url = "\(Enviorment.zalaMessages)conversation/\(id)"
        return AF.request(url, method: .get,
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
        .validate()
        .publishDecodable(type:[ConversationMessage].self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func fetchConversations() -> AnyPublisher<[Conversation], Alamofire.AFError> {
        let url = "\(Enviorment.zalaMessages)conversations"
        return AF.request(url, method: .get,
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
        .validate()
        .publishDecodable(type:[Conversation].self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func fetchConversation(id: Int) -> AnyPublisher<[Conversation], Alamofire.AFError> {
        let url = "\(Enviorment.zalaMessages)conversation/info/\(id)"
        return AF.request(url, method: .post,
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
        .validate()
        .publishDecodable(type:[Conversation].self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}

@Observable class MessageService {
    var uploadProgress: Double = 0.0
    var isUploading: Bool = false
    var uploadCompleted: Bool = false
    var uploadError: String?
    var didUpdateMessage: Bool = false
    var hasUnreadMessages: Bool = false
    
    private var subs: Set<AnyCancellable> = []
    private let networking: MessageAPIProtocol = MessageAPI()
    var conversations: [Conversation] = []
    var messages: [ConversationMessage] = []
    var userLookup: [String: ConversationUser] = [:]
    
    
    func deleteConversation(conversation: Conversation) {
        networking.deleteConversation(id: "\(conversation.id)").sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.conversations.removeAll(where: {$0.id == conversation.id})
            didUpdateMessage.toggle()
        }
        .store(in: &subs)
    }
    func markAsRead(id: String) {
        networking.markAsRead(id: id).sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            didUpdateMessage.toggle()
        }
        .store(in: &subs)
    }
    
    func fetchMessages(id: String) {
        networking.fetchConversationMessages(id: id).sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.messages = response
        }
        .store(in: &subs)
    }
    
    func fetchConversation(id: Int, handler: @escaping (_ conversation: [Conversation]?) -> Void) {
        networking.fetchConversation(id: id).sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_):
                handler(nil)
                
            case .finished:()
            }
            
        } receiveValue: { response in
            if let convo = response.last {
                self.userLookup = convo.usersLookup
                handler(response)
            }
        }
        .store(in: &subs)
    }
    
    
    func fetchConversations() {
        self.conversations = []
        networking.fetchConversations().sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.conversations = response.reversed()
        }
        .store(in: &subs)
    }
    
    func fetchUnreadConversations() {
        networking.fetchConversations().sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            if response.first(where: {!$0.isRead()}) == nil {
                hasUnreadMessages = false
            } else {
                hasUnreadMessages = true
            }
        }
        .store(in: &subs)
    }
    
    func createConversation(input: ConversationInput) {
        let url = "\(Enviorment.zalaMessages)sendMessage"
        
        let encoder = JSONEncoder()
           guard let usersData = try? encoder.encode(input.users) else {
               return
           }
        // Create Authorization header
         let headers: HTTPHeaders = ["Authorization" :  "Bearer \(KeychainSwift().get(loginToken) ?? "")"]

        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(input.msg.utf8), withName: "message")
            multipartFormData.append(Data(input.title.utf8), withName: "title")
            multipartFormData.append(usersData, withName: "users")
            
            for (index, fileData) in input.files.enumerated() {
                multipartFormData.append(fileData.file, withName: "files", fileName: "file\(index + 1).png", mimeType: "image/png")
            }
        }, to: url, headers: headers)
        .uploadProgress { progress in
            self.uploadProgress = progress.fractionCompleted
        }
        .response { response in
            self.isUploading = false
            switch response.result {
            case .success(_):
                self.uploadCompleted = true                
                
            case .failure(let error):
                self.uploadError = error.localizedDescription
            }
        }
    }
    
    func createMessage(input: MessageInput) {
        let url = "\(Enviorment.zalaMessages)sendMessage"

        // Create Authorization header
         let headers: HTTPHeaders = ["Authorization" :  "Bearer \(KeychainSwift().get(loginToken) ?? "")"]

        AF.upload(multipartFormData: { multipartFormData in
            for (index, fileData) in input.files.enumerated() {
                multipartFormData.append(fileData.file, withName: "files", fileName: "file\(index + 1).png", mimeType: "image/png")
            }
            multipartFormData.append(Data(input.msg.utf8), withName: "message")
            multipartFormData.append(Data(input.conversationId.utf8), withName: "conversationId")
            
        }, to: url, headers: headers)
        .uploadProgress { progress in
            self.uploadProgress = progress.fractionCompleted
        }
        .response { response in
            self.isUploading = false
            switch response.result {
            case .success:
                self.uploadCompleted = true
            case .failure(let error):
                self.uploadError = error.localizedDescription
            }
        }
    }
}
