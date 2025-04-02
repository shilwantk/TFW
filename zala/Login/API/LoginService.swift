//
//  LoginService.swift
//  zala
//
//  Created by Kyle Carriedo on 4/5/24.
//
import Foundation
import Combine
import SwiftUI
import Apollo
import ZalaAPI
import KeychainSwift


@Observable class LoginService {
        
    var state: LoadingState = .initial
    
    init(){ }
        
    private var subscriptions: Set<AnyCancellable> = []
    
    
    func passwordReset(eamil:String) {
        Network.shared.apollo.perform(mutation: UserRequestPasswordResetMutation(email: eamil, org: .some(.zalaOrg)))  { result in
            switch result {
            case .success(_): break
                
            case .failure( _): break
            }
        }
    }
    
    func login(username:String, pwd:String) {
        Network.shared.apollo.perform(mutation: LoginMutation(input: UserLoginInput(email: username, password: .some(pwd)))) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let graphQLResult):
                if let user = graphQLResult.data?.login?.user?.fragments.minUser,
                   let token = user.token,
                   let userID = user.id {
                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: loginToken)
                    keychain.set(userID, forKey: loginUserID)
                    keychain.set(username, forKey: loginEmail)
                    state = .complete
                } else if let _ = graphQLResult.data?.login?.errors {
                    state = .failure
                    
                } else if let _ = graphQLResult.errors {
                    state = .failure
                }
            case .failure( _):
                state = .failure
            }
        }
    }
}
