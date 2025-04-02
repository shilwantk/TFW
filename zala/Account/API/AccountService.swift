//
//  AccountService.swift
//  zala
//
//  Created by Kyle Carriedo on 4/18/24.
//

import Foundation
import SwiftUI
import ZalaAPI
import Observation
import KeychainSwift

@Observable class AccountService {    
    var account: Account?
    var dobDate: Date = Date().defaultBday()
    var dob: String = ""
    var gender: String = ""
    var coaching: String = ""
    var focus: String = ""
    var phone: String = ""
    var email: String = ""
    var profileUrl: String? = nil
    var vitalDashboardMetricKeys: [String] = []
    var habitPlanId: String? = nil
    var didConsent: Bool = false
    var devices: [DeviceModel] = []
    
    var fullAddress: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zipcode: String = ""
    
    var personAppointments: [PersonAppointment] = []
    var personAppointmentsByStatus: [String: [PersonAppointment]] = [:]
    
    func addressInput() -> AddressesStreetInput {
        AddressesStreetInput(street:.some(address),
                             city:.some(city),
                             state:.some(state),
                             zip:.some(zipcode))
    }
    
    
    
    func createAccount(email: String, input: UserCreateInput,handler: @escaping (_ userId: String?, _ error: String?) -> Void) {
        let keychain = KeychainSwift()
        keychain.clear()
        keychain.logout()
        Network.shared.apollo.perform(mutation: UserCreateMutation(input: .some(input))) { response in
            switch response {
            case .success(let result):
                if let errorMessage = result.errors?.last?.message, !errorMessage.isEmpty {
                    handler(nil, errorMessage)
                } else {
                    if let user = result.data?.userCreate?.user,
                       let token = user.token,
                       let userID = user.id{
                        let keychain = KeychainSwift()
                        keychain.set(token, forKey: loginToken)
                        keychain.set(userID, forKey: loginUserID)
                        keychain.set(email, forKey: loginEmail)
                        handler(userID, nil)
                    } else {
                        handler(nil, nil)
                    }
                    
                }
            case .failure(let error):
                handler(nil, error.localizedDescription)
            }
        }
    }
    
    func checkConsent() {
        fetchPreference(key: "consent") { consent in
            self.didConsent = consent != nil
        }
    }
    
    func fetchPreference(key: String, handler: @escaping (PreferenceModel?) -> Void) {
        guard let userId = Network.shared.userId() else { return  }
        Network.shared.apollo.fetch(query: FetchPreferenceQuery(id: .some(userId)), cachePolicy: .returnCacheDataAndFetch) { response in
            switch response {
            case .success(let result):
                let model = result.data?.user?.preferences?.first(where: {$0.fragments.preferenceModel.key == key})?.fragments.preferenceModel
                handler(model)
            case .failure(_):
                handler(nil)
            }
        }
    }
    
    func fetchPreferences(keys: [String], handler: @escaping ([PreferenceModel]) -> Void) {
        guard let userId = Network.shared.userId() else { return  }
        Network.shared.apollo.fetch(query: FetchPreferenceQuery(id: .some(userId)), cachePolicy: .returnCacheDataAndFetch) { response in
            switch response {
            case .success(let result):
                let models = result.data?.user?.preferences?.compactMap({$0.fragments.preferenceModel})
                let filtered = models?.filter({ model in
                    keys.contains(model.key ?? "")
                }) ?? []
                handler(filtered)
            case .failure(_):
                handler([])
            }
        }
    }
    
    func fetchAccount(handler: @escaping (Bool) -> Void) {
        Network.shared.apollo.fetch(query: AccountQuery(labels: .some([.superUserProfile, .routineBanner])), cachePolicy: .returnCacheDataAndFetch) { response in
            switch response {
            case .success(let result):
                if let accountModel = result.data?.me?.fragments.account {
                    self.update(account: accountModel)
                }
                self.personAppointments = result.data?.me?.personAppointments?.nodes?.compactMap({$0?.fragments.personAppointment}) ?? []
                self.personAppointmentsByStatus = self.personAppointments.reduce(into: [String: [PersonAppointment]]()) { result, appointment in
                    result[appointment.status ?? "-", default: []].append(appointment)
                    let data = result[appointment.status ?? "-", default: []]
                    let sorted = data.sorted(by: {$0.scheduledAt ?? 0 < $1.scheduledAt ?? 0})
                    result[appointment.status ?? "-"] = sorted
                }
                handler(true)
            case .failure(_):
                handler(false)
                break
            }
        }
    }
    
    func updateAccount(handler: @escaping (Bool) -> Void) {
        guard let account = account else { return }
        let dobString = Date.yearMonthDayString(date: dobDate)
        
        var updateInput = UserUpdateInput(id: account.id!,
                                          dob: .some(dobString))
        
        
        if !email.isEmpty{
            updateInput.emails = .some([AddressesEmailInput(address: email, label: .some(.main))])
        }
        if !phone.isEmpty{
            updateInput.phones = .some([AddressesPhoneInput(number: phone, label: .some(.main))])
        }
        var prefInputs: [PreferenceInput] = []
        if !coaching.isEmpty {
            prefInputs.append(PreferenceInput(key: .coaching, value: [coaching]))
        }
        if !focus.isEmpty{
            prefInputs.append(PreferenceInput(key: .focus, value: [focus]))
        }
        if !prefInputs.isEmpty {
            updateInput.preferences = .some(prefInputs)
        }
        
        if !address.isEmpty, !city.isEmpty, !state.isEmpty, !zipcode.isEmpty {
            updateInput.addresses = .some([addressInput()])
        }
        
        Network.shared.apollo.perform(mutation: UpdateUserMutation(input: .some(updateInput), labels: .some([.superUserProfile]))){ response in
            switch response {
            case .success(let result):
                if let accountModel = result.data?.userUpdate?.user?.fragments.account {
                    self.update(account: accountModel)
                    handler(true)
                }
            case .failure(_):
                handler(false)                
            }
        }
    }
    
    
    func deleteAccount(handler: @escaping (Bool) -> Void) {
        guard let account = account else { return }
        let dobString = Date.yearMonthDayString(date: dobDate)
        
        //since there no delete mutation.
        let updateInput = UserUpdateInput(id: account.id!, password: .some(generateRandomPassword()))
        
        Network.shared.apollo.perform(mutation: UpdateUserMutation(input: .some(updateInput), labels: .some([.superUserProfile]))){ response in
            switch response {
            case .success(let result):
                if let accountModel = result.data?.userUpdate?.user?.fragments.account {
                    self.update(account: accountModel)
                    handler(true)
                }
            case .failure(_):
                handler(false)
            }
        }
    }
    
    func updateVital(metricKeys:[String], handler: @escaping (Bool) -> Void) {
        guard let account = account else { return }
        
        var updateInput = UserUpdateInput(id: account.id!)
        
        updateInput.preferences = .some([PreferenceInput(key: .vitalsDashboard, value: metricKeys)])
        
        Network.shared.apollo.perform(mutation: UpdateUserMutation(input: .some(updateInput), labels: .some([.superUserProfile]))){ response in
            switch response {
            case .success(let result):
                if let accountModel = result.data?.userUpdate?.user?.fragments.account {
                    self.update(account: accountModel)
                }
                handler(true)
            case .failure(_):
                handler(false)
            }
        }
    }
    
    func deleteAttachment(id: String, handler: @escaping (Bool) -> Void) {
        Network.shared.apollo.perform(mutation: DeleteAttachmentMutation(input: .some(IDInput(id: id)))) { response in
            switch response {
            case .success(_):
                handler(true)
            case .failure(_):
                handler(false)
                break
            }
        }
    }
    
    func createProfile(image: UIImage, exsistingProfileAttachment: AttachmentModel?, handler: @escaping (Bool) -> Void) {
        guard let base64 = image.base64() else { return }
        if let exsistingProfileAttachment,
            let id = exsistingProfileAttachment.id {
            deleteAttachment(id: id) { complete in
                self.upload(base64: base64) { complete in
                    self.fetchAccount { complete in
                        handler(complete)
                    }
                }
            }
        } else {
            self.upload(base64: base64) { complete in
             handler(complete)
            }
        }
    }
    
    func removePreference(userId: String, input: PreferenceInput, handler: @escaping (Bool) -> Void) {
        let updateInput = UserUpdateInput(id: userId, preferences: .some([input]))
                
        Network.shared.apollo.perform(mutation: UpdateUserMutation(input: .some(updateInput), labels: .some([.superUserProfile]))) { response in
            switch response {
            case .success(_):
                self.fetchAccount { complete in
                    handler(complete)
                }
            case .failure(_):
                handler(false)
                break
            }
        }
    }
    
    func addPreference(userId: String, input: PreferenceInput, handler: @escaping (Bool) -> Void) {
//        guard let account = account else { return }        
        let updateInput = UserUpdateInput(id: userId, preferences: .some([input]))
                
        Network.shared.apollo.perform(mutation: UpdateUserMutation(input: .some(updateInput), labels: .some([.superUserProfile]))) { response in
            switch response {
            case .success(_):
                self.fetchAccount { complete in
                    handler(complete)
                }
            case .failure(_):
                handler(false)
                break
            }
        }
    }
    
    fileprivate func update(account: Account) {
        self.account = account
        Network.shared.account = self.account
        self.dob = account.formattedDOBWithAge() ?? ""
        self.dobDate = account.dobDate() ?? Date().defaultBday()
        
        let addressModel = account.getAddress(type: .main)
        self.fullAddress = addressModel?.address ?? ""
        self.address = addressModel?.line1 ?? ""
        self.city = addressModel?.city ?? ""
        self.state = addressModel?.state ?? ""
        self.zipcode = addressModel?.zip ?? ""
        
        
        self.phone = account.formattedPhone() ?? ""
        self.email = account.formattedEmail() ?? ""
        self.profileUrl = account.profileURL()
        self.coaching = account.getPreference(key: .coaching)?.value?.last ?? ""
        self.focus = account.getPreference(key: .focus)?.value?.last ?? ""
        self.vitalDashboardMetricKeys = account.getPreference(key: .vitalsDashboard)?.value ?? []
        self.habitPlanId = account.getPreference(key: .habitPlan)?.value?.last
    }
    
    fileprivate func upload(base64: String, handler: @escaping (Bool) -> Void) {
        Network.shared.apollo.perform(mutation: CreateAttachmentMutation(auth: .null, input: .some(AttachmentCreateInput(label: .some(.superUserProfile) , base64: base64)))){ [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                self.profileUrl = result.data?.attachmentCreate?.attachment?.fragments.attachmentModel.contentUrl
                handler(true)
            case .failure(_):
                handler(false)
                
            }
        }
    }
    
    func registerPush() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (allowed, error) in
             //This callback does not trigger on main loop be careful
            if allowed {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
              
            }
        }
    }
    
    func register(device: String, name: String) {
        guard let userId = Network.shared.userId() else { return }
        let isProduction = isProd ? "true" : "false"
        Network.shared.apollo.perform(mutation: DeviceRegistrationMutation(input:
                .some(.init(user: userId, deviceId: device, kind: .ios, name: .some(name), production: .some(isProduction)))
        )) {  response in
            switch response {
            case .success(_): break
                
            case .failure(_): break
            }
        }
    }
    
    func unregister(device: String, handler: @escaping (Bool) -> Void) {
        Network.shared.apollo.perform(mutation: DeviceUnregisterMutation(input:
                .some(.init(deviceId: device))
        )) { response in
            switch response {
            case .success(_):
                handler(true)
                
            case .failure(_):
                handler(false)
            }
        }
    }
    
    func fetchDevices() {
        Network.shared.apollo.fetch(query: DevicesQuery(status: .some(.registerd)),
                                    cachePolicy: .returnCacheDataAndFetch) { response in
            switch response {
            case .success(let result):
                self.devices = result.data?.me?.devices?.compactMap({$0.fragments.deviceModel}) ?? []
                
            case .failure(_): break
            }
        }
    }
}


func generateRandomPassword(length: Int = 12) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let numbers = "0123456789"
    let specialCharacters = "!@#$%^&*()-_=+[]{}|;:'\",.<>?/`~"
    
    let allCharacters = letters + numbers + specialCharacters
    let requiredCharacters = [letters.randomElement()!, numbers.randomElement()!, specialCharacters.randomElement()!]
    
    var password = (0..<(length - requiredCharacters.count)).map { _ in
        allCharacters.randomElement()!
    }
    
    password.append(contentsOf: requiredCharacters) // Ensure at least one of each required type
    password.shuffle() // Shuffle for randomness
    
    return String(password)
}
