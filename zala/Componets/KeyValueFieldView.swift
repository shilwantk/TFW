//
//  KeyValueFieldView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import Foundation
import SwiftUI

struct KeyValueField: View {
    @State var icon: Image? = nil
    @State var iconColor: Color = Theme.shared.placeholderGray
    @State var key:         String
    @Binding var value:       String
    @State var placeholder: String = ""
    @State var height:      CGFloat = 55.0
    @State var editable:Bool = true
    @State var isRequired:Bool = false
    @State var isSecure:Bool = false
    @State var isEmail:Bool = false
    @State private var isValid = true // Track whether the email is valid and others
    @State private var showPwd = false // changes from secure to not
    
    ///UIKeyboardType: .default
    @State var keyboardType:UIKeyboardType = .default
    
    ///UITextAutocapitalizationType: .none
    @State var autocapitalizationType:UITextAutocapitalizationType = .none
    
    ///autocorrectionDisabled: false
    @State var autocorrectionDisabled: Bool = false
    
    var onUpdate: ((_ value: String) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                if let icon {
                    icon
                        .renderingMode(.template)
                        .foregroundColor(iconColor)
                        .padding(.trailing)
                }
            VStack(alignment: .leading, spacing: 5) {
                if showText() {
                    HStack(alignment: .center, spacing: 0) {
                        Text(key)
                            .style(color: Theme.shared.placeholderGray,
                                   size: .small,
                                   weight: .w400)
                        if isRequired {
                            Text("*")
                                .style(color: Theme.shared.red, size: .regular, weight: .w400)
                        }
                        Spacer()
                    }
                }
                if isSecure {
                    if showPwd {
                        TextField("", text: $value)
                            .placeholder(when: value.isEmpty) {
                                Text(placeholder)
                                    .style(color:Theme.shared.placeholderGray, size: .small, weight: .w400)
                            }
                            .onChange(of: value) { _, newValue in
                                if isEmail {
                                    // Format the email address as the user types
                                    self.value = newValue.lowercased()
                                    // Perform email validation
                                    self.isValid = isValidEmailFormat(email: newValue)
                                    onUpdate?(newValue)
                                } else {
                                    onUpdate?(newValue)
                                }
                            }
                            .keyboardType(keyboardType)
                            .autocapitalization(autocapitalizationType)
                            .autocorrectionDisabled(autocorrectionDisabled)
                            .disabled(!editable)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    } else {
                        SecureField("", text: $value)
                            .placeholder(when: value.isEmpty) {
                                Text(placeholder)
                                    .style(color:Theme.shared.placeholderGray, size: .small, weight: .w400)
                            }
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                } else {
                    TextField("", text: $value)
                        .placeholder(when: value.isEmpty) {
                            Text(placeholder)
                                .style(color:Theme.shared.placeholderGray, size: .small, weight: .w400)
                        }
                        .onChange(of: value) { _, newValue in
                            if isEmail {
                                // Format the email address as the user types
                                self.value = newValue.lowercased()
                                // Perform email validation
                                self.isValid = isValidEmailFormat(email: newValue)
                                onUpdate?(newValue)
                            } else {
                                onUpdate?(newValue)
                            }
                        }
                        .keyboardType(keyboardType)
                        .autocapitalization(autocapitalizationType)
                        .autocorrectionDisabled(autocorrectionDisabled)
                        .disabled(!editable)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
            }
                if isSecure {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showPwd.toggle()
                        }
                    }, label: {
                        if showPwd {
                            Image.eyeSlashCircle
                        } else {
                            Image.eyeCircleFill
                        }
                    })
                }
        }
            .frame(height: height)
            .padding([.leading, .trailing])
            .acitiveInactiveBackground(value: $value, isValid: $isValid)
        }
    }
    
    func showText() -> Bool {
        return !self.value.isEmpty
    }
    
    // Function to validate email format
    private func isValidEmailFormat(email: String) -> Bool {
        // Simple email format validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct KeyValueField_Previews: PreviewProvider {
    static var previews: some View {
        KeyValueField(key: "Last Name", value: .constant(""), placeholder: "Enter Last Name")
    }
}


extension KeyValueField {
    func onUpdate(action: @escaping ((_ value: String) -> Void)) -> KeyValueField {
        KeyValueField(key: self.key, value: $value, placeholder:self.placeholder, height: self.height, onUpdate: action)
    }
}
