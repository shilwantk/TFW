//
//  NetworkManager.swift
//  zala
//
//  Created by Kyle Carriedo on 4/5/24.
//

import Foundation
import KeychainSwift
import Foundation
import Apollo
import ApolloAPI
import ZalaAPI
import UIKit
import SwiftUI
import JWTDecode

let loginToken  = "token"
let loginUserID = "userID"
let loginEmail = "emailID"


class AuthorizationInterceptor: ApolloInterceptor {
    var id: String = ""
    
    
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        let keychain = KeychainSwift()
        if let token = keychain.get(loginToken) {
            request.addHeader(name: "Authorization", value: token)
        }        
        chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
    }
    
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    
    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(AuthorizationInterceptor(), at: 0)
        return interceptors
    }
    
}


class Network {
    
    static let shared = Network()
    let keychain = KeychainSwift()
    var account: Account?
    var service: AccountService = AccountService()
    
    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store)
        let url = URL(string: Enviorment.graphQL)!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
    }()
    
    var convoUser: ConversationUser {
        .init(name: account?.fullName ?? "", uuid: userId() ?? "")
    }
    
    func refetchAccount() {
        service.fetchAccount { complete in }
    }
    func refetchAccountWith(handler: @escaping (Bool) -> Void) {
        service.fetchAccount { complete in
            handler(complete)
        }
    }

    func token() -> String {
        return keychain.get(loginToken) ?? ""
    }
    
    func authToken() -> [String : String] {
        return ["Authorization" : keychain.get(loginToken) ?? ""]
    }
    
    func userId() -> String? {
        let userId = keychain.get(loginUserID)
        return userId
    }
    
    func showReminderAlert() -> Bool {
        return UserDefaults.standard.bool(forKey: .reminderAlert)
    }
    
    func markReminderAlert() {
        UserDefaults.standard.set(true, forKey: .reminderAlert)
    }
    
    func logoutSession(handler: @escaping (Bool) -> Void) {
        HealthKitManager.shared.logout { complete in
            if complete {
                UserDefaults.standard.set(false, forKey: .walkthrough)
                UserDefaults.standard.set(false, forKey: .configureDashboard)
                self.keychain.clear()
                self.keychain.logout()
                handler(true)
            }
        }
    }
    
    func isValidToken() -> (isValid: Bool, state: TokenState) {
        let token = self.token()
        do {
            let jwt = try decode(jwt: token)
            if let expiresAtDate = jwt.expiresAt, Date().isSmallerThan(expiresAtDate) {
                return (true, .successful)
            } else {
                return (true, .expired)
            }
        } catch {
            return (true, .decodeError)
        }
    }
    
    func checkIfAuthorized(handler: ((_ complete:Bool) -> Void)?) {
        let tokenState = self.isValidToken()
        switch tokenState.state {
            
        case .successful:
            handler?(true)
            
        case .expired:
//            self.runLogout(handler: nil)
            handler?(false)
            
        case .decodeError, .missing:
//            self.runLogout(handler: nil)
            handler?(false)
        }
    }
}
