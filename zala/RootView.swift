//
//  RootView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/28/24.
//

import SwiftUI

struct RootView: View {
    
    @Environment(NotificationRouter.self) private var notificationRouter
    
    @State var didTapAdd: Bool = false
    @State var didSelect: Bool = false
    @State var presentRoute: Bool = false
    
    @Binding var state: SessionTransitionState
    @State private var tabSelection = 0
    @State private var selection: NoteificationRoute? = nil
    
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection) {
                NavigationStack {
                    DashboardView(didTapAdd: $didTapAdd, state: $state, tabSelection: $tabSelection)
                }
                .tabItem {
                    Image.dashboard
                    Text("Dashboard")
                        .style(color: Theme.shared.placeholderGray)
                }
                .tag(0)
                NavigationStack {
                    MySuperUsers(state: $state)
                }
                .tabItem {
                    Image.marketplace
                    Text("Marketplace")
                }
                .tag(1)
                NavigationStack {
                    MyContentView(state: $state)
                }
                .tabItem {
                    Image.content
                    Text("Content")
                }
                .tag(2)
                NavigationStack {
                    MyRoutinesView(state: $state)
                }
                .tabItem {
                    Image.routines
                    Text("Routines")
                }
                .tag(3)
                
                NavigationStack {
                    MarketPlaceEventsView(isSubscribed: .constant(true), state: $state)
                }
                .tabItem {
                    Image.events
                    Text("Events")
                }
                .tag(4)
            }
            if didTapAdd {
                ZalaAddView(close: $didTapAdd, selection: $didSelect)
                    .background(.thinMaterial)
                    .transition(.fade)
            }
        }
        .fullScreenCover(isPresented: $didSelect, content: {
            NavigationStack {
                HabitPantryView()
            }
        })
        .onAppear(perform: {
            if let route = notificationRouter.route {
                selection = route
            }
        })
        .onChange(of: notificationRouter.route, { oldValue, newValue in
            selection = newValue
        })
        .fullScreenCover(item: $selection, onDismiss: {
            selection = nil
        }, content: { note in
            NavigationStack {
                MyNotificationsView()
//                if let data = note.data.request.content.userInfo["data"] as? [String: Any] {
//                    if let workoutId = data["workoutId"] as? String {
//                        WorkoutPlansView(workoutId: workoutId, inviteOnly: true)
//                    } else if let routineId = data["routineId"] as? String {
//                        RoutineDetailView(routineId: routineId,
//                                          state: .notification)
//                    } else {
//                        MyNotificationsView()
//                    }
//                } else {
//                    MyNotificationsView()
//                }
            }
        })
    }
}
