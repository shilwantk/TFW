//
//  RoutineDetailView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import ZalaAPI

enum RoutineDetailState {
    case notification
    case marketplace
    case myroutine
    case none
}

enum ProtocolType {
    case all
    case activeOnly
}


struct RoutineDetailView: View {
    @State var superUser: SuperUser? = nil
    @State var orgId: ID? = nil
    @State var isSubscribed: Bool = true
    @State var protocolType: ProtocolType = .all
    @State var routineId: ID
    @State var state: RoutineDetailState = .marketplace
    @State var notification: NotificationModel? = nil
    @State private var showProtocols: Bool = true
    @State var isLoading: Bool = false
    
    @State private var service: RoutineService = RoutineService()
    @State private var notificationService: NotificationService = NotificationService()
    @State private var accountService: AccountService = AccountService()
    @State private var habitService: HabitService = HabitService()
    @State private var stripeService: StripeService = StripeService()
    
    //habits
    @State private var showEndAlert: Bool = false
    @State private var showRemoveHabitAlert: Bool = false
    @State private var editHabits: Bool = false
    @State private var selectedHabits: Set<TaskModel> = []
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            ZStack(alignment:.top) {
                if isLoading {
                    LoadingBannerView()
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            if let routine = service.selectedMarketplaceRoutine {
            ScrollView {
                    BannerView(url: routine.banner()).padding(.bottom)
                    MetaView(itemOne: MetaItem(title: "Main Focus", subtitle: routine.focus?.capitalized ?? "", image: .tag),
                             itemTwo: MetaItem(title: "Duration", subtitle: "\(routine.durationInDays ?? 0) days", image: .clockRoutine),
                             itemThree: MetaItem(title: "Vitals Tracked", subtitle: "\(routine.monitors?.count ?? 0)", image: .iconVitals))
                    DescriptionView(desc: routine.description ?? "No Description").padding()
                    VStack {
                        ExpandedHeaderView(title: "Protocols", expand: $showProtocols)
                        if showProtocols {
                            build(routine: routine)
                        }
                        if !isSubscribed {
                            buildSubscribeView()
                        }
                    }.padding()
                }
                Spacer()
                if let superUser, !isSubscribed {
                    SubscriptionButtonView(superUser: superUser, isSubscribed: .constant(false))
                } else if state == .notification {
                    StandardButton(title: "ACCEPT INVITE") {
                        isLoading = true
                        service.accept(routineId: routineId)
                    }.padding()
                } else if protocolType == .all {
                    StandardButton(title: "START ROUTINE") {
                        if let id = routine.id {
                            isLoading = true
                            service.assignRoutine(id: id, title: routine.name ?? "Zala plan") { _ in
                                isLoading = false
                                dismiss()
                            }
                        }
                    }.padding()
                }
            }
        }
        .onChange(of: service.accepted, { oldValue, newValue in
            isLoading = false
            dismiss()
        })
        .navigationTitle(service.selectedMarketplaceRoutine?.name ?? "Routine")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            fetchData()
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            if state == .myroutine {
                if editHabits {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            if !selectedHabits.isEmpty {
                                showRemoveHabitAlert.toggle()
                            } else {
                                editHabits.toggle()
                            }
                        }) {
                            Text("Save")
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            editHabits.toggle()
                        }, label: {
                            Text("Cancel")
                        })
                    }
                } else {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Section {
                                Button(action: {
                                    editHabits.toggle()
                                }) {
                                    Label("Remove Protocols", systemImage: "chart.bar.doc.horizontal")
                                }
                                
                                Button(action: {
                                    showEndAlert.toggle()
                                }, label: {
                                    Label("End Plan", systemImage: "exclamationmark.octagon")
                                })
                            }
                        }
                    label: {
                        Label("menu", systemImage: "ellipsis.circle")
                    }
                    }
                }
            }
        }
        .onChange(of: service.didEndPlan, { oldValue, newValue in
            dismiss()
        })
        .alert("End Plan", isPresented: $showEndAlert) {
            Button(role: .destructive) {
                guard let userId = Network.shared.userId() else { return }
                self.accountService.removePreference(userId: userId, input: PreferenceInput(key: .habitPlan, value: [""])) { complete in
                    service.marketplaceEndPlan(routineId: routineId)
                }
            } label: {
                Text("Yes, End Plan")
            }
            Button(role: .cancel) {
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("Are you sure you want to end routine? This action will end your routine, and you will no longer be sharing with any super users you have subscribed to.")
        }
        .alert("Remove Protocols", isPresented: $showRemoveHabitAlert) {
            Button(role: .destructive) {
                self.removeHabbits()
            } label: {
                Text("Yes, Remove Protocols")
            }
            Button(role: .cancel) {
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("Are you sure you want to remove these protocols? This action will remove your protocol, and if it’s a habit, you will need to add it back through the habit builder. Otherwise, your superuser will have to add it back")
        }
    }
    
    @ViewBuilder
    fileprivate func buildProtocolHeader() -> some View {
        HStack {
            Text("Protocols")
                .style(color: .white, size: .x18, weight: .w700)
            Spacer()
            Image.arrowUp
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 27)
                .rotationEffect(.degrees(showProtocols ? 0 : 180))
        }
        .onTapGesture {
            withAnimation {
                showProtocols.toggle()
            }
        }
    }
    
    @ViewBuilder
    fileprivate func build(routine: MarketPlaceRoutine) -> some View {
        LazyVStack {
            ForEach(routine.tasks ?? [], id:\.id) { task in
                build(task: task.fragments.taskModel)
            }
        }
        .padding(.bottom)
        .protocolOverlay(show: $isSubscribed)        
    }
    
    fileprivate func build(task: TaskModel) -> some View {
        HStack {
            if editHabits {
                isSelected(habit: task) ? Image.selected : Image.unselected
            }
            DashboardCellView(
                icon: task.taskMeta().icon,
                title: task.formattedTitle(),
                subtitle: task.formattedSubTitle(),
                routine: true,
                isMarketplace: true)
        }
        .onTapGesture {
            if editHabits {
                if isSelected(habit: task) {
                    selectedHabits.remove(task)
                } else {
                    selectedHabits.insert(task)
                }
            }
        }
    }
    
    fileprivate func buildSubscribeView() -> some View {
        VStack {
            Text("A qualifying subscription package is necessary to begin this routine.")
                .style(color: Theme.shared.orange, size: .regular, weight: .w400)
                .multilineTextAlignment(.center)
                .padding([.top, .bottom], 5)
        }
        .frame(maxWidth: .infinity, minHeight: 55)
        .background(
            RoundedRectangle(cornerRadius: 8).fill(Theme.shared.orange.opacity(0.12))
        )
    }
    
    fileprivate func isSelected(habit: TaskModel) -> Bool {
        return selectedHabits.contains(habit)
    }
    
    fileprivate func isInvite() -> Bool {
        return superUser == nil && orgId == nil
    }
    
    fileprivate func removeHabbits() {
        let ids = selectedHabits.compactMap({$0.id})
        guard !ids.isEmpty else { return }
        let queue = DispatchQueue(label: "remove_habits", qos: .background, attributes: .concurrent)
        let group = DispatchGroup()
        queue.async(group: group, execute: {
            for id in ids {
                group.enter()
                self.habitService.cancelHabit(id: id) { _ in
                    group.leave()
                }
            }
        })
        group.notify(queue: .main) {
            editHabits.toggle()
            fetchData()
        }
    }
    
    fileprivate func fetchData() {
        if let orgId {
            service.marketplaceRoutineDetail(orgId: orgId, routineId: routineId)
        } else {
            service.marketplaceRoutineForUser(routineId: routineId, all: protocolType == .all)
        }
        
        if let notification, let id = notification.id {
            notificationService.markAsRead(id: id)
        }
        
        if let superUserId = superUser?.id {
            stripeService.fetchCustomerSubscriptions(status: .active) { complete in
                isSubscribed = stripeService.isSubscribed(superuserId: superUserId)
            }
        }
    }
}
