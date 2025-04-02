//
//  ConsentField.swift
//  zala
//
//  Created by Kyle Carriedo on 9/18/24.
//

import Foundation
import UIKit
import SwiftUI

enum ConsentFieldType: String, Codable {
    case none
    case textfield
    case datepicker
    case datetimepicker
    case checkbox
    case checkboxwithvalue
    case signature
    case label
    case multiselect
    case texteditor
    case autodate
    case divider
    case spacer
}

struct ConsentField: Codable {
    var key: String? // "last name",
    var content: String?
    var value: String // "",
    var selection: String? // "yes/no used in checkbox",
    var type: ConsentFieldType // "textfield",
    var validation: String? // "none",
    var required: Bool? // false
    
    var dateValue: Date = Date()
    var selectionValue:Bool = false
    var sigImage: UIImage? = nil
    var autoDate: String = Date.dateStringFromDate(date: Date(), dateStyle: .medium, timeStyle: .short, isRelative: false)
    
    enum CodingKeys: CodingKey {
        case key
        case content
        case value
        case type
        case validation
        case selection
        case required
    }
    
    init(key: String? = nil, content: String? = nil, value: String, selection: String? = nil, type: ConsentFieldType, validation: String? = nil, required: Bool? = nil, dateValue: Date, selectionValue: Bool, sigImage: UIImage? = nil, autoDate: String) {
        self.key = key
        self.content = content
        self.value = value
        self.selection = selection
        self.type = type
        self.validation = validation
        self.required = required
        self.dateValue = dateValue
        self.selectionValue = selectionValue
        self.sigImage = sigImage
        self.autoDate = autoDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decodeIfPresent(String.self, forKey: .key)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.value = try container.decode(String.self, forKey: .value)
        self.type = try container.decode(ConsentFieldType.self, forKey: .type)
        self.selection = try container.decodeIfPresent(String.self, forKey: .validation)
        self.validation = try container.decodeIfPresent(String.self, forKey: .validation)
        self.required = try container.decodeIfPresent(Bool.self, forKey: .required)
    }
    
    func isComplete() -> Bool {
        guard let req = required else { return true} //if no required it passes
        return req && !value.isEmpty
    }
}
