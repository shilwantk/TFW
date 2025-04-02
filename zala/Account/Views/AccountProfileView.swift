//
//  AccountProfileView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/24/24.
//

import SwiftUI

struct AccountProfileView: View {
    
    @Bindable var service: AccountService
    @State var showEditAccount: Bool = false
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ProfileView(url: service.account?.profileURL(),
                                initials: service.account?.initials,
                                size: 88,
                                textSize: .x28)
                    
                    Text(service.account?.fullName ?? "")
                        .style(size: .x22, weight: .w700)
                    AccountKeyValueField(
                        icon: .calendar,
                        key: "Date of Birth",
                        value: $service.dob,
                        placeholder:"Date of birth")
                    AccountKeyValueField(
                        icon: .gender,
                        key: "Gender",
                        value: $service.gender,
                        placeholder:"Gender")
                    AccountKeyValueField(
                        icon: .coaching,
                        key: "Coaching Style",
                        value: $service.coaching,
                        placeholder:"Coaching style")
                    AccountKeyValueField(
                        icon: .focus,
                        key: "Main Focus",
                        value: $service.focus,
                        placeholder:"Main focus")
                    AccountKeyValueField(
                        icon: .phone,
                        key: "Phone",
                        value: $service.phone,
                        placeholder:"Phone number")
                    AccountKeyValueField(
                        icon: .email,
                        key: "Email",
                        value: $service.email,
                        placeholder:"Email")
                    AccountKeyValueField(
                        icon: .pinLocation,
                        key: "Address",
                        value: $service.fullAddress,
                        placeholder:"Address")
                    Spacer()
                }
            }
            Divider().background(.gray)
            VStack(spacing: 10) {
                TintButton(icon: nil, title: "Edit Profile", color: Theme.shared.lightBlue) {
                    showEditAccount.toggle()
                }
                StandardButton(title: "Update Password")
            }
            .padding()
            .fullScreenCover(isPresented: $showEditAccount, content: {
                NavigationStack {
                    EditAccountView(service: service)
                }
            })
        }
    }
}
