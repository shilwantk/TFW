//
//  LoginLandingView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI

struct LoginLandingView: View {
    
    @State private var didTapCreate: Bool = false
    @State private var didTapSignIn: Bool = false
    @Binding var state: SessionTransitionState
    var body: some View {
        VStack {
            BrandingView()
            VStack(spacing: 12) {
                StandardButton(title: "CREATE ACCOUNT") {
                    didTapCreate.toggle()
                }
                BorderedButton(title: "SIGN IN") {
                    didTapSignIn.toggle()
                }
            }
            .padding([.leading, .trailing])
        }
        .background(Theme.shared.upDownButton)
        .navigationDestination(isPresented: $didTapCreate) {
            CreateAccountView(state: $state)
        }
        .navigationDestination(isPresented: $didTapSignIn) {
            LoginView(state: $state)
        }
    }
}

struct BrandingView: View {
    var body: some View {
        VStack(spacing: 22) {
            Spacer()
//            Image.logoBlue
//                .padding(.top)
            Image.logo
            Spacer()
        }
    }
}
