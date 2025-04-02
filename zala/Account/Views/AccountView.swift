//
//  AccountView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct AccountButton: View {
    @State var title: String = ""
    var body: some View {
        Button(action: {
            
        }, label: {
            Text(title)
                .style(color: Theme.shared.lightBlue, weight: .w700)
        })
        .frame(maxWidth: .infinity, minHeight: 55)
        .background(
            RoundedRectangle(cornerRadius: 8).fill(Theme.shared.lightBlue.opacity(0.12))
        )
    }
}

struct ProfileView: View {
    @State var url:String?
    @State var initials:String?
    @State var size: CGFloat = 44
    @State var textSize: Text.Size = Text.Size.x18
    
    var body: some View {
        if let url, !url.isEmpty {
            WebImage(url: URL(string: url),
                     options: .continueInBackground)
                .resizable()
                .interpolation(.high)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: size, height: size, alignment: .center)
        } else {
            InitalsView(initials: initials, size: size, textSize: textSize)
        }
    }
}

struct InitalsView:View {
    
    @State var initials: String?
    @State var size: CGFloat = 44
    @State var textSize: Text.Size = Text.Size.x18
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Theme.shared.darkText)
                .frame(width: size, height: size)
            Text(initials ?? "ZZ")
                .style(color: Theme.shared.grayStroke, size: textSize, weight: .w500)
        }
    }
}

struct AccountView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var showDelete: Bool = false
    @State var showSignOutAlert: Bool = false
    @State var didLogout: Bool = false
    @State var isSyncing: Bool = false
    @State var isConnecting: Bool = false
    @Binding var state: SessionTransitionState
    
    enum AccountType {
        case subscriptions
        case appointments
        case vitals
        case workouts
        case logs
        case devices
        
        func data() -> (image:Image, size: CGSize, title: String) {
            switch self {
            case .subscriptions: return (.accountSubscriptions, .init(width: 18, height: 13), "Subscriptions")
            case .appointments: return (.accountAppts , .init(width: 22, height: 22), "Appointments & Events")
            case .vitals: return (.acccountVital , .init(width: 18, height: 19), "Vitals")
            case .workouts: return (.accountActivities , .init(width: 15, height: 23), "Workouts")
            case .devices: return (.devices , .init(width: 15, height: 23), "Register Devices")
            case .logs: return (.listDash , .init(width: 22, height: 22), "Logs")
                
            }
        }
    }
    
    @State var service: AccountService = AccountService()
    @State var stripeService: StripeService = StripeService()
    @State var terraService: TerraService = TerraService()
    @State var vitalService: VitalsService = VitalsService()
    @State var url: String?
    @State var isPresentWebView: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        NavigationLink {
                            AccountProfileView(service: service)
                        } label: {
                            HStack {
                                ProfileView(url: Network.shared.account?.profileURL(),
                                            initials: service.account?.initials,
                                            size: 55)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(service.account?.fullName ?? "")
                                        .style(size: .regular, weight: .w500)
                                    Text(service.account?.formattedEmail() ?? "")
                                        .style(color: Theme.shared.lightBlue,
                                               size:.small,
                                               weight: .w400)
                                }
                                Spacer()
                                Image.arrowRight
                            }
                            .accentColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
                            )
                        }
                        buildAccountRow(type: .subscriptions)
                        buildAccountRow(type: .appointments)
                        buildAccountRow(type: .vitals)
                        buildAccountRow(type: .workouts)
                        buildAccountRow(type: .devices)
                        buildAccountRow(type: .logs)
                        terraWidget()
                        resyncHealthKit()
                    }
                }
                Spacer()
                VStack {
                    TintButton(icon:nil, title: "Sign Out") {
                        showSignOutAlert.toggle()
                    }
                }
                VersionInfoView()                
            }
            .task {
                service.fetchAccount { complete in
                    stripeService.fetchCustomerSubscriptions(status: .active) { complete in
                        
                    }
                }
            }
            .navigationTitle("My Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        showDelete.toggle()
                    }, label: {
                        Text("Delete Account")
                            .foregroundStyle(Theme.shared.red)
                    })
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image.close
                    })
                }
            })
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button(role: .destructive) {
                    Network.shared.logoutSession { complete in
                        withAnimation {
                            state = .session
//                            didLogout.toggle()
                        }
                    }
                } label: {
                    Text("Yes, Sign Out")
                }
                Button(role: .cancel) {
                } label: {
                    Text("Cancel")
                }
            } message: {
                Text("Are you sure you want to sign out? This action will log you out, and you will no longer be sharing with any super users.")
            }
            .alert("Delete Account?", isPresented: $showDelete) {
                Button(role: .destructive) {
                    Network.shared.service.deleteAccount { complete in
                        Network.shared.logoutSession { complete in
                            withAnimation {
                                state = .session
                            }
                        }
                    }
                } label: {
                    Text("Yes, Delete Account")
                }
                Button(role: .cancel) {
                } label: {
                    Text("Cancel")
                }
            } message: {
                Text("Are you sure you want to delete your account? Deleting your account will require you to create a new one and reshare all your data, as your current account will no longer be available.")
            }
        }
    }
    
    @ViewBuilder
    fileprivate func terraWidget() -> some View {
        HStack(alignment: .center, spacing: 12) {
            if isConnecting {
                ZStack {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                }.frame(minHeight: 35)
                
            } else {
                IconView(icon: .connect,
                         iconSize: .init(width: 22, height: 22),
                         imageColor: .white,
                         backgroundSize: 35,
                         gradinetColor: Theme.shared.grayGradientColor)
            }
            Text("Integrations")
                .style(size: .x18, weight:.w400)
            Spacer()
        }
        .accentColor(.white)
        .frame(maxWidth: .infinity, maxHeight: 55).padding()
        .background(
            RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
        )
        .onTapGesture {
            isConnecting.toggle()
            terraService.createWidget { widget in
                self.url = widget
            }
        }
        .onChange(of: url, { oldValue, newValue in
            if let url = newValue, !url.isEmpty {
                isPresentWebView.toggle()
                isConnecting.toggle()
            }
        })
        .sheet(isPresented: $isPresentWebView) {
            SafariWebView(url: URL(string: url ?? "")!)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    fileprivate func resyncHealthKit() -> some View {
        HStack(alignment: .center, spacing: 12) {
            if isSyncing {
                ZStack {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                }.frame(minHeight: 35)
                
            } else {
                IconView(icon: .heartSquare,
                         iconSize: .init(width: 22, height: 22),
                         imageColor: .white,
                         backgroundSize: 35,
                         gradinetColor: Theme.shared.grayGradientColor)
            }
            Text("Resynchronize HealthKit")
                .style(size: .x18, weight:.w400)
            Spacer()
        }
        .accentColor(.white)
        .frame(maxWidth: .infinity, maxHeight: 55).padding()
        .background(
            RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
        )
        .onTapGesture {
            HealthKitManager.shared.requestAuthorizationAgain {  _ in
                isSyncing.toggle()
                InsightsService.fetchAndStoreInsights(date: Date()) { complete in
                    HealthKitManager.shared.refetchHealthData()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                        self.isSyncing.toggle()
                    })
                }
            }
        }
    }
    
    fileprivate func buildAccountRow(type: AccountType) -> some View {
        NavigationLink {
            if type == .appointments {
                MyAppointmentsView().environment(service)
            }
            else if type == .subscriptions {
                MySubscriptionsView().environment(stripeService)
            }
            else if type == .vitals {
                MyVitalsView()
                    .environment(vitalService)
                    .environment(service)
            }
            else if type == .logs {
                LogView()
            }
            else if type == .workouts {
                WorkoutSettingsView(service: service)
            }
            else if type == .devices {
                DeviceManagement()
            }
            else {
                EmptyView()
            }
            
        } label: {
            let data = type.data()
            let count = type == .vitals || type == .workouts || type == .devices ? "" : " (\(countsFor(type: type)))"
            HStack(alignment: .center, spacing: 12) {
                IconView(icon: data.image,
                         iconSize: data.size,
                         imageColor: .white,
                         backgroundSize: 35,
                         gradinetColor: Theme.shared.grayGradientColor)
                Text("\(data.title)\(count)")
                    .style(size: .x18, weight:.w400)
                Spacer()
                Image.arrowRight
            }
            .accentColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 55).padding()
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
        }
    }
    
    fileprivate func countsFor(type: AccountType) -> Int {
        if type == .appointments {
            return service.personAppointments.count
        }
        else if type == .subscriptions {
            return stripeService.customerSubscriptions.count
        }
        else {
            return 0
        }
    }
    
    /// Handles the incoming URL and performs validations before acknowledging.
        private func handleIncomingURL(_ url: URL) {
            guard url.scheme == "zala" else {
                return
            }
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return
            }

            guard let action = components.host, action == "success" || action == "failed" else {
                return
            }

            
        }
}



import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}

struct VersionInfoView: View {
    var body: some View {
        Text(appVersionAndBuild)
            .font(.footnote)
            .foregroundColor(.gray)
    }

    private var appVersionAndBuild: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "Version \(version) (Build \(build))"
    }
}


import SwiftUI
import ZalaAPI

struct DeviceManagement: View {
    
    @State var service: AccountService = AccountService()
    @State private var selectedItems = Set<DeviceModel>() // Track selected items
    
    @State private var showRegisterDevice: Bool = false
    @State private var deleteDevice: Bool = false
    @State private var deviceToDelete: DeviceModel? = nil
    
    
    var body: some View {
        VStack {
            if service.devices.isEmpty {
                ZalaEmptyView(title: "No Devices Registered", msg: "")
            } else {
                List {
                    ForEach(service.devices, id: \.id) { device in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(device.name ?? "device")
                                .style(size: .regular, weight: .w500)
                            Text("Registered On - \(device.formattedUpdated())")
                                .style(color: Theme.shared.gray,
                                       size: .small,
                                       weight: .w400)
                        }
                        .padding([.top, .bottom], 2)
                    }
                    .onDelete(perform: confirmDelete)
                }
                .toolbar {
                    EditButton()
                        .tint(Theme.shared.orange)
                }
                .alert(isPresented: $deleteDevice) {
                    Alert(title: Text("Remove Device"),
                          message: Text("Removing this device will unregister it from receiving notifications. Are you sure you want to unregister this device?"),
                          primaryButton: .destructive(Text("YES, Unregister Device"), action: {
                        withAnimation {
                            if let deviceToDelete {
                                service.unregister(device: deviceToDelete.deviceId!) { complete in
                                    if complete {
                                        service.devices.removeAll { $0 == deviceToDelete }
                                        self.deviceToDelete = nil
                                    }
                                }
                            }
                        }
                    }), secondaryButton: .cancel())
                }
            }
            Spacer()
            StandardButton(title: "Register This Device", height:40) {
                showRegisterDevice.toggle()
            }
            .padding()
            .alert(isPresented: $showRegisterDevice) {
                Alert(title: Text("Register Device"),
                      message: Text("Registering this device will add it to our list of devices that will receive notifications. Are you sure you want to register this device?"),
                      primaryButton: .default(Text("YES, Register Device"), action: {
                    service.registerPush()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.fetchDevices()
                    })
                }), secondaryButton: .cancel())
            }
        }
        .task {
            fetchDevices()
        }
        .navigationTitle("Device Management")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    fileprivate func fetchDevices() {
        service.fetchDevices()
    }
    
    private func confirmDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            deviceToDelete = service.devices[index]
            deleteDevice.toggle()
        }
    }
}

#Preview {
    DeviceManagement()
}


extension DeviceModel {
    func formattedCreated() -> String {
        guard let createdAt = self.createdAt else { return "" }
        let date = Date(timeIntervalSince1970: .init(createdAt))
        if date.isToday() {
            return date.formatted(date: .omitted, time: .shortened)
        } else {
            return DateFormatter.monthDayAndTime(date: date)
        }
    }
    
    func formattedUpdated() -> String {
        guard let updatedAt = self.updatedAt else { return "" }
        let date = Date(timeIntervalSince1970: .init(updatedAt))
        if date.isToday() {
            return date.formatted(date: .omitted, time: .shortened)
        } else {
            return DateFormatter.monthDayAndTime(date: date)
        }
    }
}
