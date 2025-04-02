//
//  EditAccountView.swift
//  zala
//
//  Created by Kyle Carriedo on 4/19/24.
//

import SwiftUI
import SDWebImageSwiftUI
import ZalaAPI

struct EditAccountView: View {
    @Bindable var service: AccountService
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedImage: UIImage?
    @State private var url: String?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var showCameraSheet: Bool = false
    @State var didTapPhoto: Bool = false
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            ZStack(alignment:.top) {
                if isLoading {
                    LoadingBannerView()
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            ScrollView {
                VStack(spacing: 15) {
                    buildAddPhoto()
                    DateDropDownView(key: "Date of Birth",
                                     selectedDate: $service.dobDate,
                                     dateAndTime: .constant(false),
                                     isDob: true,
                                     isRequired: false,
                                     darkMode: true)
                    KeyValueField(key: "Gender",
                                  value: $service.gender,
                                  placeholder: "Enter gender")
                    KeyValueField(key: "Coaching Style",
                                  value: $service.coaching,
                                  placeholder: "Select coaching style")
                    KeyValueField(key: "Main Focus",
                                  value: $service.focus,
                                  placeholder: "Select main focus")
                    KeyValueField(key: "Phone",
                                  value: $service.phone,
                                  placeholder: "Enter phone number")
                    KeyValueField(key: "Email",
                                  value: $service.email,
                                  placeholder: "Enter email")
                    KeyValueField(key: "Street",
                                  value: $service.address,
                                  placeholder: "Enter street")
                    KeyValueField(key: "City",
                                  value: $service.city,
                                  placeholder: "Enter city")
                    KeyValueField(key: "State",
                                  value: $service.state,
                                  placeholder: "Enter state")
                    KeyValueField(key: "Zipcode",
                                  value: $service.zipcode,
                                  placeholder: "Enter zipcode")
                }.padding()
            }
            Spacer()
            Divider().background(.gray)
            StandardButton(title: "Save") {
                isLoading = true
                if let selectedImage {
                    service.createProfile(image: selectedImage,
                                          exsistingProfileAttachment: service.account?.profileAttachment()) { complete in
                        service.updateAccount { complete in
                            isLoading = false
                            dismiss()
                        }
                    }
                } else {
                    service.updateAccount { complete in
                        isLoading = false
                        dismiss()
                    }
                }
            }.padding()
        }
        .navigationTitle("Zala Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image.close
                })
            }
        })
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
    }
    
    @ViewBuilder
    fileprivate func buildAddPhoto() -> some View {
        HStack(spacing: 20) {
            if let url = service.profileUrl {
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
            Spacer()
        }
    }
    
    fileprivate func hasPhoto() -> Bool {
        return selectedImage != nil || url != nil
    }
}
