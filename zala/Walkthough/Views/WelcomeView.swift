//
//  WelcomeView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI

struct WelcomeView: View {
    
    @State var didTapComplete: Bool = false
    @State var didTapSkip: Bool = false
    
    @Binding var state: SessionTransitionState
    var body: some View {
        VStack {
            Image.logoLrg
                .padding([.bottom, .top], 35)
            
            Text("Welcome \(Network.shared.account?.firstName ?? "Member")!")
                .style(color:.white, size: .x28, weight: .w800)
                .padding(.bottom)
            Text("Zala helps people find their best using science backed tools for intentional living and optimal performance.\n\nLet’s get some information from you in order to customize your Zala experience")
                .style(color:.white, size: .regular, weight: .w400)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.bottom, 50)
            Spacer()
            VStack(spacing: 12) {
                StandardButton(title: "COMPLETE PROFILE") {
                    didTapComplete.toggle()
                }
            }
        }
        .padding()
        .navigationDestination(isPresented: $didTapComplete, destination: {
            HealthKitView(state: $state)
        })
    }
    
//    fileprivate func navigateToRoot() {
//        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first{ $0.isKeyWindow}
//        window?.rootViewController = UIHostingController(rootView: RootView())
//        window?.makeKeyAndVisible()
//    }

}
