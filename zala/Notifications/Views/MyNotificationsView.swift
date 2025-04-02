//
//  MyNotificationsView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/5/24.
//

import SwiftUI
import ZalaAPI

struct MyNotificationsView: View {
    @State var service: NotificationService = NotificationService()
    @State var messageService: MessageService = MessageService()
    @Environment(\.dismiss) var dismiss
    @State var selection: NotificationModel? = nil
    var body: some View {
        ZStack {
            if service.notifications.isEmpty {
                ZalaEmptyView(title: "Notifications", msg: "You have no notifications at this time.")
            } else {
                List {
                    ForEach(service.notifications, id: \.self) { notification in
                        buildCell(notification: notification)
                            .onTapGesture {
                                if let id = notification.id, notification.isUnread() {
                                    service.markAsRead(id: id)
                                }
                                selection = notification
                        }
                        .swipeActions(edge: .trailing) {
                            
                            Button {
                                if let id = notification.id {
                                    service.markAsRead(id: id)
                                }
                            } label: {
                                Label("Read", systemImage: "envelope.open.fill")
                                    .tint(Theme.shared.blue)
                            }
                            .tint(Theme.shared.blue)
                            
                            Button(role: .destructive) {
                                if let id = notification.id {
                                    service.removeNotification(id: id)
                                }                                
                            } label: {
                                Label("More", systemImage: "trash")
                            }
                            .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.zalaRed))                            
                        }
                    }
                }
            }
        }
        .onChange(of: service.didUpdateNotification, { oldValue, newValue in
            service.fetchNotifications()
        })
        .navigationDestination(item: $selection) { note in
            if let routineId = note.routineId() {
                RoutineDetailView(routineId: routineId, 
                                  state: .notification,
                                  notification: note)                
            }
            else if let workoutId = note.workoutId() {
                WorkoutPlansView(workoutId: workoutId, inviteOnly: true)                
            }
            else if let apptId = note.apptId() {
                MyAppointmentNotificationView(apptId: apptId)                
            }
            else if let convoId = note.conversationId() {
                MessageDetailView(conversationId: convoId)
                
            }
            else {
                NotificationDetailView(note: note)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image.close
                })
            }
        })
        .listStyle(.plain)
        .task {
            service.fetchNotifications()
        }        
    }
    
    func deleteItem(at offsets: IndexSet) {
        //               items.remove(atOffsets: offsets)
    }
    
    fileprivate func buildCell(notification: NotificationModel) -> some View {
        HStack(alignment: .center) {
            if notification.isUnread() {
                DotView(gradientColor: Theme.shared.lightBlueGradientColor)
            }
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(notification.subject ?? "")
                        .style(color: notification.msgColor(), weight: .w500)
                    Spacer()
                    HStack {
                        Text(notification.formattedDate())
                            .style(weight: .w500)
                        Image.rightArrow
                            .frame(width: 10, height: 20)
                    }
                }
                if let msg = notification.msg() {
                    Text(msg)
                        .style(size: .small, weight: .w400)
                } else {
                    Text("No message body")
                        .italic()
                        .style(color: Theme.shared.placeholderGray, size: .small, weight: .w400)
                }
                
            }
        }
    }
}

#Preview {
    MyNotificationsView()
}
