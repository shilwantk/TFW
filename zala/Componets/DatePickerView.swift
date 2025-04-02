//
//  DatePickerView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct DatePickerSheet: View {
    
    @Binding var date:Date
    @State var dateAndtime:Bool = false
    @State var timeOnly:Bool = false
    
    var body: some View {
        DatePicker("", selection: $date,
                   displayedComponents: components())
            .labelsHidden()
            .datePickerStyle(.wheel)
    }
    
    fileprivate func components() -> DatePickerComponents {
        if timeOnly {
            [.hourAndMinute]
        } else if dateAndtime {
            [.date, .hourAndMinute]
        } else {
            [.date]
        }
    }
}

#Preview {
    DatePickerSheet(date: .constant(Date()))
}
