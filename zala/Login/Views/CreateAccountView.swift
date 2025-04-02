//
//  CreateAccountView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI
import ZalaAPI

struct CreateAccountView: View {
    
    @State var fName: String = ""
    @State var lName: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var service: AccountService = AccountService()
    @State var stripeService: StripeService = StripeService()
    @State var showError: Bool = false
    @State var errorMsg: String = ""
//    @State var dob: Date = Date().defaultBday()
    @State var dob: Date? = nil
    @Binding var state: SessionTransitionState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if showError {
                    VStack {
                        Text(errorMsg)
                            .style(color: Theme.shared.orange, size: .regular, weight: .w400)
                            .multilineTextAlignment(.leading)
                            .padding(5)
                    }
                    .frame(maxWidth: .infinity, minHeight: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 8).fill(Theme.shared.orange.opacity(0.12))
                    )
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                            withAnimation {
                                showError.toggle()
                            }
                        })
                    })
                }
                KeyValueField(key: "First Name", value: $fName, placeholder: "Enter first name")
                KeyValueField(key: "Last Name", value: $lName, placeholder: "Enter last name")
                KeyValueField(key: "Email", value: $email, placeholder: "Enter email", keyboardType: .emailAddress, autocorrectionDisabled: true)
                KeyValueField(key: "Phone (optional)",
                              value: $phone,
                              placeholder: "Enter phone number (optional)")
                OptionalDateDropDownView(
                    key: "Date of Birth (optional)",
                    optionalPlaceholder: "Select Date of Birth",
                    selectedDate: $dob,
                    dateAndTime: .constant(false),
                    timeOnly: .constant(false),
                    darkMode: true,
                    isDob: false,
                    showKey: true,
                    usePlaceholder: true)
//                DateDropDownView(key:"Date of Birth (optional)", selectedDate: $dob, dateAndTime: .constant(false), showKey:true)
                VStack(alignment:.leading, spacing: 5) {
                    KeyValueField(key: "Password", value: $password, placeholder: "Enter password", isSecure: true)
                    Text("Password requires a minimum of 6+ characters, 1 uppercase, and 1 special character.")
                        .italic()
                        .style(color: Theme.shared.placeholderGray, size:.xSmall, weight: .w400 )
                }
                
                StandardButton(title: "Let the Journey Begin") {
                    createAccount()
                }
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("CREATE ACCOUNT")
                        .style(color: .white, size:.x18, weight:.w800)
                }
            })
            .padding()
            .scrollDismissesKeyboard(.interactively)
        }
    }
    
    fileprivate func createAccount() {
        guard email.isValidEmail() else {
            show(msg: "Invalid email address provided. Please enter a valid email.")
            return
        }
        
        guard !fName.isEmpty else {
            show(msg: "First name is required, please enter in first name")
            return
        }
        
        guard !lName.isEmpty else {
            show(msg: "Last name is required, please enter in last name")
            return
        }

        guard password.isValidPassword else {
            show(msg: "Invalid Password. Password requires a minimum of 6+ characters, 1 uppercase, and 1 special character.")
            return
        }
        
//        guard !phone.isEmpty, phone.isPhoneNumber else {
//            show(msg: "Phone number is required.")
//            return
//        }
        
        let dobString = Date.yearMonthDayString(date: dob ?? Date().defaultBday())
        
        var input = UserCreateInput(firstName: fName,
                                    lastName: lName,
                                    dob: dobString,
                                    roles: .some([RoleInput(role: .person, orgId: .some(.zalaOrg))]),
                                    emails: .some([.init(address: email, label: .some(.mainLabel))]),
                                    password: .some(password))
        
        if !phone.isEmpty, phone.isPhoneNumber {
            input.phones = [AddressesPhoneInput(number: phone, label: .some(.main))]
        }
        

        service.createAccount(email: email, input: input) { userId, errMsg in
            stripeService.createCustomer(name: "\(fName) \(lName)",
                                         email: email,
                                         phone: phone) { customer in
                if let id = customer?.id, let userId {
                    service.addPreference(userId: userId,
                                          input: PreferenceInput(key: .stripeCustomerId, value: [id])) { complete in
                        if let errMsg {
                            show(msg: errMsg)
                        } else {
                            state = .session
                        }
                    }
                } else {
                    if let errMsg {
                        show(msg: errMsg)
                    } else {
                        state = .session
                    }
                }
            }
        }
    }
    
    fileprivate func show(msg: String) {
        self.errorMsg = msg
        withAnimation {
            showError.toggle()
        }
    }
}
