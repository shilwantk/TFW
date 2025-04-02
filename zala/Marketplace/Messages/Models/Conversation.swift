//
//  Conversation.swift
//  zala
//
//  Created by Kyle Carriedo on 6/10/24.
//

import Foundation

struct ConversationUser: Codable {
    var name: String // "Keith Johns",
    var uuid: String //"018fefd2-ad62-75b6-ae80-7995422f51ba"
    
    init(name: String, uuid: String) {
        self.name = name
        self.uuid = uuid
    }
}

struct Conversation: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        lhs.id == rhs.id || lhs.latestMessage == rhs.latestMessage
    }
    
    var id: Int {
        conversationId
    }
    var conversationId : Int //: 139,
    var createdAt : String? //: "2024-06-09T20:16:02.353Z",
    var updatedAt : String? //: "2024-06-09T20:16:02.353Z",
    var title : String? //: "Multiple Users Supported",
    var latestMessage : String? //: "checking files and content",
    var latestMessageSender : String? //: "018fefd2-ad62-75b6-ae80-7995422f51ba",
    var read : Bool? //: true,
    var length : Int? //: 1,
    var sorted: [ String]  //"018fe82e-fb4a-7ccf-9369-820a6cfc7296", "018fefd2-ad62-75b6-ae80-7995422f51ba", "b036f15f-c912-48a0-9771-15c9e1f72767"
    var readBy: [String]? // null,
    var users: [ConversationUser]
    var deletedBy: [String]? // null
    
    
    enum CodingKeys: String, CodingKey {
        case conversationId = "conversation_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case title = "title"
        case latestMessage = "latest_message"
        case latestMessageSender = "latest_message_sender"
        case read = "read"
        case length = "length"
        case sorted = "sorted_uuids"
        case readBy = "read_by"
        case users = "users"
        case deletedBy = "deleted_by"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.conversationId = try container.decode(Int.self, forKey: .conversationId)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.latestMessage = try container.decodeIfPresent(String.self, forKey: .latestMessage)
        self.latestMessageSender = try container.decodeIfPresent(String.self, forKey: .latestMessageSender)
        self.read = try container.decodeIfPresent(Bool.self, forKey: .read)
        self.length = try container.decodeIfPresent(Int.self, forKey: .length)
        self.sorted = try container.decode([String].self, forKey: .sorted)
        self.readBy = try container.decodeIfPresent([String].self, forKey: .readBy)
        self.users = try container.decode([ConversationUser].self, forKey: .users)
        self.deletedBy = try container.decodeIfPresent([String].self, forKey: .deletedBy)
    }
    
    func isRead() -> Bool {
        guard let userId = Network.shared.userId() else { return false }
        guard let readBy = readBy else { return false }
        return readBy.contains(userId)
    }
    
    func latestSender() -> ConversationUser? {
        return users.first(where: {$0.uuid.lowercased() == latestMessageSender?.lowercased()})
    }
    
    func createAtDate() -> Date {
        if let createdAt {
            return DateFormatter.dateFromMultipleFormats(fromString: createdAt) ?? .now
        } else {
            return .now
        }
    }
    
}
