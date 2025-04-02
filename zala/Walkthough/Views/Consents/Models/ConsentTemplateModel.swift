//
//  ConsentTemplateModel.swift
//  zala
//
//  Created by Kyle Carriedo on 9/18/24.
//

import Foundation
import SwiftUI

struct ConsentTemplateModel: Codable {
    var title: String
    var subtitle: String?
    var logo: String?
    var alignment: String?
    var banner: String?
    var content: String?
    var footer: String?
    var sections: [ConsentSection]
    
    enum CodingKeys: CodingKey {
        case title
        case subtitle
        case logo
        case banner
        case content
        case footer
        case alignment
        case sections
    }
    
    init(title: String, subtitle: String? = nil, alignment: String? = nil, logo: String? = nil, banner: String? = nil, content: String? = nil, footer: String? = nil, sections: [ConsentSection]) {
        self.title = title
        self.subtitle = subtitle
        self.alignment = alignment
        self.logo = logo
        self.banner = banner
        self.content = content
        self.footer = footer
        self.sections = sections
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.logo = try container.decodeIfPresent(String.self, forKey: .logo)
        self.banner = try container.decodeIfPresent(String.self, forKey: .banner)
        self.alignment = try container.decodeIfPresent(String.self, forKey: .alignment)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.footer = try container.decodeIfPresent(String.self, forKey: .footer)
        self.sections = try container.decode([ConsentSection].self, forKey: .sections)
    }
    
    static let `default` = ConsentTemplateModel(title: "", sections: [])
    
    func alignmentGuide() -> TextAlignment {
        return self.alignment == "center" ? .center : .leading
    }
        
//    static func buildConsent(json: String) -> ConsentTemplateModel? {
//        guard let data = json.jsonData else {return nil }
//        do {
//            return try JSONDecoder().decode(ConsentTemplateModel.self, from: data)
//        } catch {
//            return nil
//        }
//    }
    
}
