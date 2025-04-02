//
//  MySuperUsersService.swift
//  zala
//
//  Created by Kyle Carriedo on 4/9/24.
//

import Foundation
import SwiftUI
import ZalaAPI
import Apollo
import SwiftHTMLtoMarkdown

struct MarketPlaceSuperUser: Identifiable, Hashable {
    var id = UUID()
    var superUser: SuperUser
    var superUserOrG: SuperUserOrg
}

@Observable class MySuperUsersService {
    
    var superUsers: [SuperUser] = []
    var superUserLookup: [ID: SuperUserOrg] = [:]
    
    
    var selectedSuperUsers: [SuperUser] = []
    
    func superUserBy(id: String) -> SuperUser? {
        return superUsers.first(where: {$0.id?.lowercased() == id.lowercased()})
    }
    
    func browseAllSuperUsers(orgId: ID) {
        Network.shared.apollo.fetch(query: SuperUsersQuery(id: .some(orgId), labels: .some([])), cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                if let superOrgs = result.data?.org?.children?.compactMap({$0.fragments.superUserOrg}) {
                    let data = superOrgs.compactMap({$0.providers}).compactMap({$0.nodes?.compactMap({$0?.fragments.superUser})}).flatMap({$0})
                    self.superUsers = self.removeDuplicateUsers(users: data).sorted(by: {$0.firstName ?? "" < $1.firstName ?? ""})
                    self.buildLookup(orgs: superOrgs)
                }
            case .failure(_):
                break
            }
        }
    }
    
    func removeDuplicateUsers(users: [SuperUser]) -> [SuperUser] {
        var uniqueUsersDict = [ID: SuperUser]()
        
        for user in users {
            let key = user.id!
            // Only insert if fullNameKey doesn't exist yet (to preserve the first occurrence)
            if uniqueUsersDict[key] == nil {
                uniqueUsersDict[key] = user
            }
        }
        
        // Return the array of unique users
        return Array(uniqueUsersDict.values)
    }
    
    
    fileprivate func buildLookup(orgs: [SuperUserOrg]) {
        for org in orgs {
            for provider in org.providers?.nodes ?? [] {
                if let id = provider?.id {
                    superUserLookup[id] = org
                }
            }
        }
    }
        
}


struct SuperUserTag: Codable, Hashable {
    let category: String
    let value: String
}

struct Certificate: Codable, Hashable {
    let id: Int
    let title: String
    let location: String
    let date: String
    let info: String
}

extension SuperUser {
    
    var allTags: [String] {
        return tags().compactMap({$0.value})
    }
    
    var formattedTags: String {
        let tags = allTags
        let first3Tags = tags.prefix(3)
        let prefixString = first3Tags.joined(separator: ", ")
        if tags.count > 3 {
            return "\(prefixString), +\(tags.count)"
        } else {
            return prefixString
        }
    }
    
    var bio: String? {
        guard let bioPreferences = self.preferences?.first(where: {$0.key?.lowercased() == .superUserBio})?.value?.last else { return nil }
        var document = BasicHTML(rawHTML: bioPreferences)
        do {
            try document.parse()
            let markdown = try document.asMarkdown()
            return markdown
        } catch {
            return bioPreferences
        }
    }
    
    static func == (lhs: SuperUser, rhs: SuperUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func hasWelcomeVideo() -> Bool {
        return self.attachments?.first(where: {$0.label?.lowercased() == .superUserWelcomeVideoUrl})?.contentUrl != nil
    }
    
    func welcomeVideo() -> String? {
        return self.attachments?.first(where: {$0.label?.lowercased() == .superUserWelcomeVideoUrl})?.contentUrl
    }
    
    func fullName() -> String {
        guard let firstName else { return "" }
        guard let lastName else { return "" }
        return "\(firstName) \(lastName)"
    }
    
    func introVideo() -> String? {
        return self.attachments?.first(where: {$0.label?.lowercased() == .superUserProfileVideoUrl})?.contentUrl
    }
    
    func focustags() -> [String] {
        var data:[String] = []
        if let main = mainFocus() {
            data.append(main)
        }
        if let secondary = secondaryFocus() {
            data.append(secondary)
        }
        return data
    }
    
    
    func certificates() -> [Certificate] {
        guard let jsonString = self.preferences?.first(where: {$0.key?.lowercased() == .userCertificates})?.value?.last else { return [] }
        guard let certs: [Certificate] = jsonString.decodeJSON(to: [Certificate].self) else { return [] }
        return certs
    }
    
    func tags() -> [SuperUserTag] {
        guard let jsonString = self.preferences?.first(where: {$0.key?.lowercased() == .userTags})?.value?.last else { return [] }
        guard let tags: [SuperUserTag] = jsonString.decodeJSON(to: [SuperUserTag].self) else { return [] }
        return tags
    }
    
    func mainFocus() -> String? {
        return self.preferences?.first(where: {$0.key?.lowercased() == .superUserMainFocus})?.value?.last
    }
    
    func secondaryFocus() -> String? {
        return self.preferences?.first(where: {$0.key?.lowercased() == .superUserSecondaryFocus})?.value?.last
    }
    
    func consent() -> String? {
        return self.preferences?.first(where: {$0.key?.lowercased() == .superUserConsent})?.value?.last
    }
    
    func profileUrl() -> String? {
        return self.attachments?.last(where: {$0.label?.lowercased() == .superUserProfileUrl})?.contentUrl
    }
    
    var myOrg: Organization? {
        return self.organizations?.first(where: { org in
            org.providers?.nodes?.first(where: {$0?.id == self.id}) != nil
        })
    }
    
    
    static let previewUser = SuperUser(_dataDict: DataDict(data: [:], fulfilledFragments: []))
}

