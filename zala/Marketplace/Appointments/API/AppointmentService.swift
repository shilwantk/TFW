//
//  AppointmentService.swift
//  zala
//
//  Created by Kyle Carriedo on 4/12/24.
//

import Foundation
import SwiftUI
import ZalaAPI
import Observation

@Observable class AppointmentService {
    
    var appointments: [MarketplaceAppointmentService] = []
    var superUserAddress: [AddressModel] = []
    var selectedMarketplaceAppointment: MarketplaceAppointmentService? = nil
    var selectedAppointment: MarketplaceAppointmentService? = nil
    var groups: [AppointmentGroup] = [] //maybe set
    var daySchedules: [DayScheduleModel] = []
    var slots: [[Date]] = []
    var dismissView: Bool = false
    var selectedGroup: AppointmentGroup?
    var morning:[PersonAppointment] = []
    var afternoon:[PersonAppointment] = []
    var evening:[PersonAppointment] = []
    var didUpdateAppointment: Bool = false
    
    let calendar: Calendar = Calendar.autoupdatingCurrent
    
    var df: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent formatting
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }
    
    func fetchMyAppointments(date: Date) {
        clear()
        Network.shared.apollo.fetch(query: MyAppointmentsQuery(startEpoch: Int(date.startOfDay.timeIntervalSince1970),
                                                               endEpoch: Int(date.endOfDay!.timeIntervalSince1970),
                                                               labels: .some([.routineBanner])),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                let appointments = result.data?.me?.personAppointments?.nodes?.compactMap({$0?.fragments.personAppointment}) ?? []
                for appointment in appointments {
                    let scheduleDate = appointment.scheduleDate()
                    if scheduleDate.isMorning(timeZone: .current) {
                        self.morning.append(appointment)
                    } else if scheduleDate.isAfternoon(timeZone: .current) {
                        self.afternoon.append(appointment)
                    } else {
                        self.evening.append(appointment)
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    func fetchAppointmentByService(apptId: String, handler: @escaping (_ personAppointment: PersonAppointment?) -> Void) {
        
        Network.shared.apollo.fetch(query: AppointmentByServiceQuery(service: .null, status: .some([.booked, .cancelled, .confirmed, .pending]),labels: .some([.superUserProfile])),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                let appointments = result.data?.me?.personAppointments?.nodes?.compactMap({$0?.fragments.personAppointment}) ?? []
                if let appt = appointments.first(where: {$0.id == apptId}) {
                    handler(appt)
                }
            case .failure(_):
                handler(nil)
                break
            }
        }
    }
    
    func fetchAppointmentTimes(superUserOrgId: String, serviceId: String, date: Date, superUserId: String) {
        let date = df.string(from: date)
        Network.shared.apollo.fetch(query: SuperUserServiceBookSingleServiceQuery(id: .some(superUserOrgId),
                                                                                  service: .some(serviceId),
                                                                                  date: .some(date),
                                                                                  provider: .some(superUserId))){ response in
            switch response {
            case .success(let result):
                let times = result.data?.org?.service?.availableTimesIso ?? []
                let dates = times.compactMap({DateFormatter.dateFromMultipleFormats(fromString:$0)})
                if !times.isEmpty {
                    self.slots.append(dates)
                }
            case .failure(_):
                break
            }
        }
    }
    
    func fetchMoreOptions(superUserOrgId: String, serviceId: String, date: Date, superUserId: String) {
//        let nextSevenDays = (0..<30).compactMap { calendar.date(byAdding: .day, value: $0, to: date) }
        self.slots = []
        let monthDays = daysForThe(month: date)
        let queue = DispatchQueue(label: "more_options", qos: .background, attributes: .concurrent)
        let group = DispatchGroup()
        queue.async(group: group, execute: {
            for day in monthDays {
                group.enter()
                let dateString = self.df.string(from: day)
                Network.shared.apollo.fetch(query: SuperUserServiceBookSingleServiceQuery(id: .some(superUserOrgId),
                                                                                          service: .some(serviceId),
                                                                                          date: .some(dateString),
                                                                                          provider: .some(superUserId))) { response in
                    switch response {
                    case .success(let result):
                        let times = result.data?.org?.service?.availableTimesIso ?? []
                        let dates = times.compactMap({DateFormatter.dateFromMultipleFormats(fromString:$0)})
                        if !times.isEmpty {
                            self.slots.append(dates)
                        }
                        group.leave()
                    case .failure(_):
                        group.leave()
                        break
                    }
                }
            }
        })
        group.notify(queue: .main) {
        }
    }
    
    func clear() {
        appointments = []
        superUserAddress = []
        groups = []
        morning = []
        afternoon = []
        evening = []
    }
    
    func fetchMarketplaceAppointmentsFor(orgId: ID,
                                         isSubscribed: Bool,
                                         subscriptionServices: [String]) {
        clear()
        Network.shared.apollo.fetch(
            query: ViewingMarketplaceSuperUserAppointmentsQuery(id: orgId,
                                                                status:["active", "inactive"],
                                                                ordering: "status",
                                                                labels: .some([.routineBanner])),
            cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                
                self.appointments = result.data?.viewing?.org?.services?.compactMap({$0}).compactMap({$0.fragments.marketplaceAppointmentService}) ?? []
                self.superUserAddress = result.data?.viewing?.org?.users?.nodes?.compactMap({$0}).flatMap({$0?.addresses ?? []}).compactMap({$0.fragments.addressModel}) ?? []
                
                for appointment in self.appointments {
                    self.build(appointment: appointment)
                }
            case .failure(_):
                break
            }
        }
    }
    
    func subAppointmentsFor(orgId: ID, isSubscribed: Bool, subscriptionServices: [String]) {
        clear()
        Network.shared.apollo.fetch(
            query: ViewingMarketplaceSuperUserAppointmentsQuery(id: orgId,
                                                                status:["active", "inactive"],
                                                                ordering: "status",
                                                                labels: .some([.routineBanner])),
            cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                
                self.appointments = result.data?.viewing?.org?.services?.compactMap({$0}).compactMap({$0.fragments.marketplaceAppointmentService}) ?? []
                self.superUserAddress = result.data?.viewing?.org?.users?.nodes?.compactMap({$0}).flatMap({$0?.addresses ?? []}).compactMap({$0.fragments.addressModel}) ?? []
                
                for appointment in self.appointments {
                        self.build(appointment: appointment)
                }
                self.groups = self.groups.filter({subscriptionServices.contains($0.groupId)})
            case .failure(_):
                break
            }
        }
    }
    
    func createAppointment(groupId: String?,
                           superUser: SuperUser,
                           appointment: MarketplaceAppointmentService,
                           selectedTime: Date,
                           addressRequest: AddressRequest?,
                           additionalInfoRequest: AdditionalInfoRequest?,
                           handler: @escaping (_ apptId: String?) -> Void) {
        guard let person = Network.shared.userId() else { return }
        guard let provider = superUser.id else { return }
        guard let service = appointment.id else { return }
        guard let org = appointment.organizationId else { return }
        
        let kind: String = .appointment
        let startTime = Int(selectedTime.timeIntervalSince1970)
        guard let endDate = selectedTime.add(.minute, appointment.durationMins ?? 0) else { return }
        let endTime = Int(endDate.timeIntervalSince1970)
        
        
                
        var input = AppointmentCreateInput(
            org:.some(org),
            service: service,
            kind: kind,
            person: person,
            startEpoch: startTime,
            endEpoch: endTime,
            provider: .some(provider))
        
        var json: [String : AnyHashable] = [
            "sender": "consumer",
        ]
        
        if let groupId {
            json["groupService"] = groupId
        }
        
        if let addressRequest {
            json["travel"] = [
                "address": addressRequest.formattedStreet(),
                "city": addressRequest.city,
                "zip": addressRequest.zipcode,
                "state": addressRequest.state.title.lowercased(),
                "info": additionalInfoRequest?.info ?? ""
            ]
        }
        input.params = .some(JSON.dictionary(json))
        
        Network.shared.apollo.perform(mutation: AppointmentCreateMutation(input: .some(input))) { response in
            switch response {
            case .success(let result):
                let id = result.data?.apptCreate?.appointment?.id                
                handler(id)
                                
            case .failure(_):
                handler(nil)
            }
        }
    }
    
    func cancelAppointment(id: String) {
        Network.shared.apollo.perform(mutation: AppointmentCancelMutation(input: .some(.init(id: id)))) { response in
            switch response {
            case .success(_):
                self.didUpdateAppointment.toggle()
                                
            case .failure(_):
                self.didUpdateAppointment.toggle()
            }
        }
    }
}

//MARK: - Helpers
extension AppointmentService {
    
    func optionalTravelAddress() -> String? {
        if superUserAddress.isEmpty {
            return nil
        } else {
            return superUserAddress.compactMap({$0.csz}).joined(separator: "\n")
        }
    }
    
    func travelAddress() -> String {
        if superUserAddress.isEmpty {
            return "Suggest a location"
        } else {
            return superUserAddress.compactMap({$0.csz}).joined(separator: "\n")
        }
    }
    
    func next30Days(from: Date) -> [Date] {
        let next30Days = (0..<30).compactMap { calendar.date(byAdding: .day, value: $0, to: from) }
        return next30Days
    }
    
    func daysForThe(month: Date) -> [Date] {
        let monthNumber = calendar.component(.month, from: month)
        if let mayRange = calendar.range(of: .day, in: .month, for: month) {
            
            var mayComponents = DateComponents()
            mayComponents.year = calendar.component(.year, from: month)
            mayComponents.month = monthNumber // May
            
            
            let allDays = mayRange.compactMap { day -> Date? in
                mayComponents.day = day
                return calendar.date(from: mayComponents)
            }
                        
            return allDays
        } else {
            return []
        }
    }
    
    fileprivate func build(appointment: MarketplaceAppointmentService) {
        let type = appointment.type().lowercased()
        let cost = appointment.stripeProduct()?.defaultPrice?.unitAmount ?? 0
        let title = appointment.formattedTitle().lowercased()
        let desc = appointment.desc ?? ""
        let duration = appointment.durationMins ?? 0
        let groupPrimary = appointment.groupPrimary ?? false
        
        
        if let idx = self.groups.firstIndex(where: {$0.title.lowercased() == title.lowercased()}) {
            var foundGroup = self.groups[idx]
            var foundcost = foundGroup.cost
            var foundtype = foundGroup.types
            var foundservices = foundGroup.services
            var founddurations = foundGroup.durations
            founddurations.insert(duration)
            foundcost.append(cost)
            foundtype.insert(type)
            foundservices.append(appointment)
            foundcost = foundcost.sorted()
            foundGroup.cost = foundcost
            foundGroup.types = foundtype
            foundGroup.services = foundservices
            foundGroup.durations = founddurations
            self.groups.remove(at: idx)
            self.groups.insert(foundGroup, at: idx)
        } else if groupPrimary == true,
                  let groupId = appointment.id,
                    appointment.status == .active {
            //dont include global
            self.groups.append(AppointmentGroup(groupId: groupId,
                                                title: title,
                                                banner: appointment.banner(),
                                                services: [],
                                                types: [],
                                                cost: [],
                                                durations: [],
                                                desc: desc))
        }
    }
}
