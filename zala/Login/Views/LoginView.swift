//
//  LoginView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//
import SwiftUI

struct LoginView: View {
        
    @State var email: String = ""
    @State var password: String = ""

    @State var showErrorBanner: Bool = false
    @State var service = LoginService()
    @Binding var state: SessionTransitionState
    var body: some View {
        ScrollView {
            if showErrorBanner {
                errorBanner()
            }
            VStack(spacing: 12) {
                KeyValueField(key: "Email", value: $email, placeholder: "Enter email")
                KeyValueField(key: "Password", value: $password, placeholder: "Enter password", isSecure: true)
                StandardButton(title: "Go to My Zala") {
                    service.login(username: email, pwd: password)
                }
                Spacer()
                Button {
                    service.passwordReset(eamil: $email.wrappedValue)
                } label: {
                    Text("Forgot Passsword")
                }
            }
            .onChange(of: service.state, { oldValue, state in
                if state == .complete {
                    self.state = .session
                } else if state == .failure {
                    withAnimation {
                        showErrorBanner.toggle()
                    }
                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("SIGN IN")
                        .style(color: .white, size:.x18, weight:.w800)
                }
            })
            .padding()
            .scrollDismissesKeyboard(.interactively)
        }
    }
    
    fileprivate func errorBanner() -> some View {
        VStack {
            Text("Invalid username or password. Please try again.")
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(8)
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(), value: showErrorBanner)
            
            Spacer()
        }
        .padding(.top, 20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showErrorBanner = false
                    service.state = .initial
                }
            }
        }
    }
}


//
//  BiometricManager.swift
//  HealthBook
//
//  Created by Kyle Carriedo on 12/18/18.
//  Copyright © 2018 Kyle Carriedo. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

class BiometricIDAuth {
    var loginReason = "Logging in with Touch ID"
    var bioMeticType = "None"
    var supportsBioMetric = false
    
    let context = LAContext()
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            self.bioMeticType = "None"
            return .none
        case .touchID:
            self.bioMeticType = "Touch ID"
            return .touchID
        case .faceID:
            self.bioMeticType = "Face ID"
            return .faceID
        case .opticID:
            self.bioMeticType = "Face ID"
            return .faceID
        @unknown default:
            self.bioMeticType = "None"
            return .none
        }
    }
    
    func checkIfBiometricIsEnabled()  {
        let _ = self.biometricType()
    }
    
    func turnOffBiometricID() {
        guard canEvaluatePolicy() else {
            return
        }
        self.supportsBioMetric = false
        context.invalidate()
    }
    
    func authenticateUser(completion: @escaping (_ authorized: Bool, _ isUserCanceled: Bool, _ errorString: String?) -> Void) {
        guard canEvaluatePolicy() else {
            self.supportsBioMetric = false
            completion(false, false, "Touch ID not available")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
            if success {
                self.supportsBioMetric = true
                completion(true, false, nil)
                
            } else {
                
                if let error = evaluateError {
                    
                    let message: String?
                    var canceled = false
                    switch error {
                        
                    case LAError.authenticationFailed:
                        message = "There was a problem verifying your identity."
                    case LAError.userCancel, LAError.userFallback:
                        canceled = true
                        message = ""
                        
                    case LAError.biometryNotAvailable:
                        message = "Face ID/Touch ID is not available."
                    case LAError.biometryNotEnrolled:
                        message = "Face ID/Touch ID is not set up."
                    case LAError.biometryLockout:
                        message = "Face ID/Touch ID is locked."
                    default:
                        message = nil
                    }
                    
                    completion(false, canceled, message)
                }
            }
        }
    }
}
