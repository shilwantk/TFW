//
//  StripeService.swift
//  zala
//
//  Created by Kyle Carriedo on 4/13/24.
//

//import Foundation
//stripeURL

import Foundation
import Alamofire
import Combine
import SwiftUI
import ZalaAPI
import KeychainSwift

struct PaymentIntent: Codable {
    var id: String
    var client_secret: String
    var customer: String
}

struct CheckoutSession: Codable, Identifiable, Equatable {
    var id: String
    var url: String
}

struct StripProductResponse:Codable {
    var object: String
    var data: [StripeProduct]
    var has_more: Bool
    var next_page: String?
}

protocol StripeServiceAPIProtocol {
    func paymentIntent(priceId: String, type:String) -> AnyPublisher<PaymentIntent, AFError>
    func checkout(priceId: String, type:String, userId: String) -> AnyPublisher<CheckoutSession, AFError>
    func fetchSubscriptionsFor(superUser: String, category: String) -> AnyPublisher<StripProductResponse, AFError>
    func fetchCustomer() -> AnyPublisher<StripeCustomer, AFError>
    func fetchCustomerSubscriptions(status:String) -> AnyPublisher<[StripeSubscription], AFError>
    func createCustomer(name: String,
                        email:String,
                        phone:String) -> AnyPublisher<StripeCustomer, Alamofire.AFError>
    func cancel(subscriptionId: String, userId: String) -> AnyPublisher<CancelStripeSubscription, AFError>
}

struct StripeServiceAPI: StripeServiceAPIProtocol {
    
    func cancel(subscriptionId: String, userId: String) -> AnyPublisher<CancelStripeSubscription, Alamofire.AFError> {
        let url = "\(Enviorment.stripeURL)subscription/cancel"
        return AF.request(url, method: .post,
                          parameters: ["userId": userId,
                                       "subscriptionId": subscriptionId],
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
        .validate()
        .publishDecodable(type:CancelStripeSubscription.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func fetchCustomerSubscriptions(status: String) -> AnyPublisher<[StripeSubscription], Alamofire.AFError> {
        let userId = Network.shared.userId() ?? ""
        let url = "\(Enviorment.stripeURL)subscription/details?status=\(status)"
        return AF.request(url, method: .post,
                          parameters: ["userId": userId],
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
        .validate()
        .publishDecodable(type:[StripeSubscription].self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func paymentIntent(priceId: String, type: String) -> AnyPublisher<PaymentIntent, Alamofire.AFError> {
        let url = "\(Enviorment.stripeURL)checkout/api"
        return AF.request(url, method: .post,
                          parameters: ["price_id": priceId,
                                       "type": type],
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
        .validate()
        .publishDecodable(type:PaymentIntent.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func checkout(priceId: String, type: String, userId: String) -> AnyPublisher<CheckoutSession, Alamofire.AFError> {
        let url = "\(Enviorment.stripeURL)checkout/stripe"
        return AF.request(url, method: .post,
                          parameters: ["userId": userId,
                                       "price_id": priceId,
                                       "type": type],
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
        .validate()
        .publishDecodable(type:CheckoutSession.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func createCustomer(name: String, email: String, phone: String) -> AnyPublisher<StripeCustomer, Alamofire.AFError> {
        let url = "\(Enviorment.stripeURL)customer"
        let userId = Network.shared.userId() ?? ""
        var json = ["userId": userId,
                    "name": name,
                    "email": email]
        if !phone.isEmpty {
            json["phone"] = phone
        }
        return AF.request(url, method: .post,
                          parameters: json,
                          encoding: JSONEncoding.default,
                          headers: HTTPHeaders(HTTPHeaders.token))
        .validate()
        .publishDecodable(type:StripeCustomer.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
    func fetchCustomer() -> AnyPublisher<StripeCustomer, Alamofire.AFError> {
        let url = "\(Enviorment.stripeURL)customer/details"
        let userId = Network.shared.userId() ?? ""
        return AF.request(url, method: .post, parameters: ["userId": userId], encoding: JSONEncoding.default, headers: HTTPHeaders(HTTPHeaders.token))
            .validate()
            .publishDecodable(type:StripeCustomer.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchSubscriptionsFor(superUser: String, category: String) -> AnyPublisher<StripProductResponse, Alamofire.AFError> {
        let url = "\(Enviorment.stripeURL)product/all"
        return AF.request(url, method: .post, parameters: ["userId": superUser, "category": category], encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type:StripProductResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
}


@Observable class StripeService {
    private var subs: Set<AnyCancellable> = []
    private let networking: StripeServiceAPIProtocol = StripeServiceAPI()
    var subscriptions: [StripeProduct] = []
    var customerSubscriptions: [StripeSubscription] = []
    var customerInactiveSubscriptions: [StripeSubscription] = []
    var attachmentLookup: [String: AttachmentModel] = [:]
    var customer: StripeCustomer? = nil
    var subscribedToIds: Set<String> = [] //all superusers the consumer is current subscribed to
    var checkoutSession: CheckoutSession? = nil
    var showCheckout: Bool = false
    var subscriptionsAppointments: [String: [String]] = [:]
    
    func isSubscribed(superuserId: String) -> Bool {
        return subscribedToIds.contains(superuserId)
    }
    
    func subscriptionsFor(service: String) -> [String] {
        return subscriptionsAppointments[service] ?? []
    }
    
    func isCurrent(_ subscription: StripeProduct) -> Bool {
        return customerSubscriptions.first(where: {$0.plan.product.id == subscription.id}) != nil
    }
    
    func fetchCustomerSubscriptions(status: String, handler: @escaping (_ complete: Bool) -> Void) {
        subscribedToIds.removeAll()
        networking.fetchCustomerSubscriptions(status: status).sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_):
                handler(false)
                
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
//            self.customerSubscriptions = response
            self.customerSubscriptions = response.filter({$0.plan.product_name.lowercased() != "zala free"})
            var subscribedIds:[String] = []
            var attachmentIds:[String] = []
            customerSubscriptions.forEach { sub in
                attachmentIds.append(contentsOf: sub.plan.product.images)
                if let userId = sub.plan.product.metadata?.userId {
                    subscribedIds.append(userId)
                }
            }
            self.subscribedToIds.formUnion(subscribedIds)
            handler(true)
        }
        .store(in: &subs)
    }
    
    func getCustomer() {
        networking.fetchCustomer().sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.customer = response
        }
        .store(in: &subs)
    }
    
    func createCustomer(name: String, email: String, phone: String, handler: @escaping (_ customer: StripeCustomer?) -> Void) {
        networking.createCustomer(name: name, email: email, phone: phone).sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_):
                handler(nil)
                
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.customer = response
            handler(self.customer)
        }
        .store(in: &subs)
    }
    
    func stripeProductsFor(superUser: String, category: String,handler: ((Bool) -> Void)? = nil) {
        networking.fetchSubscriptionsFor(superUser: superUser, category: category).sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_):
                handler?(false)
                
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            let validSubs = response.data.filter({$0.isValid})
            self.subscriptions = validSubs
            for sub in self.subscriptions {
                self.buildLookup(sub: sub)                
            }
            handler?(true)
        }
        .store(in: &subs)
    }
    
    func allAttachmentsFor(superUser: ID, handler: @escaping (_ complete: Bool) -> Void) {
        Network.shared.apollo.fetch(query: SuperUserAttachmentsQuery(id: .some(superUser), labels: .some([]))){ response in
            switch response {
            case .success(let result):
                self.attachmentLookup = result.data?.user?.attachments?.reduce(into: [String:AttachmentModel](), { json, attachment in
                    let model = attachment.fragments.attachmentModel
                    json[model.id ?? ""] = model
                }) ?? [:]
                handler(true)
                
            case .failure(_):
                handler(false)
            }
        }
    }
    
    func subscribe(superUser: SuperUser, handler: @escaping (_ complete: Bool) -> Void) {
        guard let account = Network.shared.account else { return }
        
        fetchSuperUser(id: superUser.id!) { superUser in
            var roles = account.roles?.reduce(into: [RoleInput](), { inputs, role in
                inputs.append(RoleInput(role: role.role, orgId: role.orgId ?? ""))
            }) ?? []
            let suRoleOrg = superUser?.roles?.first(where: {$0.org?.name?.lowercased() == superUser?.fullName?.lowercased()})?.orgId ?? ""
            roles.append(RoleInput(role: .person, orgId: .some(suRoleOrg)))
            guard !roles.isEmpty else { return }
            self.updateRoles(input: roles, userId: account.id!) { complete in
                handler(complete)
            }
        }
    }
    
    func cancel(subscription: StripeSubscription, handler: @escaping (_ complete: Bool) -> Void) {
        guard let userId = Network.shared.userId() else { return }
        guard let superUserId = subscription.superUserId() else { return }
        let subscriptionId = subscription.id
        networking.cancel(subscriptionId: subscriptionId, userId: userId).sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_):
                handler(false)
                
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            unsubscribe(superUserId: superUserId) { complete in
                handler(true)
            }            
        }
        .store(in: &subs)
    }
    
    func unsubscribe(superUserId: String, handler: @escaping (_ complete: Bool) -> Void) {
        guard let account = Network.shared.account else { return }
        fetchSuperUser(id: superUserId) { superUser in
            if let providerOrg = superUser?.roles?.first(where: {$0.role == .provider})?.orgId {
                let roles = account.roles?.reduce(into: [RoleInput](), { inputs, role in
                    if role.orgId != providerOrg {
                        inputs.append(RoleInput(role: role.role, orgId: role.orgId ?? ""))
                    }
                }) ?? []
                
                self.updateRoles(input: roles, userId: account.id!) { complete in
                    handler(complete)
                }
            }
        }
    }
    
    fileprivate func updateRoles(input:[RoleInput], userId: ID,handler: @escaping (_ complete: Bool) -> Void) {
        let input = UserUpdateInput(id: userId, roles: .some(input))
        Network.shared.apollo.perform(mutation: UpdateUserMutation(input: .some(input), labels: .some([.superUserProfile]))) { response in
            switch response {
            case .success(_):
                Network.shared.refetchAccountWith { compelte in
                    handler(true)
                }
            case .failure(_):
                handler(false)
            }
        }
    }
    
    func purchaseAndSubscribe(stripeProduct: StripeProduct,
                              type: String) {
        let userId = Network.shared.userId() ?? ""
        guard let priceId = stripeProduct.defaultPrice?.id else { return }
        networking.checkout(priceId: priceId, type: type, userId: userId).sink { completion in
            //            guard let self = self else { return }
            switch completion {
            case .failure(_): break
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.checkoutSession = response
//            self.preparePaymentSheet()
//            showCheckout.toggle()
        }
        .store(in: &subs)
    }
    
    func fetchSuperUser(id: String, handler: @escaping (_ superUser: UserModel?) -> Void) {
        Network.shared.apollo.fetch(query: SuperUserQuery(id: .some(id), labels: .some([.superUserProfile]))){ response in
            switch response {
            case .success(let result):
                handler(result.data?.user?.fragments.userModel)
                
            case .failure(_):
                handler(nil)
            }
        }
    }
    
    
    //MARK: - Helpers
    func urlFor(product: StripeProduct) -> String? {
        let id = product.images.first ?? ""
        return attachmentLookup[id]?.contentUrl
    }
    
    func urlFor(images: [String]) -> String? {
        let id = images.first ?? ""
        return attachmentLookup[id]?.contentUrl
    }
    
    func buildLookup(sub: StripeProduct) {
        let services = sub.appointments
        for service in services {
            if var subs = self.subscriptionsAppointments[service] {
                subs.append(sub.name ?? "")
                self.subscriptionsAppointments[service] = subs
            } else {
                self.subscriptionsAppointments[service] = [sub.name ?? ""]
            }
        }
    }
}


extension HTTPHeaders {
    static let token: [String: String] = ["Authorization" :  "Bearer \(KeychainSwift().get(loginToken) ?? "")"]
    static func auth() -> [String: String] {
        return  ["authorization" :  "\(Network.shared.userId() ?? "")"]
    }
}

