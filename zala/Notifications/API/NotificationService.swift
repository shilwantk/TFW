//
//  NotificationService.swift
//  zala
//
//  Created by Kyle Carriedo on 5/4/24.
//

import Foundation
import SwiftUI
import ZalaAPI
import Observation

@Observable class NotificationService {
    
    var notifications: [NotificationModel] = []
    var unreadCount: Int = 0
    var newNotification: Bool = false
    var didUpdateNotification: Bool = false
    
    func fetchNotifications() {
        Network.shared.apollo.fetch(query: NotificationsQuery(), cachePolicy: .fetchIgnoringCacheCompletely){ response in
            switch response {
            case .success(let result):
                self.notifications =  result.data?.me?.notifications?.nodes?.compactMap({$0?.fragments.notificationModel}) ?? []
                self.unreadCount = self.notifications.filter({$0.readAtIso == nil}).count
                self.newNotification = self.unreadCount > 0
            case .failure(_):
                break
            }
        }
    }
    
    func removeNotification(id: String) {
        Network.shared.apollo.perform(mutation: NotificationRemoveMutation(input: IDInput(id: id))) { response in
            switch response {
            case .success(_):
                self.didUpdateNotification.toggle()
                
            case .failure(_):
                break
            }
        }
    }
    
    func markAsRead(id: String, handler: ((Bool) -> Void)? = nil) {
        guard let userId = Network.shared.userId() else { return }
        DispatchQueue.global(qos: .background).async(execute: {
            Network.shared.apollo.perform(mutation: NotificationMarkReadMutation(input: UserNotificationMarkReadInput(id: .some(id), user: .some(userId)))){ response in
                switch response {
                case .success(_):
                    handler?(true)
                    self.didUpdateNotification.toggle()
                    
                case .failure(_):
                    handler?(false)
                    break
                }
            }
        })
    }
    
    func createNotification(receiverId: String, subject: String, content:[String: Any], handler: ((Bool) -> Void)? = nil) {
        guard let contentString = content.jsonString() else { return }
        Network.shared.apollo.perform(mutation: NotificationCreateMutation(input: UserNotificationCreateInput(user: .some(receiverId),
                                                                                                              subject: subject,
                                                                                                              content: contentString))) { response in
            switch response {
            case .success( _):
                handler?(true)
                self.didUpdateNotification.toggle()
                
            case .failure(_):
                handler?(false)
                break
            }
        }
    }        
}
