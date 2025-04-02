//
//  MarketplaceAppointmentService.swift
//  zala
//
//  Created by Kyle Carriedo on 4/29/24.
//

import Foundation
import ZalaAPI

struct TravelDistance: Codable {
    var miles: String? //"45",
    var address: String? //"Cutler Bay FL, 33157"
    
    func formattedDistance() -> String {
        guard let address, let miles else { return "Distance Missing" }
        return "\(address): within \(miles) miles."
    }
}

enum AppointmentType {
    case virtual
    case travel
    case inPerson
    
    var title: String {
        switch self {
        case .virtual: "Virtual Appointment Booked"
            
        case .travel: "Travel Appointment"
            
        case .inPerson: "Appointment Booked"
            
        }
    }
    
    var msg: String {
        switch self {
        case .virtual: "Your virtual appointment has been booked successfully."
            
        case .travel: "Your appointment request as been sent."
            
        case .inPerson: "Your appointment request as been sent."
            
        }
    }
}

extension MarketplaceAppointmentService: @retroactive Identifiable {
    func banner() -> String? {
        return attachments?.first(where: {$0.label == .routineBanner})?.contentUrl
    }
    
    ///Pass in the type of address you want to format. billing or main
    func formattedAddress(addressType: String) -> String? {
        guard let addressModel = self.getAddress(type: addressType) else { return nil }
        return addressModel.address ?? ""
    }
    
    ///Pass in the type of address you want to get. billing or main
    func getAddress(type: String) -> AddressModel? {
        return addresses.first(where: {$0.label?.lowercased() == type.lowercased()})?.fragments.addressModel
    }
    
    func duration() -> String {
        return "\(durationMins ?? 0)min"
    }
    
    func type() -> String {
        if isTravel() {
            return "Travel"
        } else {
            return supportsVirtual ?? false ? "Virtual" : "In Person"
        }        
    }
    
    func formattedTitle() -> String {
        return title ?? "Appointment"
    }
    
    func isVirtual() -> Bool {
        return addresses.isEmpty && supportsVirtual ?? false
    }
    
    
    func isTravel() -> Bool {
        return addresses.isEmpty && !isVirtual()
    }
//    func isTravelAppointment(addressToCheck:[AddressModel]) -> Bool {
//        guard !addresses.isEmpty else { return false }
//        guard let serviceAddress = self.addresses.first else { return false }
//        guard let address = addressToCheck.first(where: {$0.address?.lowercased() == serviceAddress.address?.lowercased()}) else { return false }
//        return isVirtual() ? false :  true
//    }
    
    func travelDistances() ->  [TravelDistance] {
        if let params,
           let data = params._jsonValue as? [String: AnyHashable],
           let stripeJson = data["travelDistances"] as? [[String: Any]] {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: stripeJson, options: [])
                let travel = try JSONDecoder().decode([TravelDistance].self, from: jsonData)
                return travel
            } catch {
                return []
            }
        } else {
            return []
        }
    }
    
    func stripeProduct() -> StripeProduct? {
        if let params,
           let data = params._jsonValue as? [String: AnyHashable],
           let stripeJson = data["stripeProduct"] as? [String: Any] {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: stripeJson, options: [])
                let stripeProduct = try JSONDecoder().decode(StripeProduct.self, from: jsonData)
                return stripeProduct
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func formattedTravelDistance() -> String {
        return travelDistances().compactMap({$0.formattedDistance()}).joined(separator: "\n")
    }
    
    func formattedPrice() -> String {
        return stripeProduct()?.formattedPrice() ?? "Free"
    }
}
