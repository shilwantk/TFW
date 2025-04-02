//
//  DateDropDownView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI


extension Date {
    func defaultBday() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = 1981
        dateComponents.month = 1
        dateComponents.day = 1
        let userCalendar = Calendar.autoupdatingCurrent
        return userCalendar.date(from: dateComponents) ?? Date()
    }
}

struct DateDropDownView: View {
    
    @State var key: String = "Date of Birth"
    
    @Binding var selectedDate:Date
    @Binding var dateAndTime: Bool
        
    @State private var showCover:  Bool = false
    @State var isDob: Bool = true
    @State var showKey: Bool = false
    @State var isRequired: Bool = false
    @State var darkMode: Bool = true
    @State var localSelectedDate: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Button {
                withAnimation(.easeOut) {
                    showCover.toggle()
                }
            } label: {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 5) {
                            if showKey {
                                Text(key)
                                    .style(color: Theme.shared.grayStroke,
                                           size: .regular,
                                           weight: .w400)
                                    .padding(.leading)
                            }
                            HStack(alignment: .center) {
                                Text(showText() ? formattedDate() : "Select \(key)")
                                    .style(color: showText() ? .white : .white,
                                           size: .regular,
                                           weight: .w700)
                                    .padding(.leading)
                            }
                        }
                        Spacer()
                        if isDob {
                            Image.calendar
                                .padding(.trailing)
                        } else {
                            Image.downArrow
                                .rotationEffect(.radians(showCover ? .pi : 0))
                                .padding(.trailing)
                        }
                    }
                    .frame(height: 65)
                    .background(
                      LinearGradient(
                        stops: [
                            Gradient.Stop(color: darkMode ? Theme.shared.mediumBlack : Theme.shared.grayGradientColor.primary, location: 0.00),
                            Gradient.Stop(color: darkMode ? Theme.shared.mediumBlack : Theme.shared.grayGradientColor.secondary, location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                      )
                    )
                    .cornerRadius(10)
                    
                }
            }
            .animation(.linear, value: showText())
        }
        .onChange(of: showCover, { oldValue, newValue in
            selectedDate = localSelectedDate
        })
        .onAppear(perform: {
            self.localSelectedDate = selectedDate
        })
        if showCover {
            DatePickerSheet(date: $localSelectedDate,
                            dateAndtime: dateAndTime)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    func showText() -> Bool {
        return true
//        if !isDob {
//            return true
//        } else {
//            return  !(Date() < self.selectedDate)
//        }
    }
    
    fileprivate func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateAndTime ? "MMM d, yyyy  h:mm a" : "MMM d, yyyy"
        return formatter.string(from: selectedDate)
    }
}

#Preview {
    DateDropDownView(selectedDate: .constant(Date()), dateAndTime: .constant(false))
}



struct OptionalDateDropDownView: View {
    
    @State var key: String = "Date of Birth"
    @State var optionalPlaceholder: String = "Select Date"
    
    @Binding var selectedDate: Date?
    @Binding var dateAndTime: Bool
    @Binding var timeOnly: Bool
    @State   var maxDate: Date?
    @State var darkMode: Bool = true
    
    @State private var optionalDefaultDate: Date = .now
    @State private var showCover:  Bool = false
    @State var isDob: Bool = true
    @State var isRequired: Bool = false
    @State var showKey: Bool = false
    @State var usePlaceholder: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Button {
                withAnimation(.easeOut) {
                    showCover.toggle()
                }
            } label: {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 5) {
                            if showKey {
                                Text(key)
                                    .style(color: Theme.shared.grayStroke,
                                           size: .regular,
                                           weight: .w400)
                                    .padding(.leading)
                            }
                            HStack(alignment: .center) {
                                if usePlaceholder && selectedDate == nil {
                                    Text(optionalPlaceholder)
                                        .style(color: Theme.shared.grayStroke,
                                               size: .regular,
                                               weight: .w400)
                                        .padding(.leading)
                                } else {
                                    Text(showText() ? formattedDate() : "Select \(key)")
                                        .style(color: showText() ? .white : .white,
                                               size: .regular,
                                               weight: .w700)
                                        .padding(.leading)
                                }
                            }
                        }
                        Spacer()
                        if isDob {
                            Image.calendar
                                .padding(.trailing)
                        } else {
                            Image.downArrow
                                .rotationEffect(.radians(showCover ? .pi : 0))
                                .padding(.trailing)
                        }
                    }
                    .frame(height: 65)
                    .background(
                      LinearGradient(
                        stops: [
                            Gradient.Stop(color: darkMode ? Theme.shared.mediumBlack : Theme.shared.grayGradientColor.primary, location: 0.00),
                            Gradient.Stop(color: darkMode ? Theme.shared.mediumBlack : Theme.shared.grayGradientColor.secondary, location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                      )
                    )
                    .cornerRadius(10)
                    
                }
            }
            .animation(.linear, value: showText())
        }
        if showCover, let bindingDate = selectedDate {
            DatePickerSheet(date: Binding(
                get: { bindingDate },
                set: { newDate in
                    selectedDate = newDate
                }
            ), timeOnly: timeOnly)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        else if showCover, selectedDate == nil {
            DatePickerSheet(date: Binding(
                get: { optionalDefaultDate },
                set: { newDate in
                    selectedDate = newDate
                }
            ), timeOnly: timeOnly)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    func showText() -> Bool {
        return true
//        if !isDob {
//            return true
//        } else {
//            return  !(Date() < self.selectedDate)
//        }
    }
    
    fileprivate func formattedDate() -> String {
        if let selectedDate {
            let formatter = DateFormatter()
            if timeOnly {
                formatter.dateFormat = "h:mm a"
            } else if dateAndTime {
                formatter.dateFormat = "MMM d, yyyy  h:mm a"
            } else {
                formatter.dateFormat =  "MMM d, yyyy"
            }
            return formatter.string(from: selectedDate)
        } else {
            return "Select \(key)"
        }
    }
}
