//
//  ZalaContent.swift
//  zala
//
//  Created by Kyle Carriedo on 4/25/24.
//

import Foundation

struct AccessibilitySubscription: Codable, Hashable {
    var id: String// "prod_OaFORzh2Ts2IsL",
    var name: String //"Gold"
}

struct ZalaContent: Codable, Hashable, Identifiable {
    var id: Int {
        postId ?? contentId
    }
    var contentId: Int // 15,
    var title: String // "Test Content",
    var description: String // "testing edit functionality with new files",
    var video: String? //
    var thumbnail: String? //
    var createdAt: String // "2024-04-20T14:25:32.573Z",
    var updatedAt: String? // "2024-04-20T14:25:32.573Z",
    var scheduled: Bool?
    var creatorUser: String? // "dfeb86d5-e4cf-4e48-87af-fdd0de9ae1c3",
    var creatorName: String? // "Keith Johns",
    var creatorUrl: String // "yaddayadda",
    var accessibility: [AccessibilitySubscription]? // [String],
    var tags: [String]? // [String],
    var publishTime: String? // null,
    var postId: Int? //20
//    var orgId: String? // "e58f9bf4-7c0f-4f2a-a900-da885cd499cc",
    var zalaLibrary: Bool? // true
    var posted: [String]? //[2024-04-20T14:25:32.573Z]
    var likes: Int? //
    var dislikes: Int? //
    var views: Int? //
    var liked: Bool?
    var disliked: Bool?
    var viewed: Bool?
    var descriptionMarkup: String?
    
    var isPhoto: Bool {
        return video == nil && thumbnail != nil
    }
    
    var isVideo: Bool {
        return video != nil && thumbnail != nil
    }
    
    
    func dateTime() -> String {
        if let publishTime {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.hour, .minute, .second]
            //            2024-04-20T17:00:00.000Z
            if let date = DateFormatter.dateFromMultipleFormats(fromString: publishTime) {
                if Calendar.autoupdatingCurrent.isDateInToday(date),
                   let timeString = formatter.string(from: date, to: .now) {
                    return timeString
                } else {
                    return DateFormatter.monthDay(date: date)
                }
            } else {
                return "-"
            }
        } else if let date = DateFormatter.dateFromMultipleFormats(fromString: createdAt) {
            return DateFormatter.monthDay(date: date)
        } else {
            return "-"
        }
    }
    
    /// <#Description#>
    enum CodingKeys: String, CodingKey {
        case contentId = "content_id"
        case title = "title"
        case description = "description"
        case descriptionMarkup = "description_markup"
        case video = "s3_video_url"
        case thumbnail = "s3_thumbnail"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case creatorUser = "creator_user_uuid"
        case creatorName = "creator_name"
        case creatorUrl = "creator_profile_url"
        case accessibility = "accessibility"
        case tags = "tags"
        case publishTime = "publish_time"
//        case orgId = "org_id"
        case zalaLibrary = "zala_library"
        case scheduled = "scheduled"
        case posted = "posted"
        case postId = "post_id"
        case likes = "likes"
        case dislikes = "dislikes"
        case views = "views"
        case liked = "liked"
        case disliked = "disliked"
        case viewed = "viewed"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(contentId)
    }
}
