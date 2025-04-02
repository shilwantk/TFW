//
//  PersonAppointment.swift
//  zala
//
//  Created by Kyle Carriedo on 5/4/24.
//

import Foundation
import ZalaAPI
import SwiftUI

extension PersonAppointment: @retroactive Identifiable {
    
    static let df = ISO8601DateFormatter()
    
    var isPast: Bool {
        scheduleDate().isInPast
    }
    
    func appointmentService() -> MarketplaceAppointmentService? {
        return service?.fragments.marketplaceAppointmentService
    }
    
    func formattedServiceTitle() -> String {
        return appointmentService()?.formattedTitle() ?? ""
    }
    
    func formattedServiceDuration() -> String {
        return appointmentService()?.duration() ?? ""
    }
    
    func formattedServicePrice() -> String {
        return appointmentService()?.formattedPrice() ?? "free"
    }
    
    func banner() -> String? {
        return appointmentService()?.banner()
    }
    
    func isTravel() -> Bool {
        return appointmentService()?.isTravel() ?? false
    }
    
    func isVirtual() -> Bool {
        return appointmentService()?.isVirtual() ?? false
    }
    
    func formattedProvider() -> String {
        let fristName = self.provider?.fragments.providerModel.firstName ?? ""
        let lastName = self.provider?.fragments.providerModel.lastName ?? ""
        let fullName = "\(fristName) \(lastName)"
        return fullName
    }
    
    func formattedProviderProfile() -> String? {
        return self.provider?.attachments?.first(where: {$0.label == .superUserProfileUrl})?.contentUrl
    }
    
    ///Pass in the type of address you want to get. billing or main
    func getAddress(type: String) -> AddressModel? {
        return appointmentService()?.getAddress(type: type)
    }
    
    func scheduleDate() -> Date {
        guard let scheduledAtIso else { return .now }
        guard let date = PersonAppointment.df.date(from: scheduledAtIso) else { return .now }
        return date
    }
    
    func formattedDateAndTime() -> String {
        guard let scheduledAtIso else { return "" }
        guard let date = PersonAppointment.df.date(from: scheduledAtIso) else { return "" }
        let dateModel = Date.dateStringFromDate(date: date, dateStyle: .medium, timeStyle: .none, isRelative: true)
        let time = Date.dateStringFromDate(date: date, dateStyle: .none, timeStyle: .short, isRelative: false)
        let appointmentTime = "\(dateModel) at \(time)"
        return appointmentTime
    }
    
    func formattedTime() -> String {
        let appointmentTime = formattedDateAndTime()
        let isTravel: Bool = appointmentService()?.isTravel() ?? false
        if isTravel {
            return "Requested: \(appointmentTime)"
        } else {
            return "Date: \(appointmentTime)"
        }
    }
    
    func statusColor() -> Color {
        return isPending() ? Theme.shared.orange : Theme.shared.lightBlue
    }
    
    func formattedStatus() -> String {
        let isTravel: Bool = appointmentService()?.isTravel() ?? false
//        let isVirtual: Bool = service()?.isVirtual() ?? false
        if isPending() {
            return isTravel ? "pending approval" : "pending"
        }
        else if isBooked() {
            return "appointment"
        }
        else if isCancel() {
            return "appointment cancelled"
        }
        else if isConfirmed() {
            return "appointment"
        }
        else if isExpired() {
            return "appointment expired"
        }
        else {
            return "unknown status \(self.status ?? "")"
        }
    }
    
    func isPending() -> Bool {
        return status?.lowercased() == "pending"
    }
    
    func isBooked() -> Bool {
        return status?.lowercased() == "booked"
    }
    
    func isCancel() -> Bool {
        return status?.lowercased() == "cancelled"
    }
    
    func isConfirmed() -> Bool {
        return status?.lowercased() == "confirmed"
    }
    
    func isExpired() -> Bool {
        return status?.lowercased() == "expired"
    }
    
    func addressRequest() -> AddressRequest? {
        return self.params.addressRequest()
    }
    
    func additionalInfoRequest() -> AdditionalInfoRequest? {
        return self.params.additionalInfoRequest()
    }
    
    func travelAddress() -> [AddressModel] {
        return self.provider?.addresses?.compactMap({$0.fragments.addressModel}) ?? []
    }
    
    
    
//    @State var addressRequest: AddressRequest?
//    @State var additionalInfoRequest: AdditionalInfoRequest?
    
}
