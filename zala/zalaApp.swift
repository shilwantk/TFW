//
//  zalaApp.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI
import SwiftData
import ZalaAPI


extension Notification.Name {
    static let handleDeepLink = Notification.Name("handleDeepLink")
}

// no changes in your AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
//    @ObservedObject var viewModel = NotificationManager()
    @State var service: AccountService = AccountService()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        HealthKitManager.shared.requestAccessToHealthKit()
        if HealthKitManager.getHealthKitPermission() {
            InsightsService.fetchAndStoreInsights(date: Date()) { complete in }
        }
        return true
    }
    
    //No callback in simulator -- must use device to get valid push token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let systemVersion = UIDevice.current.systemVersion
        let device = UIDevice.current.name
        let model = "\(device) running iOS:\(systemVersion)"
        service.register(device: deviceToken.hexString, name: model)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.noData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .sound, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //handle tap
        NotificationRouter.shared.handle(notification: response.notification)
        completionHandler()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: .handleDeepLink, object: url)
        return true
    }
}

struct NoteificationRoute: Identifiable, Hashable {
    var id = UUID()
    var data: UNNotification
}

@Observable class NotificationRouter {
    static let shared = NotificationRouter()
    
    var route: NoteificationRoute?
    var showNotificationView = false
    
    func handle(notification: UNNotification) {
        DispatchQueue.main.async {
            self.route = .init(data: notification)
            self.showNotificationView = true
        }
    }
}

@main
struct zalaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var notificationRouter = NotificationRouter.shared
    @State var state: SessionTransitionState = .session
    @State var isSyncing: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    let manager = InsightManager()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TaskSwiftData.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                    isStoredInMemoryOnly: false)
        
        do {
            let modelContainer = try ModelContainer(for: schema,
                                                    configurations: [modelConfiguration])
            return modelContainer
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch state {
                case .root:
                    RootView(state :$state)
                        .environment(notificationRouter)
                case .welcome:
                    NavigationStack {
                        WelcomeView(state :$state)
                    }                    
                case .login:
                    NavigationStack {
                        LoginView(state :$state)
                    }
                case .session:
                    SessionTransitionView(state: $state)
                case .loginLanding:
                    NavigationStack {
                        LoginLandingView(state :$state)
                    }
                }
            }
            .onChange(of: scenePhase, { oldValue, newPhase in
                if newPhase == .active {
                    syncHealthData()
                    manager.sendInsightData()
                }
            })
        }
        .modelContainer(sharedModelContainer)
    }
    
    func syncHealthData() {
        Task {
            HealthKitManager.shared.requestAuthorizationAgain {  _ in
                isSyncing.toggle()
                HealthKitManager.shared.refetchHealthData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    self.isSyncing.toggle()
                })
            }
        }
    }
}



struct InsightManager {
    private let lastSentKey = "lastInsightSent"
    
    /// Check if insight data should be sent today.
    func shouldSendInsight() -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        
        if let lastSentDate = UserDefaults.standard.object(forKey: lastSentKey) as? Date {
            // Check if the last sent date is earlier than today.
            return !calendar.isDate(lastSentDate, inSameDayAs: currentDate)
        }
        
        // If no last sent date exists, it's time to send the data.
        return true
    }
    
    /// Mark the current time as the last time insight data was sent.
    func updateLastSent() {
        UserDefaults.standard.set(Date(), forKey: lastSentKey)
    }
    
    /// Example function to send insight data.
    func sendInsightData() {
        guard shouldSendInsight() else {
            return
        }
        
        if HealthKitManager.getHealthKitPermission() {
            DispatchQueue.global(qos: .background).async(execute: {
                InsightsService.fetchAndStoreInsights(date: Date()) { complete in
                    updateLastSent()
                }
            })
        }
    }
}

