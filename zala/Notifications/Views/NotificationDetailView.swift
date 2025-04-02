//
//  NotificationDetailView.swift
//  zala
//
//  Created by Kyle Carriedo on 11/30/24.
//

import SwiftUI
import ZalaAPI

struct NotificationDetailView: View {
    
    var note: NotificationModel
    
    var body: some View {
        VStack {
            ScrollView {
                Text(note.msg() ?? "")
                    .style(size: .x19, weight: .w400)
            }            
            Spacer()
        }
        .navigationTitle(note.subject ?? "Notification")
        .navigationBarTitleDisplayMode(.inline)
    }
}
