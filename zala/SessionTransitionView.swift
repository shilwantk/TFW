//
//  SessionTransitionView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/28/24.
//

import SwiftUI
import KeychainSwift
import ZalaAPI

enum SessionTransitionState {
    case root
    case welcome
    case login
    case session
    case loginLanding
}

struct SessionTransitionView: View {
    
    let keychain = KeychainSwift()
    
    @Binding var state: SessionTransitionState
    
    var body: some View {
        VStack(spacing: 0) {
           BrandingView()
                .frame(maxWidth: .infinity)            
        }
        .background(Theme.shared.upDownButton)
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 0)        
        .onAppear(perform: {
            checkSessionAndNavigate()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
////                navigateToRoot()
//                navigateToWelcomeView()
//            })
        })
    }
    
    fileprivate func checkSessionAndNavigate() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: DispatchWorkItem {
            if keychain.isLoggedIn() {
                sessionCheck { valid in
                    if valid {
                        fetchAccount { complete in
                            let walkthough = UserDefaults.standard.bool(forKey: .walkthrough)
                            if walkthough {
                                state = .root
                            } else {
                                state = .welcome
                            }
                        }
                    } else {
                        state = .login
                    }
                }
            } else {
                state = .loginLanding
            }
        })
    }
    
    fileprivate func fetchAccount(handler: @escaping (_ complete: Bool) -> Void) {
        Network.shared.apollo.fetch(query: AccountQuery(labels: .some([.superUserProfile]))) {
            response in
            switch response {
            case .success(let result):
                Network.shared.account = result.data?.me?.fragments.account
                handler(true)
            case .failure(_):
                handler(true)
                break
            }
            
        }
    }
    
    fileprivate func sessionCheck(handler: @escaping (_ complete: Bool) -> Void) {
        Network.shared.apollo.fetch(query: SessionCheckQuery(), cachePolicy: .fetchIgnoringCacheCompletely) {result in
            switch result {
            case .success(let graphQLResult):
                
                if let id = graphQLResult.data?.me?.id, !id.isEmpty {
                    handler(true)
                } else {
                    logoutSession()
                    handler(false)
                }
            case .failure(_):
                logoutSession()
                handler(false)
            }
        }
    }
    
    fileprivate func logoutSession() {
        HealthKitManager.shared.logout { complete in
            if complete {
                keychain.logout()
                DispatchQueue.main.async {
                    self.state = .loginLanding
//                    self.navigateToLoginLandingView()
                }
            }
        }
    }

//    fileprivate func navigateToLoginLandingView() {
//        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first{ $0.isKeyWindow}
//        window?.rootViewController = UIHostingController(rootView: NavigationStack {LoginLandingView() })
//        window?.makeKeyAndVisible()
//    }
//
//    fileprivate func navigateToLogin() {
//        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first{ $0.isKeyWindow}
//        window?.rootViewController = UIHostingController(rootView: LoginView())
//        window?.makeKeyAndVisible()
//    }
//    
//    fileprivate func navigateToRoot() {
//        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first{ $0.isKeyWindow}
//        window?.rootViewController = UIHostingController(rootView: RootView())
//        window?.makeKeyAndVisible()
//    }
//    
//    fileprivate func navigateToWelcomeView() {
//        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first{ $0.isKeyWindow}
//        window?.rootViewController = UIHostingController(rootView: NavigationStack{WelcomeView()})
//        window?.makeKeyAndVisible()
//    }
//    
//    fileprivate func navigateToHealthKitView() {
//        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first{ $0.isKeyWindow}
//        window?.rootViewController = UIHostingController(rootView: NavigationStack{HealthKitView()})
//        window?.makeKeyAndVisible()
//    }
    
    
    
}
