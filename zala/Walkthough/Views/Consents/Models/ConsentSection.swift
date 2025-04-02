//
//  ConsentSection.swift
//  zala
//
//  Created by Kyle Carriedo on 9/18/24.
//

import Foundation

struct ConsentSection: Codable {
    var title: String? // "Section 1:  Subject Information",
    var subtitle: String? // "",
    var content: String? // "",
    var disclaimer: String? // "",
    var fields:[ConsentField]
    
    enum CodingKeys: CodingKey {
        case title
        case subtitle
        case content
        case disclaimer
        case fields
    }
    
    init(title: String? = nil, subtitle: String? = nil, content: String? = nil, disclaimer: String? = nil, fields: [ConsentField]) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.disclaimer = disclaimer
        self.fields = fields
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.disclaimer = try container.decodeIfPresent(String.self, forKey: .disclaimer)
        self.fields = try container.decode([ConsentField].self, forKey: .fields)
    }
}
