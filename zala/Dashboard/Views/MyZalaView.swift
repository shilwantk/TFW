//
//  MyZalaView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/28/24.
//

import SwiftUI
import ZalaAPI

enum TimeOfDay {
    case morning, afternoon, night, anytime
    
    func clcualteWorkoutTime() -> Date? {
        switch self {
        case .morning:
            return Date.randomTime(from: 3, to: 11) //backend starts morning at 3am
        case .afternoon:
            return Date.randomTime(from: 12, to: 17)
        case .night:
            return Date.randomTime(from: 18, to: 23)
            
        case .anytime:
            return Date.randomTime(from: 3, to: 17)
        }
    }
}

struct WorkoutPlanSelection: Hashable, Identifiable {
    var id: UUID = UUID()
    var plan: WorkoutPlanModel
    var timeOfDay: TimeOfDay
    var set: WorkoutSetModel
}

struct TaskSelection: Hashable, Identifiable {
    var id: UUID = UUID()
    var task: TaskModel
    var todo: TodoTask
    var timeOfDay: TimeOfDay
}

struct ScrollSelection: Hashable, Identifiable {
    var id: UUID = UUID()
    var todo: TodoTask? = nil
    var workout: WorkoutPlanModel? = nil
    
    func scrollTo(proxy: ScrollViewProxy) {
        if let todo {
            proxy.scrollTo(todo.id!, anchor: .center)
        } else if let workout {
            proxy.scrollTo(workout.id!, anchor: .center)
        }
    }
}

struct ReminderSelection: Hashable, Identifiable {
    var id: UUID = UUID()
    var task: TaskModel? = nil
    var todo: TodoTask? = nil
    var timeOfDay: TimeOfDay
    var workout: WorkoutPlanModel? = nil
    var appointment: PersonAppointment? = nil
    
    var title: String {
        if let task {
            return task.formattedTitle()
        } else if let workout {
            return workout.title ?? ""
        } else if let appointment {
            return appointment.formattedServiceTitle()
        } else {
            return ""
        }
    }
    
    var subtitle: String {
        if isWeekly {
            return "Reminder will repeat weekly"
        } else if isMonthly {
            return "Reminder will repeat monthly"
        } else {
            return "Reminder will repeat daily"
        }
    }
    
    var isWeekly: Bool {
        if let task {
            return task.isWeekly()
        } else if let workout {
            return workout.isWeekly
        } else {
            return false
        }
    }
    
    var isDaily: Bool {
        if let task {
            return task.isDaily()
        } else if let workout {
            return workout.isDaily
        } else {
            return false
        }
    }
    
    var isMonthly: Bool {
        if let task {
            return task.isMonthly()
        } else if let workout {
            return workout.isMonthly
        } else {
            return false
        }
    }
}


struct MyZalaView: View {
    @State private var showBaseline: Bool = false
    @State private var showHabits: Bool = false
    @State private var hideTips: Bool = false
    @State private var didDismiss: Bool = false
    @State private var didUpdate: Bool = false
    
    @State private var service: SurveyService = SurveyService()
    @State private var tasksService: TasksService = TasksService()
    @State private var appointmentService: AppointmentService = AppointmentService()
    @State private var accountService: AccountService = AccountService()
    @State private var workoutService: WorkoutService = WorkoutService()
    @State private var workoutManager: WorkoutManager = WorkoutManager()
    
    @State private var taskSwiftDataService: TaskSwiftDataService = TaskSwiftDataService()
    @Environment(\.modelContext) private var modelContext
    
    @State var currentDate: Date = .now
    @State var didSign: Bool = false
    
    @State var selectedTask: TaskSelection?
    @State var selectedAppointment: PersonAppointment? = nil
    @State private var calConfig: CalendarHeaderConfig = .day
    
    @Environment(\.dismiss) var dismiss
    @Binding var tabSelection: Int
    
    @State private var demoWorkout: Bool = false
    @State private var reminderSaved: Bool = false
    
    @State private var selectedWorkoutPlan: WorkoutPlanModel? = nil
    @State private var workoutPlanSelection: WorkoutPlanSelection? = nil
    
    @State private var reminderSelection: ReminderSelection? = nil
    
    @State private var checkScroll: Bool = false
    @State private var scrollSelection: ScrollSelection? = nil
    
    let manager = InsightManager()
    
    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(date: $currentDate, config: $calConfig) { type in
                if type == .next, let nextDay = currentDate.addingDays(1) {
                    currentDate = nextDay
                } else if type == .back, let previousDay = currentDate.subtractingDays(1) {
                    currentDate = previousDay
                }
            }
            ScrollViewReader { proxy in
                List {
                    Section {
                        if !hideTips {
                            ScrollView(.horizontal) {
                                HStack {
                                    CardView(title: "Zala Baseline", subtitle: "CUSTOMIZE YOUR EXPERIENCE")
                                        .onTapGesture {
                                            showBaseline.toggle()
                                        }
                                    CardView(title: "Record/Start Habit", subtitle: "CREATE DAILY HABITS", gradientColor: Theme.shared.lightBlueGradientColor)
                                        .onTapGesture {
                                            showHabits.toggle()
                                        }
                                    CardView(title: "Find SuperUsers", subtitle: "WORK WITH EXPERTS", gradientColor: Theme.shared.greenGradientColor)
                                        .onTapGesture {
                                            tabSelection = 1
                                        }
                                }
                            }
                        }
                    } header: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("For You")
                                    .style(color:.white, size: .x22, weight: .w800)
                                Spacer()
                                Button {
                                    withAnimation {
                                        hideTips.toggle()
                                    }
                                } label: {
                                    Text("\(hideTips ? "Show" : "Hide") Tips")
                                        .style(color: hideTips ? Theme.shared.blue : Theme.shared.orange, weight: .w500)
                                }
                                
                            }
                            Text("Helpful ways to get the most out of your journey.")
                                .italic()
                                .style(color: Theme.shared.placeholderGray, size: .small, weight: .w300)
                                .opacity(hideTips ? 0 : 1)
                        }.padding(.bottom, 10)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    buildSection(title: "Anytime",
                                 timeOfDay: .anytime,
                                 tasks: tasksService.anytime,
                                 appointments: [],
                                 workoutPlans: workoutService.anytimePlans,
                                 isActive: false)
                    
                    buildSection(title: "Morning",
                                 timeOfDay: .morning,
                                 tasks: tasksService.morning,
                                 appointments: appointmentService.morning,
                                 workoutPlans: workoutService.morningPlans,
                                 isActive: Date.now.isMorning(timeZone: .current))
                    
                    buildSection(title: "Afternoon",
                                 timeOfDay: .afternoon,
                                 tasks: tasksService.afternoon,
                                 appointments: appointmentService.afternoon,
                                 workoutPlans: workoutService.noonPlans,
                                 isActive: Date.now.isAfternoon(timeZone: .current))
                    
                    buildSection(title: "Evening",
                                 timeOfDay: .night,
                                 tasks: tasksService.night,
                                 appointments: appointmentService.evening,
                                 workoutPlans: workoutService.nightPlans,
                                 isActive: Date.now.isEvening(timeZone: .current))
                }
                .listStyle(.inset)
                .onChange(of: checkScroll) { _, newValue in
                    if newValue {
                        scrollIfNeeded(proxy: proxy)
                    }
                }
            }
        }
        .padding(5)
        .fullScreenCover(isPresented: $showBaseline, content: {
            NavigationStack {
                if service.hasConsented || accountService.didConsent {
                    BaselineSurveyView(didDismiss: $didDismiss)
                        .environment(service)
                } else {
                    ConsentView(didSign: $didSign)
                        .environment(service)
                }
            }
        })
        .fullScreenCover(isPresented: $showHabits, content: {
            NavigationStack {
                HabitPantryView()
            }
        })
        .onAppear(perform: {
//#if !targetEnvironment(simulator)
            registerPush()
//#endif
        })
        .task {            
            fetchData()
        }
        .onChange(of: currentDate) { oldDate, newDate in
            fetchDashboard(date: newDate, handler: { _ in })
        }
        .onChange(of: didSign, { _, _ in
            showBaseline.toggle()
        })
        .onChange(of: didDismiss) { oldDate, newDate in
            dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: .dataUpdated)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)) { _ in
                self.fetchData()
        }
        .fullScreenCover(item: $selectedAppointment, onDismiss: {
            selectedAppointment = nil
        }, content: { appointment in
            NavigationStack {
                MyAppointmentDetailView(appointment: appointment) {
                    fetchData()
                }
            }
        })
        .fullScreenCover(item: $selectedTask) {
            selectedTask = nil
        } content: { selectedTask in
            NavigationStack {
                TaskInputView(task: selectedTask.task,
                              todo: selectedTask.todo,
                              layout: selectedTask.task.layout(),
                              timeOfDay: selectedTask.timeOfDay,
                              didSave: $didUpdate)
                    .environment(taskSwiftDataService)
            }
        }
        .onChange(of: didUpdate) { oldValue, newValue in
            fetchData()
        }
        .onChange(of: workoutManager.endWorkout, { oldValue, newValue in
            workoutManager.resetStates()
            workoutPlanSelection = nil
        })
        .sheet(item: $reminderSelection, onDismiss: {
            reminderSelection = nil
        }, content: { reminder in
            ReminderView(reminder: reminder, onComplete: { complete in
                if complete {
                    if !Network.shared.showReminderAlert() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3,
                                                      execute: {
                            reminderSaved.toggle()
                            Network.shared.markReminderAlert()
                        })
                    }
                }
            })
            .presentationDetents([.fraction(0.35)])
        })
        .alert(isPresented: $reminderSaved) {
            Alert(title: Text("Reminder Saved"),
                  message: Text("Your reminder has been saved and added to the Reminders app."),
                  dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(item: $workoutPlanSelection, onDismiss: {
            workoutPlanSelection = nil
        }, content: { plan in
            NavigationStack {
                WorkoutReviewView(workoutPlan: plan.plan,
                                  workoutPlanSelection: plan,
                                  workoutManager: workoutManager,
                                  viewType: .start) { planId in                    
                }
            }
        })
    }
    
    fileprivate func registerPush() {
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
    
    fileprivate func fetchDashboard(date: Date, handler: @escaping (_ complete: Bool) -> Void) {
        tasksService.fetchTasksFor(date: date) { complete in
            appointmentService.fetchMyAppointments(date: date)
            workoutService.plansBy(.active, date)
            manager.sendInsightData()
            handler(complete)
        }
    }
    
    fileprivate func buildSection(title:String,
                                  timeOfDay: TimeOfDay,
                                  tasks: [TodoTask],
                                  appointments: [PersonAppointment],
                                  workoutPlans: [WorkoutPlanModel],
                                  isActive: Bool) -> some View {
        Section {
            if tasks.isEmpty && appointments.isEmpty && workoutPlans.isEmpty {
                emptyView()
            } else {
                ForEach(tasks, id:\.self) { todo in
                    drawCell(todo: todo, timeOfDay: timeOfDay)
                }
                ForEach(appointments, id:\.self) { appointment in
                    DashboardCellView(
                        icon: .appointments,
                        title: appointment.formattedServiceTitle(),
                        subtitle: appointment.formattedDateAndTime(),
                        routine: true,
                        isAppointment: true).onTapGesture {
                            selectedAppointment = appointment
                        }
                        .id(appointment.id!)
                }
                ForEach(workoutPlans, id:\.self) { plan in
                    draw(plan, timeOfDay: timeOfDay)
                }
            }            
        } header: {
            buildHeader(title: title, isActive: isActive)
        }
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
    }
    
    fileprivate func draw(_ workoutPlan: WorkoutPlanModel, timeOfDay: TimeOfDay) -> some View {
        DashboardCellView(
            icon: .training,
            title: workoutPlan.title ?? "",
            subtitle: "Workouts - \(workoutPlan.groups?.count ?? 0)",
            complete: check(workoutPlan, timeOfDay: timeOfDay),
            routine: true,
            url: workoutPlan.creator?.attachments?.last?.contentUrl,
            intials: workoutPlan.creator?.initials)
        .id(workoutPlan.id!)
        .onTapGesture {
            if !check(workoutPlan, timeOfDay: timeOfDay) && currentDate.isToday() {
                workoutManager.update(with: workoutPlan, timeOfDay: timeOfDay)
                if let currentSet = workoutManager.currentSet {
                    workoutPlanSelection = WorkoutPlanSelection(plan: workoutPlan,
                                                                timeOfDay: timeOfDay,
                                                                set: currentSet)
                    self.scrollSelection = .init(workout: workoutPlan)
                }
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if currentDate.isToday() {
                actions(reminder: .init(timeOfDay: timeOfDay, workout: workoutPlan))
            }
        }
    }
    
    fileprivate func drawCell(todo: TodoTask, timeOfDay: TimeOfDay) -> some View {
        DashboardCellView(
            icon: todo.task().taskMeta().icon,
            title: todo.task().formattedTitle(),
            subtitle: todo.task().formattedSubTitle(),
            complete: todo.isComplete(), //taskSwiftDataService.isComplete(todoTask: todo) check(todo, timeOfDay: timeOfDay)
            routine: true,
            url: todo.task?.carePlan?.owner?.attachments?.first?.fragments.attachmentModel.contentUrl)
        .id(todo.id)
        .onTapGesture {
            if !todo.isComplete() && currentDate.isToday(), //check(todo, timeOfDay: timeOfDay)
                let task = todo.task?.fragments.taskModel {
                self.selectedTask = TaskSelection(task: task, todo: todo, timeOfDay: timeOfDay)
                self.scrollSelection = .init(todo: todo)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if currentDate.isToday() {
                actions(reminder: .init(task: todo.task(), todo: todo, timeOfDay: timeOfDay))
            }
        }
    }
    
    fileprivate func emptyView() -> some View {
        Text("There are no items to complete.")
            .italic()
            .style(color: Theme.shared.placeholderGray, size:.small, weight: .w300)
    }
    
    fileprivate func buildHeader(title: String, isActive:Bool = false) -> some View {
        HStack {
            if isActive {
                Image.pointer
                    .shadow(color: Theme.shared.lightBlue, radius: 15)
            }
            Text(title)
                .style(color: isActive ? Theme.shared.lightBlue :  .white, size: .x22, weight: .w800)
            Spacer()
        }
    }
    
    //MARK: - Swipe
    fileprivate func actions(reminder: ReminderSelection) -> some View {
        Group {
            Button {
                self.reminderSelection = reminder
            } label: {
                Label("Reminder", systemImage: "bell.and.waves.left.and.right.fill")
                    .tint(Theme.shared.blue)
            }
            .tint(Theme.shared.blue)
            if let todo = reminder.todo, let task = reminder.task {
                Button {
                    self.scrollSelection = .init(todo: todo)
                    tasksService.complete(task: todo) { complete in
                        do {
                            try taskSwiftDataService.markComplete(task, in: modelContext)
                            fetchData()
                        } catch {
                            fetchData()
                        }
                    }
                } label: {
                    Label("Complete", systemImage: "checkmark.circle.fill")
                        .tint(Theme.shared.green)
                }
                .tint(Theme.shared.green)
            }
        }
    }
    
    //MARK: - API
    fileprivate func fetchData() {
        checkScroll = false
        fetchDashboard(date: currentDate) { complete in
            service.fetchData()
            accountService.checkConsent()
            taskSwiftDataService.checkAndStorSwiftDataTasks(tasksService.allTasks, date: currentDate, context: modelContext)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                checkScroll = true
            }
        }
    }
    
    //MARK: - Helpers
    fileprivate func scrollIfNeeded(proxy: ScrollViewProxy) {
        withAnimation {
            if let scrollSelection {
                scrollSelection.scrollTo(proxy: proxy)
            }
        }
        // Simulate completion with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            scrollSelection = nil
        }
    }
    
    fileprivate func check(_ task: TodoTask, timeOfDay: TimeOfDay) -> Bool {
        guard let vitalKey = task.task?.key else { return false }
        
        switch timeOfDay {
        case .morning:
            return tasksService.morningLookup[vitalKey] ?? false
        case .afternoon:
            return tasksService.noonLookup[vitalKey] ?? false
        case .night:
            return tasksService.nightLookup[vitalKey] ?? false
        case .anytime:
            return tasksService.vitalLookup[vitalKey] ?? false
        }
    }
    
    fileprivate func check(_ workout: WorkoutPlanModel, timeOfDay: TimeOfDay) -> Bool {
        guard let id = workout.id?.lowercased() else { return false }
        
        let vitalKey = "\(Constants.WORKOUT)_\(id)"
        switch timeOfDay {
        case .morning:
            return workoutService.morningLookup[vitalKey] ?? false
        case .afternoon:
            return workoutService.noonLookup[vitalKey] ?? false
        case .night:
            return workoutService.nightLookup[vitalKey] ?? false
        case .anytime:
            return workoutService.allLookup[vitalKey] ?? false
        }
    }
}


import SwiftUI
import EventKit

struct ReminderView: View {
    @State private var reminderTitle = ""
    @State private var reminderDate = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var reminder: ReminderSelection
    var onComplete: ((_ complete: Bool) -> Void)
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            Text("Zala Reminder")
                .style(color:.white, size: .x18, weight: .w800).padding(.top, 5)
            Text(reminder.subtitle)
                .italic()
                .style(color:Theme.shared.gray, size: .xSmall, weight: .w800)
                
            KeyValueField(key: "Reminder",
                          value: $reminderTitle,
                          placeholder: "Enter reminder title")
            DateDropDownView(selectedDate: $reminderDate,
                             dateAndTime: .constant(true),
                             darkMode: true)
            StandardButton(title: "Save") {
                requestAccessAndCreateReminder()
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Reminder"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            reminderTitle = reminder.title
        }
    }

    private func requestAccessAndCreateReminder() {
        let eventStore = EKEventStore()
        eventStore.requestFullAccessToReminders { granted, error in
            handleAccessResponse(granted: granted, error: error, eventStore: eventStore)
        }
    }

    private func handleAccessResponse(granted: Bool, error: Error?, eventStore: EKEventStore) {
        if let error = error {
            DispatchQueue.main.async {
                self.alertMessage = "Error: \(error.localizedDescription)"
                self.showAlert = true
            }
            return
        }
        
        if granted {
            createRepeatingReminder(eventStore: eventStore)
        } else {
            DispatchQueue.main.async {
                self.alertMessage = "Access to reminders is not granted."
                self.showAlert = true
            }
        }
    }
    
    
    private func createRepeatingReminder(eventStore: EKEventStore) {
        let rmd = EKReminder(eventStore: eventStore)
        rmd.title = reminderTitle
        rmd.calendar = eventStore.defaultCalendarForNewReminders()
        rmd.timeZone = .autoupdatingCurrent

        // Set a due date for the reminder
        
        let dueDateComponents = Calendar.autoupdatingCurrent.dateComponents(in: .autoupdatingCurrent, from: reminderDate)
        
        rmd.dueDateComponents = dueDateComponents

        // Add an alarm
        let alarm = EKAlarm(absoluteDate: reminderDate)        
        rmd.addAlarm(alarm)

        let recurrenceRule = EKRecurrenceRule(
            recurrenceWith: recurrenceFrequency(),
            interval: 1,
            end: nil // No end date, repeats indefinitely
        )
        rmd.addRecurrenceRule(recurrenceRule)

        // Save the reminder
        do {
            try eventStore.save(rmd, commit: true)
            dismiss()
            onComplete(true)
        } catch {
            dismiss()
            onComplete(false)
        }
    }
    
    fileprivate func recurrenceFrequency() -> EKRecurrenceFrequency{
        if reminder.isWeekly {
            .weekly
        } else if reminder.isMonthly {
            .monthly
        } else {
            .daily
        }
    }
}
