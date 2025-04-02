//
//  DashboardCalendarView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/21/24.
//

import SwiftUI

struct DashboardCalendarView: View {
    var body: some View {
        HStack(alignment: .center, content: {
            Button {
                
            } label: {
                Text("Day View")
                    .foregroundColor(Theme.shared.lightBlue)
                    .padding(10)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Theme.shared.darkText)
            )
            .padding(.leading)
            Spacer()
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    Image.arrowLeft
                        .renderingMode(.template)
                        .foregroundColor(Theme.shared.lightBlue)
                }
                Text("Jan 1, 2023 (Today)")
                    .style(color:.white, size:.regular, weight:.w500)
                
                Image.calendar
                    .renderingMode(.template)
                    .foregroundColor(Theme.shared.lightBlue)
                Button {
                    
                } label: {
                    Image.arrowRight
                        .renderingMode(.template)
                        .foregroundColor(Theme.shared.lightBlue)
                }
            }
            .frame(height: 55)
            .padding(.trailing)
            
        })
    }
}

#Preview {
    DashboardCalendarView()
}
