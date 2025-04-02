//
//  RoutineService.swift
//  zala
//
//  Created by Kyle Carriedo on 4/10/24.
//

import Foundation
import SwiftUI
import ZalaAPI

@Observable class RoutineService {
    
    var routines: [MinCarePlan] = []
    var selectedMarketplaceRoutine: MarketPlaceRoutine? = nil
    var accepted: Bool = false
    var didEndPlan: Bool = false
    
    func myRoutines() {
        guard let userId = Network.shared.userId() else { return }
        Network.shared.apollo.fetch(query: RoutinesQuery(id: .some(userId), 
                                                         order: .some("-createdAt"),
                                                         status: .some(["active"]),
                                                         labels: .some([.superUserProfile, .routineBanner]),
                                                         taskStatus: .some(.active)),
                                    cachePolicy: .fetchIgnoringCacheCompletely){ response in
            switch response {
            case .success(let result):
                let data = result.data?.user?.carePlans?.compactMap({$0.fragments.minCarePlan}) ?? []
                self.routines = data.filter({$0.numberOfDaysRemaining() >= 0})
                let expiredIds = data.filter({$0.numberOfDaysRemaining() < 0}).compactMap { $0.id }
                if !expiredIds.isEmpty {
                    self.endMultiplePlans(ids: expiredIds) { complete in }
                }
            case .failure(_):
                break
            }
        }
    }
    
    func fetchRoutinesFor(orgID: ID, superUser: ID) {
        
        Network.shared.apollo.fetch(query: ViewingRoutinesQuery(id: .some(orgID),
                                                                user: .some(superUser),
                                                                order: .some("-createdAt"),
                                                                status: .some(["draft"]),
                                                                labels: .some([.superUserProfile, .routineBanner]),
                                                                taskStatus: .null), 
                                    cachePolicy: .fetchIgnoringCacheCompletely){ response in
            switch response {
            case .success(let result):
                self.routines = result.data?.viewing?.org?.carePlans?.compactMap({$0.fragments.minCarePlan}) ?? []
            case .failure(_):
                break
            }
        }
    }
    
    func marketplaceRoutineDetail(orgId: ID, routineId: ID) {
        Network.shared.apollo.fetch(query: MarketPlaceRoutineDetailsQuery(id: .some(orgId), 
                                                                          ids: .some([routineId]),
                                                                          labels: .some([.routineBanner]),
                                                                          taskStatus: .null),
                                    cachePolicy: .fetchIgnoringCacheCompletely){ [self] response in
            switch response {
            case .success(let result):
                self.selectedMarketplaceRoutine = result.data?.org?.carePlans?.compactMap({$0.fragments.marketPlaceRoutine}).last
                
            case .failure(_):
                break
            }
        }
    }
    
    func marketplaceEndPlan(routineId: ID) {
        Network.shared.apollo.perform(mutation: RoutineCompleteMutation(input: .some(IDInput(id: routineId)))) { [self] response in
            switch response {
            case .success(_ ):
                didEndPlan.toggle()
                
            case .failure(_):
                break
            }
        }
    }
    
    func marketplaceRoutineForUser(routineId: ID, all: Bool = false) {
        guard let userId = Network.shared.userId() else { return }
        Network.shared.apollo.fetch(query: MarketPlaceRoutineForUserQuery(id: .some(userId), 
                                                                          ids:.some([routineId]),
                                                                          labels: .some([.routineBanner]),
                                                                          taskStatus: all ? .null : .some(.active)),
                                    cachePolicy: .fetchIgnoringCacheCompletely) { [self] response in
            switch response {
            case .success(let result):
                self.selectedMarketplaceRoutine = result.data?.user?.carePlans?.compactMap({$0.fragments.marketPlaceRoutine}).last
                
            case .failure(_):
                break
            }
        }
    }
    
    
    func accept(routineId: ID) {
        Network.shared.apollo.perform(mutation: RoutineAcceptMutation(input: .some(CarePlanAcceptInput(id: routineId)))){ [self] response in
            switch response {
            case .success( _):
                    accepted.toggle()
            case .failure(_):
                break
            }
        }
    }    
    
    //MARK: - Used for auto assigning routines after subscription
    func assignRoutine(id: ID, title: String, handler: @escaping (Bool) -> Void) {
        guard let userId = Network.shared.userId() else { return }
        Network.shared.apollo.perform(mutation: AssignHabitPlanMutation(input: .some(CarePlanAssignInput(
            id: id,
            user: userId,
            inviteMessage: .some("Welcome to your \(title)! This plan will help you track your progress and live a healthier life."))))) { response in
            switch response {
            case .success(_):
                self.acceptRoutine(id: id) { complete in
                    handler(complete)
                }
            case .failure(_):
                handler(true)
            }
        }
    }
    
    //Step 4
    private func acceptRoutine(id: String, handler: @escaping (Bool) -> Void) {
        Network.shared.apollo.perform(mutation: RoutineAcceptMutation(input: .some(CarePlanAcceptInput(id: id)))) { response in
            switch response {
            case .success(_):
                handler(true)
                
            case .failure(_):
                handler(true)
                
            }
        }
    }
    
    
    fileprivate func endMultiplePlans(ids: [ID], handler: @escaping (Bool) -> Void) {
        guard !ids.isEmpty else { return }
        let queue = DispatchQueue(label: "end_plans", qos: .background, attributes: .concurrent)
        let group = DispatchGroup()
        queue.async(group: group, execute: {
            for id in ids {
                group.enter()
                Network.shared.apollo.perform(mutation: RoutineCompleteMutation(input: .some(IDInput(id: id)))) { response in
                    switch response {
                    case .success(_):
                        group.leave()
                        
                    case .failure(_):
                        group.leave()
                        
                    }
                }
            }
        })
        group.notify(queue: .main) {            
            handler(true)
        }
    }
}

extension MarketPlaceRoutine {
    func banner() -> String? {
        return attachments?.first(where: {$0.label == .routineBanner})?.contentUrl
    }
}

extension MinCarePlan {
    static let previewPlan = MinCarePlan(_dataDict: DataDict.init(data: [:], fulfilledFragments: []))
    
    func banner() -> String? {
        let attachments = self.attachments ?? []
        return attachments.first(where: {$0.label == .routineBanner})?.contentUrl
    }
}
