//
//  RoutineComplianceView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI
import ZalaAPI

struct RoutineComplianceView: View {
    
    @State private var showProtocols: Bool = true
    @State private var selectedItem: String? = nil
    @State private var service: RoutineService = RoutineService()
    @State private var accountService: AccountService = AccountService()
    @State private var habitService: HabitService = HabitService()
    @State var routine: MinCarePlan
    
    
    //habits
    @State private var showEndAlert: Bool = false
    @State private var showRemoveHabitAlert: Bool = false
    @State private var editHabits: Bool = false
    @State private var selectedHabits: Set<TaskModel> = []
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                ComplianceCircleView(progress: .constant(routine.score),
                                     title: .constant(routine.formattedScore))
                .frame(width: 230, height: 230)
                .padding([.bottom, .top])
                
                if let tasks = routine.tasks {
                    HStack {
                        Text("Protocols (\(tasks.count))")
                            .style(color: .white, size: .x18, weight: .w700)
                        Spacer()
                        Image.arrowUp
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 27)
                            .rotationEffect(.degrees(showProtocols ? 0 : 180))
                    }
                    .contentShape(Rectangle())
                    .padding(.bottom)
                    .onTapGesture {
                        withAnimation {
                            showProtocols.toggle()
                        }
                    }
                    if showProtocols {
                        LazyVStack {
                            ForEach(service.selectedMarketplaceRoutine?.allTasks ?? [], id: \.self) { task in
                                draw(task: task)
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
                if let id = routine.id {
                    service.marketplaceRoutineForUser(routineId: id)
                }
            })
            .navigationDestination(item: $selectedItem, destination: { item in
                RoutineComplianceDetailView()
            })
            .toolbar(.hidden, for: .tabBar)
            .padding()
            .onChange(of: service.didEndPlan, { oldValue, newValue in
                dismiss()
            })
            .alert("End Plan", isPresented: $showEndAlert) {
                Button(role: .destructive) {
                    guard let userId = Network.shared.userId() else { return }
                    guard let routineId = routine.id else { return }
                    if routine.isHabitPlan() {
                        self.accountService.removePreference(userId: userId, input: PreferenceInput(key: .habitPlan, value: [""])) { complete in
                            service.marketplaceEndPlan(routineId: routineId)
                        }
                    } else {
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
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    ToolbarHeaderView(title: routine.name ?? "Routine",
                                      subtitle: "\(routine.numberOfDaysRemaining()) days remaining")
                }
                
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
                            selectedHabits = []
                            editHabits.toggle()
                        }, label: {
                            Text("Cancel")
                        })
                    }
                } else {
                    ToolbarItem(placement: .primaryAction)
                    {
                        Menu {
                            Section {
                                if routine.isHabitPlan() {
                                    Button(action: {
                                        editHabits.toggle()
                                    }) {
                                        Label("Remove Protocols", systemImage: "chart.bar.doc.horizontal")
                                    }
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
            })
        }
    }
    
    fileprivate func draw(task: TaskModel) -> some View {
        HStack {
            if editHabits {
                isSelected(habit: task) ? Image.selected : Image.unselected
            }
            RoutineComplianceCellView(
                icon: task.taskMeta().icon,
                title: task.formattedTitle(),
                subtitle: task.formattedSubTitleTimes(),
                percent: task.score)
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
    
    fileprivate func isSelected(habit: TaskModel) -> Bool {
        return selectedHabits.contains(habit)
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
        guard let routineId = routine.id else { return }
        service.marketplaceRoutineForUser(routineId: routineId)
    }
}


extension MarketPlaceRoutine {
    var allTasks: [TaskModel] {
        return self.tasks?.compactMap({$0.fragments.taskModel}) ?? []
    }
    
    var isHabitPlan: Bool {
        return self.name?.lowercased() == "zala habit"
    }
}
