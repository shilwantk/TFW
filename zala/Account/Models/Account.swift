//
//  Account.swift
//  zala
//
//  Created by Kyle Carriedo on 4/19/24.
//

import Foundation
import SwiftUI
import ZalaAPI

extension Account {
    func age() -> String {
        if let dateOfBirth = self.dob {
            return String(Date.ageFromDateOfBirth(dob: dateOfBirth))
        } else {
            return "-"
        }
    }
    
    func profileAttachment() -> AttachmentModel? {
        if let attachment = self.attachments?.filter({$0.fragments.attachmentModel.label == .superUserProfile}).last?.fragments.attachmentModel {
            return attachment
        } else {
            return nil
        }
    }
    
    func profileURL() -> String {
        if let attachment = self.attachments?.filter({$0.fragments.attachmentModel.label == .superUserProfile}).last?.fragments.attachmentModel {
            return attachment.contentUrl ?? ""
        } else {
            return ""
        }
    }
    
    func profileColor() -> String {
        let defaultBlue = "0DAAE4" //Check theme
        guard let preference = self.preferences?.compactMap({$0.fragments.preferenceModel}).filter({ (pref) -> Bool in
            return pref.key == .profileColor
        }).last else {
            return defaultBlue
        }
        return preference.value?.last ?? defaultBlue
    }
    
    func dobDate() -> Date? {
        if let dobString = self.dob {
            return Date.yearMonthDayDateFromString(dateString: dobString)
        } else {
            return nil
        }
    }
    
    func formattedDOB() -> String {
        if let dobString = self.dob {
            
            return Date.dateStringFromDate(date: Date.yearMonthDayDateFromString(dateString: dobString), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none, isRelative: true)
        } else {
            return "{DOB_MISSING}"
        }
    }
    
    func formattedDOBWithAge() -> String? {
        guard let dob = self.dob else { return nil }
        let age = self.age()
        let date = Date.yearMonthDayDateFromString(dateString: dob)
        let dobString = Date.dateStringFromDate(date: date, dateStyle: .medium, timeStyle: .none, isRelative: false)
        return "\(dobString) - \(age) old"
    }
    
    func formattedDOB() -> String? {
        guard let dob = self.dob else { return nil }
        let date = Date.yearMonthDayDateFromString(dateString: dob)
        return Date.dateStringFromDate(date: date, dateStyle: .medium, timeStyle: .none, isRelative: false)
    }
    
    func formattedDOB(style: DateFormatter.Style) -> String? {
        guard let birthday = self.dob else { return nil }
        return Date.dateStringFromDate(date: Date.yearMonthDayDateFromString(dateString: birthday), dateStyle: style, timeStyle: .none, isRelative: false)
    }
    
    func formattedEmail() -> String? {
        let model = self.emails?.compactMap({$0.fragments.emailModel}).filter({ (model) -> Bool in
            model.label == .mainLabel
        }).last
        return model?.address
    }
    
    func formattedPhone() -> String? {
        let model = self.phones?.compactMap({$0.fragments.phoneNumberModel}).filter({ (model) -> Bool in
            model.label == .mainLabel
        }).last
        return model?.number
    }
    
    
    ///Pass in the type of address you want to format. billing or main
    func formattedAddress(addressType:AddressType) -> String? {
        guard let addressModel = self.getAddress(type: addressType) else { return nil }
        return addressModel.address ?? ""
    }
    
    ///Pass in the type of address you want to get. billing or main
    func getAddress(type: AddressType) -> AddressModel? {
        let model = self.addresses?.compactMap({$0.fragments.addressModel}).filter({ (model) -> Bool in
            return model.label?.lowercased() == type.rawValue.lowercased()
        }).last
        return model
    }
    
    ///Pass in the type of phone you want to get. (Main sms etc....)
    func getPhones(type: PhoneType) -> PhoneNumberModel? {
        let model = self.phones?.compactMap({$0.fragments.phoneNumberModel}).filter({ (model) -> Bool in
            return model.label == type.rawValue
        }).last
        return model
    }

    func getPreference(key: String) -> PreferenceModel? {
        return self.preferences?.compactMap({$0.fragments.preferenceModel}).first(where: {$0.key == key})
    }
    
    func getStripeCustomerId() -> String? {
        return getPreference(key: .stripeCustomerId)?.value?.first
    }
    
    func hasStripeCustomerId() -> Bool {
        return getPreference(key: .stripeCustomerId)?.value?.first != nil
    }
    
    
//    func userLanguage() -> String {
//        if let preference = self.preferences?.compactMap({$0.fragments.preferenceModel}).filter({$0.key == Preferences.locale || $0.key == Preferences.old_locale}).last {
//            return preference.value?.last ?? "en"
//        } else {
//            return "en"
//        }
//    }
//
//    func userUnit() -> String {
//        if let preference = self.preferences?.compactMap({$0.fragments.preferenceModel}).filter({$0.key == Preferences.units || $0.key == Preferences.old_units}).last {
//            return preference.value?.last ?? "us"
//        } else {
//            return "us"
//        }
//    }
}
