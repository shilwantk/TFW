//
//  ConversationMessage.swift
//  zala
//
//  Created by Kyle Carriedo on 6/11/24.
//

import Foundation
import SwiftSoup

struct MessageContent: Codable {
    var contentId: Int?
    var title: String?
    var videoUrl: String?
    var thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case contentId = "content_id"
        case title = "title"
        case videoUrl = "s3_video_url"
        case thumbnail = "s3_thumbnail"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.contentId = try container.decodeIfPresent(Int.self, forKey: .contentId)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.videoUrl = try container.decodeIfPresent(String.self, forKey: .videoUrl)
        self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
    }
}

struct MessageAttachment: Codable {
    var fileId: Int  //137,
    var fileName: String //"file1.png",
    var url: String // "https://zala-messaging-staging.s3.amazonaws.com/uploads/083ee79d56e1453dc227e53fb3794c9fa38b5655d01e5d1e6244ca98a9634100-file1.png?AWSAccessKeyId=AKIA3YZVOLVU7TMQ42UT&Expires=1718158265&Signature=bwgoK2ZCgLQAnAXST80EFMLa0aA%3D"
}

struct ConversationMessage: Codable {
    var messageId: Int // 272,
    var conversationId: Int // 152,
    var senderId: String? // "018fe82e-fb4a-7ccf-9369-820a6cfc7296",
    var recipientId: String? // null,
    var message: String? // "Hey Dave wanted to show you my gym setup let me know what you think!",
    var timestamp: String? // "2024-06-12T01:08:47.070Z",
    var content: [ZalaContent]? // null,
    var files: [MessageAttachment]?
    
    var markdown: String? {
        do {
            let doc = try SwiftSoup.parse(message ?? "")
            return try doc.text()
        } catch {
            return message
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
        case conversationId = "conversation_id"
        case senderId = "sender_uuid"
        case recipientId = "recipient_uuid"
        case message = "message_body"
        case timestamp = "timestamp"
        case content = "content"
        case files = "files"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.messageId = try container.decode(Int.self, forKey: .messageId)
        self.conversationId = try container.decode(Int.self, forKey: .conversationId)
        self.senderId = try container.decodeIfPresent(String.self, forKey: .senderId)
        self.recipientId = try container.decodeIfPresent(String.self, forKey: .recipientId)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp)
        self.content = try container.decodeIfPresent([ZalaContent].self, forKey: .content)
        self.files = try container.decodeIfPresent([MessageAttachment].self, forKey: .files)
    }
    
    func date() -> Date {        
        return DateFormatter.dateFromMultipleFormats(fromString: timestamp ?? "") ?? .now
    }
    
    func isYou() -> Bool {
        guard let userId = Network.shared.userId() else { return false }
        return userId.lowercased() == senderId
    }
    
    var hasContent: Bool {
        self.content?.count ?? 0 > 0
    }
    
    func hasFiles() -> Bool {
        if let files {
            return !files.isEmpty
        } else {
            return false
        }
    }
}
