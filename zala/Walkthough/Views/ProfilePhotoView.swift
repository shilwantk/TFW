//
//  ProfilePhotoView.swift
//  zala
//
//  Created by Kyle Carriedo on 4/15/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfilePhotoView: View {
    
    @State var didTapPhoto: Bool = false
        
    
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var showCameraSheet: Bool = false
    @State private var selectedImage: UIImage?
    
    @State var didSign: Bool = false
    @State var presentConsent: Bool = false
    
    @State var service: AccountService = AccountService()
    @Binding var state: SessionTransitionState
    @State private var surveyService: SurveyService = SurveyService()
    
    var body: some View {
        if let url = service.account?.profileURL(), !url.isEmpty {
            WebImage(url: URL(string: url),
                     options: .continueInBackground)
                .resizable()
                .interpolation(.high)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 108, height: 108, alignment: .center)
        } 
        else if let selectedImage {
            Image(uiImage: selectedImage)
                .resizable()
                .interpolation(.high)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 108, height: 108, alignment: .center)
                .onTapGesture {
                    didTapPhoto.toggle()
                }
        }
        else {
            Image.profileEmpty
                .resizable()
                .frame(width: 108, height: 108, alignment: .center)
                .padding(.bottom)
        }
        BorderedButton(title: "+ ADD PHOTO") {
            didTapPhoto.toggle()
        }
        .frame(maxWidth: 150)
        .padding(.bottom)
        Text("Profile Photo")
            .style(color:.white, size: .x28, weight: .w800)
            .padding(.bottom)
        Text("Let’s add a profile photo so SuperUsers can recognize you.")
            .style(color:Theme.shared.grayStroke, size: .regular, weight: .w400)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 320)
        Spacer()
        StandardButton(title: "DONE") {
            UserDefaults.standard.set(true, forKey: .walkthrough)
            if let selectedImage {
                service.createProfile(image: selectedImage,
                                      exsistingProfileAttachment: Network.shared.account?.profileAttachment()) { complete in
                    presentConsent = true
                }
            } else {
                presentConsent = true
            }
        }.padding()
        .confirmationDialog("Select", isPresented: $didTapPhoto, actions: {
            Button {
                sourceType = .camera
                self.showCameraSheet.toggle()
            } label: {
                Text("Camera")
            }
            Button {
                sourceType = .photoLibrary
                self.showCameraSheet.toggle()
            } label: {
                Text("Photo Library")
            }
        })
        .fullScreenCover(isPresented: $showCameraSheet) {
            ImagePicker(sourceType: sourceType) { img in
                selectedImage = img
            }
        }
        .fullScreenCover(isPresented: $presentConsent, content: {
            NavigationStack {
                ConsentView(didSign: $didSign)
                    .environment(surveyService)
            }
        })
        .onChange(of: didSign, { _, _ in
            state = .root
        })
        .task {
            service.fetchAccount { complete in }
        }
    }
}
