//
//  BaselineCompleteView.swift
//  zala
//
//  Created by Kyle Carriedo on 4/8/24.
//

import SwiftUI


// Custom overlay for the saving state
struct SavingOverlayView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2)
            Text("Saving...")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.6))  // Semi-transparent background
        .edgesIgnoringSafeArea(.all)  // Cover the entire screen
    }
}

struct BaselineCompleteView: View {
    
    @Binding var dismiss: Bool
    
    @Environment(SurveyService.self) private var service
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 24) {
                Image.checkmarkLarge
                Text("Baseline Complete")
                    .style(size: .x22, weight: .w800)
                Text("You've taken an essential step toward your goals by completing your baseline assessment, and we're thrilled to be a part of your journey.")
                    .style(size: .x18, weight: .w400).padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                Spacer()
                StandardButton(title: "Start My Journey") {
                    dismiss.toggle()
                }
            }
            .task({
                service.saveAssessment()
            })
            .navigationBarBackButtonHidden(true)
            .padding()
            .blur(radius: service.saving ? 3.0 : 0)  // Blur the content when saving
            
            // Saving overlay
            if service.saving {
                SavingOverlayView()
            }
        }
    }
}
