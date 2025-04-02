//
//  CalendarHeaderView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

enum CalendarAction {
    case next
    case back
    case month
}

enum CalendarHeaderConfig {
    case day, week
}

struct CalendarHeaderView: View {
    
    @Binding var date:Date
    @Binding var config: CalendarHeaderConfig
    @State private var showCal:Bool = false
    
    var onTapped: ((_ type: CalendarAction) -> Void)?
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    onTapped?(.back)
                }, label: {
                    Image.leftArrow
                })
                Spacer()
                Button(action: {
                    withAnimation {
                        showCal.toggle()
                    }
                }, label: {
                    HStack(spacing: 10) {
                        Text(date.calendarDate(config: config))
                            .style(weight: .w500)
                        Image.calendar
                            .renderingMode(.template)
                            .foregroundColor(Theme.shared.lightBlue)
                    }
                })
                .layoutPriority(1)
                Spacer()
                Button(action: {
                    onTapped?(.next)
                }, label: {
                    Image.rightArrow
                })
            }
            .padding()
            if showCal {
                DatePicker("", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
            }
        }
    }
}
