//
//  HealthKitView.swift
//  zala
//
//  Created by Kyle Carriedo on 4/5/24.
//

import SwiftUI

struct HealthKitView: View {
    
    @State var didTapComplete: Bool = false
    @State var didTapSkip: Bool = false
    @State var didAskHealthKit: Bool = false
    @Binding var state: SessionTransitionState
    var body: some View {
            VStack {
                if didAskHealthKit {
                    Image.hkActive
                        .padding([.bottom, .top], 35)
                    Text("Access Granted")
                        .style(color:.white, size: .x28, weight: .w800)
                        .padding(.bottom)
                    Text("Your HealthKit is now connected, ensuring a smooth flow of data to SuperUsers that you subscribe to!")
                        .style(color: Theme.shared.grayStroke, size: .regular, weight: .w400)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .padding(.bottom, 50)
                    BorderedButton(title: "RESYNC HEALTHKIT") {
                        HealthKitManager.shared.requestAuthorizationAgain {  _ in
                            HealthKitManager.shared.refetchHealthData()
                        }
                    }
                    .padding([.trailing, .leading])
                    Spacer()
                    StandardButton(title: "COMPLETE PROFILE") {
                        didTapComplete.toggle()
                    }
                } else {
                    Image.hkPending
                        .padding([.bottom, .top], 35)
                    Text("HealthKit Access")
                        .style(color:.white, size: .x28, weight: .w800)
                        .padding(.bottom)
                    Text("Zala is here to help you pursue your health and lifestyle goals to the fullest. Lets connect HealthKit to track all your wearable data.")
                        .style(color:Theme.shared.grayStroke, size: .x18, weight: .w400)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .padding(.bottom, 50)
                    VStack(spacing: 12) {
                        StandardButton(title: "ALLOW HEALTHKIT ACCESS", titleColor: .white, color: Theme.shared.zalaGreen) {
                            HealthKitManager.shared.requestAccessIfNeeded { complete in
                                didAskHealthKit.toggle()                                
                            }
                        }
                    }
                    Spacer()
                }
            }
        .navigationDestination(isPresented: $didTapComplete, destination: {
            ProfilePhotoView(state: $state)
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text("WELCOME")
                    .style(color: .white, size:.x18, weight:.w800)
            }
        })
        .padding()
        .onAppear {
            self.didAskHealthKit =  HealthKitManager.getHealthKitPermission()
        }
    }
    
//    fileprivate func navigateToRoot() {
//        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first{ $0.isKeyWindow}
//        window?.rootViewController = UIHostingController(rootView: RootView())
//        window?.makeKeyAndVisible()
//    }

}
