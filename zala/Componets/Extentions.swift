//
//  Extentions.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import Foundation
import SwiftUI
import KeychainSwift
import JWTDecode
import CoreLocation

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}



extension DateFormatter {
    static func dateFromMultipleFormats(fromString dateString: String) -> Date? {
        return DateFormatter().dateFromMultipleFormats(fromString: dateString)
    }
    
    
    ///Wed, Apr 18",
    static func weekdayMonthDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: date)
    }
    
    static func monthOnly(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    ///Mar 1
    static func monthDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM, d"
        return formatter.string(from: date)
    }
    
    ///Mar 1 at 12:00 PM",
    static func monthDayAndTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM d 'at' h:mm a"
        return formatter.string(from: date)
    }
    
    static func timeOnly(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    static func dayOnly(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    ///Mar 1, 2024 - 12:00 PM",
    static func taskDueFullDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM d, yyyy - h:mm a"
        return formatter.string(from: date)
    }
    
    static func dateFrom(epoc: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(epoc))
    }
    
    func dateFromMultipleFormats(fromString dateString: String) -> Date? {
        let formats: [String] = [
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd",
            "MM/dd/yyyy",
            "yyyy-MM-dd",
            "yyyy-dd-MM",
            "yyyy-MM-d",
            "yyyy-d-MM"
        ]
        for format in formats {
            self.dateFormat = format
            if let date = self.date(from: dateString) {
                return date
            }
        }
        return nil
    }
    
    ///from startHour: Int, to endHour: Int is 24hr
    func createDateRange(from startHour: Int, to endHour: Int) -> (Date, Date)? {
        let calendar = Calendar.current
        let now = Date()
        
        // Get the current date components
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        // Set the start time to 8 AM
        var startTimeComponents = DateComponents()
        startTimeComponents.year = components.year
        startTimeComponents.month = components.month
        startTimeComponents.day = components.day
        startTimeComponents.hour = startHour // 8 AM
        startTimeComponents.minute = 0
        startTimeComponents.second = 0
        
        // Set the end time to 6 PM
        var endTimeComponents = DateComponents()
        endTimeComponents.year = components.year
        endTimeComponents.month = components.month
        endTimeComponents.day = components.day
        endTimeComponents.hour = endHour // 6 PM
        endTimeComponents.minute = 0
        endTimeComponents.second = 0
        
        // Create start and end dates
        if let startDate = calendar.date(from: startTimeComponents), let endDate = calendar.date(from: endTimeComponents) {
            return (startDate, endDate)
        } else {
            return nil
        }
    }
    
    func timeOfDay(from startHour: Int) -> Date? {
        let calendar = Calendar.current
        let now = Date()
        
        // Get the current date components
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        // Set the start time to 8 AM
        var startTimeComponents = DateComponents()
        startTimeComponents.year = components.year
        startTimeComponents.month = components.month
        startTimeComponents.day = components.day
        startTimeComponents.hour = startHour // 8 AM
        startTimeComponents.minute = 0
        startTimeComponents.second = 0
        return calendar.date(from: startTimeComponents)
    }
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}


extension Date {
    
    static let autoupdatingCurrentCalendar = Calendar.autoupdatingCurrent
    
    func dateByAdding(minutes: Int) -> Date? {
        // Create a DateComponents object to represent the given number of minutes
        var dateComponents = DateComponents()
        dateComponents.minute = minutes
        
        // Create a Calendar object
        let calendar = Calendar.current
        
        // Calculate the date with the specified minutes added to the current date
        return calendar.date(byAdding: dateComponents, to: self)
    }
    
    var nearestHour: Date {
        let cal = Date.autoupdatingCurrentCalendar
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = cal.date(from: Calendar.current.dateComponents(components, from: self))!
        return cal.date(byAdding: .hour, value: 1, to: date)!
    }
    
    var startOfDay: Date {
        return Date.autoupdatingCurrentCalendar.startOfDay(for: self)
    }
    
    static func dateFromISO(dateString: String) -> Date {
        let dateFormatter        = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone]
        return dateFormatter.date(from: dateString)!
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        return Date.autoupdatingCurrentCalendar.dateComponents([.day], from: start, to: end).day!
    }
    
    static func hoursBetweenDates(startDate: Date, endDate: Date) -> Int {
        let cal = Date.autoupdatingCurrentCalendar
        let components = cal.dateComponents([.hour], from: startDate, to: endDate)
        return components.hour ?? 0
    }
    
    static func minutesBetweenDates(startDate: Date, endDate: Date) -> Int {
        let cal = Date.autoupdatingCurrentCalendar
        let components = cal.dateComponents([.minute], from: startDate, to: endDate)
        return components.minute ?? 0
    }
    
    var isInPast: Bool {
        return self < Date()
    }
    var isInFuture: Bool {
        return self > Date()
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Date.autoupdatingCurrentCalendar.date(byAdding: components, to: startOfDay)
    }
    
    func endOfDayByTime() -> Date {
        return Calendar.autoupdatingCurrent.date(bySetting: .hour, value: 23, of: self)!
            .addingTimeInterval(59 * 60 + 59) // Add 59 minutes and 59 seconds
    }
    
    static func yearMonthDayString(date: Date) -> String {
        //        2017-12-11",
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-d"
        return formatter.string(from: date)
    }
    
    static func taskDueFullDate(date: Date) -> String {
        //        Mar 1, 2024 - 12:00 PM",
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM d, yyyy - h:mm a"
        return formatter.string(from: date)
    }
    static func ageFromDateOfBirth(dob: String) -> String {
        guard let birthday = DateFormatter().dateFromMultipleFormats(fromString: dob) else { return "0" }
        guard let age = Calendar.autoupdatingCurrent.dateComponents([.year], from: birthday, to: Date()).year else { return "0" }
        return "\(age)"
    }
    
    static func yearMonthDayDateFromString(dateString: String) -> Date {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateString)
        return date!
    }
    
    static func dobMonthDay(dob: String) -> String {
        guard let dobDate = DateFormatter().dateFromMultipleFormats(fromString: dob) else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM d"
        return formatter.string(from: dobDate)
    }
    
    static func formattedDOB(dob: String) -> String {
        guard let dobDate = DateFormatter().dateFromMultipleFormats(fromString: dob) else { return "" }
        return Date.dateStringFromDate(date: dobDate, dateStyle: .medium, timeStyle: .none, isRelative: false)
    }
    
    static func dateStringFromDate(date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, isRelative: Bool) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = isRelative
        return formatter.string(from: date)
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    
    func isGreaterThanOrEqualTo(_ date: Date) -> Bool {
        return self >= date
    }
    
    func add(_ duration: Calendar.Component, _ value: Int) -> Date? {
        return Calendar.current.date(byAdding: duration, value: value, to: self)
    }
    
    func calendarDate(config: CalendarHeaderConfig) -> String {
        
        if config == .day {
            let dateString = Date.dateStringFromDate(date: self, dateStyle: .medium, timeStyle: .none, isRelative: false)
            if Calendar.autoupdatingCurrent.isDateInToday(self) {
                return "\(dateString) (Today)"
            } else {
                return dateString
            }
        } else {
            if isCurrentWeek() {
                return "\(weekRangeString()) (Current)"
            } else {
                return weekRangeString()
            }
        }
    }
    
    func isSameDay(as otherDate: Date) -> Bool {
        return Calendar.autoupdatingCurrent.isDate(self, inSameDayAs: otherDate)
    }
    
    func isCurrentWeek() -> Bool {
        let calendar = Calendar.autoupdatingCurrent
        
        // Get the start and end of the current week
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        // Compare the date with the start and end of the week
        return self >= startOfWeek && self <= endOfWeek
    }
    
    func weekRange() -> (start: Date, end: Date)? {
        let calendar = Calendar.autoupdatingCurrent
        
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        
        
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)?.endOfDayByTime() else {
            return nil
        }
        return (startOfWeek, endOfWeek)
    }
    
    func weekRangeString() -> String {
        guard let data = weekRange() else { return "" }
        let startOfWeek = data.start
        let endOfWeek = data.end
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd" // Format for start and end of week
        let startString = dateFormatter.string(from: startOfWeek)
        let endString = dateFormatter.string(from: endOfWeek)
        
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let yearString = yearFormatter.string(from: endOfWeek)
        
        return "\(startString) - \(endString), \(yearString)"
    }
    
    func timeOfDay() -> String {
        let calendar = Calendar.autoupdatingCurrent
        let hour = calendar.component(.hour, from: self)
        
        switch hour {
        case 6..<12:
            return "morning"
        case 12..<18:
            return "afternoon"
        default:
            return "evening"
        }
    }
    
//    var isMorning: Bool {
//        let hour = Calendar.current.component(.hour, from: self)
//        return hour >= 5 && hour < 12 // Morning is between 5 AM and 11:59 AM
//    }
//
//    var isAfternoon: Bool {
//        let hour = Calendar.current.component(.hour, from: self)
//        return hour >= 12 && hour < 17 // Afternoon is between 12 PM and 4:59 PM
//    }
//
//    var isEvening: Bool {
//        let hour = Calendar.current.component(.hour, from: self)
//        return hour >= 17 && hour < 21 // Evening is between 5 PM and 8:59 PM
//    }
//
//    var isNight: Bool {
//        let hour = Calendar.current.component(.hour, from: self)
//        return hour >= 21 || hour < 5 // Night is between 9 PM and 4:59 AM
//    }
    
    func isMorning(timeZone: TimeZone) -> Bool {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = timeZone
        let hour = calendar.component(.hour, from: self)
        return hour >= 3 && hour < 12 // Morning is between 5 AM and 11:59 AM
    }
    
    func isAfternoon(timeZone: TimeZone) -> Bool {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = timeZone
        let hour = calendar.component(.hour, from: self)
        return hour >= 12 && hour < 17 // Afternoon is between 12 PM and 4:59 PM
    }
    
    func isEvening(timeZone: TimeZone) -> Bool {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = timeZone
        let hour = calendar.component(.hour, from: self)
        return (hour >= 17) // Evening is between 5 PM and 4:59 AM
    }
    
    func createDate(hour: Int, minute: Int = 0, second: Int = 0) -> Date? {
        let calendar = Calendar.autoupdatingCurrent
        var components = calendar.dateComponents([.year, .month, .day], from: Date()) // Use today's date
        components.hour = hour
        components.minute = minute
        components.second = second
        return calendar.date(from: components)
    }

    func subtractOneWeek() -> Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .weekOfYear, value: -1, to: self) ?? self
    }
    
    func forwardOneWeek() -> Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .weekOfYear, value: 1, to: self) ?? self
    }
    
    func addingDays(_ days: Int) -> Date? {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: days, to: self)
    }
    
    func subtractingDays(_ days: Int) -> Date? {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -days, to: self)
    }
    
    func subtractingMin(_ mins: Int) -> Date? {
        return Calendar.autoupdatingCurrent.date(byAdding: .minute, value: -mins, to: self)
    }
    
    func subtractingHr(_ hrs: Int) -> Date? {
        return Calendar.autoupdatingCurrent.date(byAdding: .hour, value: -hrs, to: self)
    }
    
    func addingMin(_ mins: Int) -> Date? {
        return Calendar.autoupdatingCurrent.date(byAdding: .minute, value: mins, to: self)
    }
    
    static func date(forDay day: Int, month: Int, year: Int) -> Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        return calendar.date(from: dateComponents)
    }
    
    static func convertToGMT(from date: Date, in timeZone: TimeZone) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        
        // Extract date components in the specified time zone
        var components = calendar.dateComponents(in: timeZone, from: date)
        components.timeZone = TimeZone(secondsFromGMT: 0) // Convert to GMT
        
        // Create the GMT-adjusted date
        return calendar.date(from: components)
    }
    
    static func randomTime(from: Int, to: Int) -> Date? {
        
        guard from >= 0, from <= 23, to >= 0, to <= 23, from <= to else { return nil }
        
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0) // GMT Time Zone
        
        
        let currentDate = Date() // Current date and time
        let localTimeZone = TimeZone.current // Your local time zone
        let gmtDate = convertToGMT(from: currentDate, in: localTimeZone)
        
        
//        let gmtDate = calendar.date(byAdding: .second, value: -TimeZone.current.secondsFromGMT(for: now), to: now)
        
        guard let currentDayInGMT = gmtDate else { return nil }
        
        // Start of the day in GMT
        components.year = calendar.component(.year, from: currentDayInGMT)
        components.month = calendar.component(.month, from: currentDayInGMT)
        components.day = calendar.component(.day, from: currentDayInGMT)
        
        
        // Define the start and end times
        components.hour = from
        components.minute = 0
        components.second = 0
        guard let startDate = components.date else { return nil }
        
        components.hour = to
        components.minute = 59
        components.second = 59
        guard let endDate = components.date else { return nil }
        
        // Ensure startDate and endDate are in the same day and valid
        guard startDate <= endDate else {
            return nil
        }
        
        // Random time interval between start and end
        let randomInterval = TimeInterval.random(in: startDate.timeIntervalSinceReferenceDate...endDate.timeIntervalSinceReferenceDate)
        
        return Date(timeIntervalSinceReferenceDate: randomInterval)                
    }
    
}

extension String {
    
    func strippingMarkdown() -> String {
            let patterns = [
                "###",
                "\\*\\*(.*?)\\*\\*",  // Bold (**text**)
                "\\*(.*?)\\*",        // Italic (*text*)
                "\\[(.*?)\\]\\((.*?)\\)", // Links [text](url)
                "`(.*?)`",            // Inline code `text`
                "~~(.*?)~~"           // Strikethrough ~~text~~
            ]
            
            var result = self
            for pattern in patterns {
                result = result.replacingOccurrences(of: pattern, with: "$1", options: .regularExpression)
            }
            
            return result
        }
    
    func withoutHtmlTags() -> String {
            let str = self.replacingOccurrences(of: "<style>[^>]+</style>", with: "", options: .regularExpression, range: nil)
            return str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        }
    
    /// Takes a string and formats it into a phone number.
    /// - Parameters:
    ///   - pattern: "+# (###) ###-####"
    ///   - replacementCharacter: "#"
    /// - Returns: "+1 (123) 456-7890"
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    func stripPhone() -> String {
        var phone = self.replacingOccurrences(of: "(", with: "")
        phone = phone.replacingOccurrences(of: ")", with: "")
        phone = phone.replacingOccurrences(of: " ", with: "")
        phone = phone.replacingOccurrences(of: "-", with: "")
        phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        return phone
    }
    
    func trimWhiteSpaceAndNewLines() -> String {
        var name = self
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return name
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[a-zA-Z0-9]).{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: self)
    }
    
    static func isValidSearch(string:String?) -> Bool {
        guard let search = string else { return false }
        return !search.isEmpty
    }
    
    func initials() -> String {
        // Split the full name into components separated by spaces
        let components = self.split(separator: " ")
        
        // Map each component to its first character and join them together
        let initials = components.compactMap { $0.first }.map { String($0) }.joined()
        
        // Return the initials in uppercase
        return initials.uppercased()
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func toDictionary() -> [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return json
        } catch {
            return nil
        }
    }
    
    
    func decodeJSON<T: Decodable>(to type: T.Type) -> T? {
        guard let jsonData = self.data(using: .utf8) else {
            return nil
        }
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedObject
        } catch {
            return nil
        }
    }
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    
    
    func formatPhoneForCalling() ->  String {
        var phone = self
        phone = phone.replacingOccurrences(of: "(", with: "")
        phone = phone.replacingOccurrences(of: ")", with: "")
        phone = phone.replacingOccurrences(of: "-", with: "")
        phone = phone.replacingOccurrences(of: " ", with: "")
        return phone
    }
    
    static let defualtColor = "#F7F8F8"
    
    static let superUserProfile = "profile_picture"
    static let profileColor = "profile_color"
    static let superUserBio = "person.bio"
    static let superUserMainFocus = "person.main_focus"
    static let userTags = "person.tags"
    static let userCertificates = "person.certificates"
    
    
    static let superUserSecondaryFocus = "person.secondary_focus"
    static let superUserConsent = "person.consent_link"
    static let superUserProfileUrl = "profile_picture"
    static let superUserProfileVideoUrl = "profile_video"
    static let superUserWelcomeVideoUrl = "welcome_video"
    
    static let routineBanner = "banner"
    static let mainLabel = "main"
    
    static let coaching = "person.coaching"
    static let focus = "person.focus"
    static let stripeCustomerId = "person.stripeId"
    static let vitalsDashboard = "person.vitals.dashboard"
    
    //kinds
    static let appointment  = "appointment"
    
    //role
    static let person  = "person"
    static let provider  = "provider"
    
    
    static let billing  = "billing"
    static let main     = "main"
    static let pharmacy = "pharmacy"
    
    //Stripe
    static let subscription = "subscription"
    static let simple = "simple"
    
    static let ios = "ios"
    static let unregistered = "unregistered"
    static let registerd = "registered"
    static let active = "active"
    static let inactive = "inactive"
    
    static let booked = "booked"
    static let cancelled = "cancelled"
    static let confirmed = "confirmed"
    static let pending = "pending"
    
    
    static let meal = "meal"
    
    //HealthKit Graphing
    static let secondary = "secondary"
    static let primary = "primary"
    
    
    //Notifications
    static let newTravelAppointment = "New Travel Appointment Booking Request"
    static let newAppointment = "New Appointment Created"
    
    //Walkthough complete
    static let walkthrough = "walkthrough"
    static let configureDashboard = "configureDashboard"
    
    
    static let reminderAlert = "configureDashboard"
    
    //habit
    static let habitPlan = "person.habit"
    
    //habit
    static let consent = "document.signature"
    
    //Maxes
    static let squat = "workout.squat.max"
    static let bench = "workout.bench.max"
    static let deadlift = "workout.deadlift.max"
    
    
    //Sleep Schedule
    static let wakupTime = "person.wakeup"
    static let bedtime = "person.bedtime"
    
}

extension CGFloat {
    static let superUserProfileLarge = 88.0
}


//MARK: - Image
extension Image {
    //system
    static let plus = Image(systemName: "plus")
    static let camera = Image(systemName: "camera")
    static let arrowRight = Image(systemName: "chevron.right")
    static let arrowLeft = Image(systemName: "chevron.left")
    static let stethoscope = Image(systemName: "stethoscope")
    static let checkmark = Image(systemName: "checkmark")
    static let clock = Image(systemName: "clock")
    static let checklist = Image(systemName: "checklist.checked")
    static let bubble = Image(systemName: "text.bubble")
    static let exclamationmark = Image(systemName: "exclamationmark.circle")
    static let ellipsis = Image(systemName:"ellipsis.circle")
    static let creditcard = Image(systemName:"creditcard")
    static let pencil = Image(systemName:"pencil")
    static let exclamationmarkFill = Image(systemName:"exclamationmark.circle.fill")
    static let paperclipCircle = Image(systemName:"paperclip.circle")
    static let paperclip = Image(systemName:"paperclip")
    static let trash = Image(systemName:"trash")
    static let lock = Image(systemName:"lock")
    static let lockFill = Image(systemName:"lock.fill")
    
    static let uploadCloud = Image(systemName:"icloud.and.arrow.up")
    
    static let emptySquare = Image(systemName:"square")
    static let checkmarkSquare = Image(systemName:"checkmark.square.fill")
    static let pdf = Image(systemName:"doc")
    static let photo = Image(systemName:"photo")
    static let signature = Image(systemName:"signature")
    static let docPlaintext = Image(systemName:"doc.plaintext")
    static let playFill = Image(systemName:"play.fill")
    static let pause = Image(systemName:"pause")
    
    
    static let wifi = Image(systemName:"wifi")
    static let noWifi = Image(systemName:"wifi.slash")
    static let shareIcon = Image(systemName:"square.and.arrow.up")
    static let infoCircle = Image(systemName:"info.circle")
    static let heartSquare = Image(systemName:"heart.square")
    static let eyeSlashCircle = Image(systemName:"eye.slash.circle")
    static let eyeCircleFill = Image(systemName:"eye.circle.fill")
    static let listDash = Image(systemName:"list.dash")
    static let connect = Image(systemName:"point.3.filled.connected.trianglepath.dotted")
    static let store = Image(systemName:"storefront.fill")
    
    
    
    
    
    
    
    //empty
    static let emptyEvents = Image("events-empty")
    
    
    
    
    //custom
    static let connected = Image("connected")
    static let selected = Image("selected")
    static let unselected = Image("unselected")
    static let downArrow = Image("down-arrow")
    static let arrowUp = Image("arrow-up")
    static let loginHero = Image("login hero")
    static let logo = Image("logo")
    static let logoBlue = Image("zala-logo-mark")
    
    static let profileQuestion = Image("profile question")
    static let close = Image("icon-close")
    static let walking = Image("walking")
    static let hourGlass = Image("hour-glass")
    static let pills = Image("pills")
    static let pointer = Image("pointer")
    static let brain = Image("brain")
    static let journal = Image("journal")
    static let calendar = Image("calendar")
    static let cart = Image("icon-store")
    static let appointments = Image("icon-appts")
    static let iconAdd = Image("icon-add")
    static let pencilCircle = Image("pencilCircle")
    static let tag = Image("icon-tag")
    static let clockRoutine = Image("clock")
    static let iconVitals = Image("icon-vitals")
    static let measure = Image("measure")
    static let dollarSign = Image("dollarSign")
    static let location = Image("location")
    static let people = Image("people")
    static let gold = Image("gold")
    static let platinum = Image("platinum")
    static let bronze = Image("bronze")
    static let sleep = Image("sleep")
    static let environmental = Image("environmental")
    static let breathing = Image("breathing")
    static let spiritual = Image("spiritual")
    static let social = Image("social")
    static let nutrition = Image("nutrition")
    static let training = Image("training")
    static let checkmarkLarge = Image("large checkmark")
    static let pieGraph = Image("pie-graph")
    static let graphUp = Image("graph-up")
    static let streak = Image("streak")
    static let send = Image("send")
    static let closeMini = Image("icon-close-mini")
    static let trashEdit = Image("trash")
    static let pencilEdit = Image("pencil")
    
    static let coaching = Image("coaching")
    static let email = Image("email")
    static let focus = Image("focus")
    static let gender = Image("gender")
    static let phone = Image("phone")
    static let pinLocation = Image("pin-location")
    static let paymentIcon = Image("payment icon")
    static let plusCircle = Image("icon-add-circle")
    static let restMini = Image("rest-mini")
    static let stopwatch = Image("stopwatch")
    static let xIcon = Image("x-icon")
    
    static let bell = Image("bell")
    static let messages = Image("messages")
    static let iconProfile = Image("icon-profile")
    static let locationMini = Image("icon-location")
    static let travel = Image("icon-travel")
    static let video = Image("icon-video")
    static let virtualVisit = Image("icon-video")
    
    
    
    
    static let dashboard = Image("icon-dash-stroke")
    static let content = Image("icon-content-stroke")
    static let events = Image("icon-events-stroke")
    static let routines = Image("icon-protocol-stroke")
    static let marketplace = Image("icon-superuser-stroke")
    static let profilePlaceholder = Image("profile placeholder")
    static let profileVideoPlaceholder = Image("video lg placeholder")
    static let routinePlaceholder = Image("routine placeholder")
    
    static let logoLrg = Image("zala-logo-mark")
    
    static let hkPending = Image("healthkit pending")
    static let hkActive = Image("healthkit active")
    static let profileEmpty = Image("profile-empty")
    static let zalaCardLogo = Image("zala card logo")
    static let subscriptionPlaceholder = Image("subscription placeholder")
    
    
    static let liked = Image("icon-heart-fill")
    static let disliked = Image("icon-heart")
    
    static let locationType = Image("icon location type")
    static let travelType = Image("icon travel type")
    static let virtualType = Image("icon virtual type")
    
    static let habitBanner = Image("habit banner")
    
    //Account
    static let acccountVital = Image("vital line")
    static let accountSubscriptions = Image("zala-logo-mark-solid")
    static let accountAppts = Image("icon-appts")
    static let accountActivities = Image("activities")
    static let devices = Image(systemName:"iphone.gen2.motion")
    
    static let menuHabit = Image("icon-habits")
    static let menuNut = Image("icon-nutrition")
    static let menuSup = Image("icon-supplement")
    static let menuTime = Image("icon-time")
    static let menuWorkout = Image("icon-workout")
    
    //Habits
    static let habitBrain = Image("habit cognitive")
    static let habitSpiritual = Image("habit spiritual")
    static let habitFood = Image("habit food")
    static let habitSleep = Image("habit sleep")
    static let habitSocial = Image("habit social")
    static let habitEnvironmental = Image("habit environmental")
    static let habitBreath = Image("habit breath")
    static let habitMeasure = Image("habit measure")
    
    //workout
    static let workout = Image("workout placeholder")
    static let demoWorkout = Image("demo workout video")
    
    
    //Arrows
    static let rightArrow = Image("right arrow")
    static let leftArrow = Image("left arrow")
    
    
    //modifiers
    func withColor(color: Color? = nil) -> some View {
        self
            .resizable()
            .renderingMode(.template)
            .foregroundColor(color)
    }
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}



enum TokenState {
    case successful
    case expired
    case missing
    case decodeError
}

extension KeychainSwift {
    
    func isLoggedIn() -> Bool {
        guard let token = self.get(loginToken) else { return false }
        return !token.isEmpty
    }
    
    func logout() {
        self.clear()
    }
    
    func userID() -> String? {
        return self.get(loginUserID)
    }
    
    func userEmail() -> String? {
        return self.get(loginEmail)
    }
    
    func token() -> String? {
        return self.get(loginToken)
    }
    
    func isValidToken() -> (isValid: Bool, state: TokenState) {
        guard let token = self.token() else { return (false, .missing) }
        do {
            let jwt = try decode(jwt: token)
            if let expiresAtDate = jwt.expiresAt, Date().isSmallerThan(expiresAtDate) {
                return (true, .successful)
            } else {
                return (true, .expired)
            }
        } catch {
            return (true, .decodeError)
        }
    }
}

extension TimeInterval {
    
    func minBreakdown() -> Int {
        let time = NSInteger(self)
        return (time / 60)
    }
    
    func timeBreakdown() -> ( hours: Int, minutes:Int, seconds: Int, ms: Int) {
        let time = NSInteger(self)
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        //        String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        return (hours: hours, minutes: minutes, seconds: seconds, ms: ms)
    }
}



struct Constants {
    static let WALKTHROUGH_KEY        = "walkthrough"
    static let ANCHOR_QUERY_NAME      = "QueryAnchor"
    static let RUNNING_TOTAL          = "RunningTotal"
    static let RUNNING_TOTAL_TIME     = "RunningTotalTime"
    static let MANUAL                 = "Manual"
    static let MODEL                  = UIDevice.current.localizedModel
    static let HEALTHKIT              = "healthkit_data"
    static let WORKOUT                = "zala_workout"
    static let TASKS                  = "task_value"
    static let USER_CREATE            = "user_create"
    
    static let DASHBOARD_PREFERENCE   = "preferences"
    static let USER_PROFILE_IMAGE     = "profile"
    static let manualInsightsCumulative = ["sum", "mean"]
    static let manualInsightsDiscrete   = ["min", "max"]
    static let overviewAttachments  = [USER_PROFILE_IMAGE, "drivers.license", "main"]
    
    static func yesNoPickerItems() -> [PickerItem] {
        return [
            PickerItem(title: "yes", key: "yes"),
            PickerItem(title: "no", key: "no")
        ]
    }
}

let TOTAL_PAGE_COUNT = 100




extension Int {
    func formattedAsCurrency(currencySymbol: String = "$", fractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol
        formatter.maximumFractionDigits = fractionDigits
        formatter.minimumFractionDigits = fractionDigits
        let value = Double(self) / 100.0
        return formatter.string(from: NSNumber(value: value))
    }
}


extension ClosedRange {
    static func dayView() -> ClosedRange<TimeInterval> {
        return Date().startOfDay.timeIntervalSince1970...Date.now.timeIntervalSince1970
    }
    
    static func last7Days() -> ClosedRange<TimeInterval> {
        return Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!.timeIntervalSince1970...Date.now.timeIntervalSince1970
    }
}
enum AddressType: String {
    case billing  = "billing"
    case main     = "main"
    case pharmacy = "pharmacy"
}

enum PhoneType: String {
    //    case sms = "billing
    //    case mobile = "mobile"
    case main = "main"
}


enum Compression:CGFloat {
    case none = 1.0
    case half = 0.5
}

extension UIImage {
    func base64(compressionQuality: Compression = .half) -> String? {
        guard let data = self.jpegData(compressionQuality: compressionQuality.rawValue) else { return nil }
        return "data:image/jpeg;base64,\(data.base64EncodedString())"
    }
}

extension Dictionary where Key == String, Value: Any {
    func jsonString() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}

extension CLLocation {
    static func from(address: String, completion: @escaping (_ location: CLLocation?, _ error: Error?) -> ()) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location, nil)
            } else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No location found"]))
            }
        }
    }
    
    static func calculateDistance(from address1: String, to address2: String, completion: @escaping (CLLocationDistance?, Error?) -> ()) {
        CLLocation.from(address: address1) { (location1, error) in
            guard let location1 = location1, error == nil else {
                completion(nil, error)
                return
            }
            
            CLLocation.from(address: address2) { (location2, error) in
                guard let location2 = location2, error == nil else {
                    completion(nil, error)
                    return
                }
                
                let distance = location1.distance(from: location2)
                completion(distance, nil)
            }
        }
    }
}

struct AttributedText: UIViewRepresentable {
    private let attributedString: NSAttributedString

    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    func makeUIView(context: Context) -> UITextView {
        // Called the first time SwiftUI renders this "View".

        let uiTextView = UITextView()

        // Make it transparent so that background Views can shine through.
        uiTextView.backgroundColor = .clear

        // For text visualisation only, no editing.
        uiTextView.isEditable = false

        // Make UITextView flex to available width, but require height to fit its content.
        // Also disable scrolling so the UITextView will set its `intrinsicContentSize` to match its text content.
        uiTextView.isScrollEnabled = false
        uiTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiTextView.setContentCompressionResistancePriority(.required, for: .vertical)
        uiTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return uiTextView
    }

    func updateUIView(_ uiTextView: UITextView, context: Context) {
        // Called the first time SwiftUI renders this UIViewRepresentable,
        // and whenever SwiftUI is notified about changes to its state. E.g via a @State variable.
        uiTextView.attributedText = attributedString
    }
}


extension NSAttributedString {
    static func html(withBody body: String) -> NSAttributedString {
        // Match the HTML `lang` attribute to current localisation used by the app (aka Bundle.main).
        let bundle = Bundle.main
        let lang = bundle.preferredLocalizations.first
            ?? bundle.developmentLocalization
            ?? "en"

        return (try? NSAttributedString(
            data: """
            <!doctype html>
            <html lang="\(lang)">
            <head>
                <meta charset="utf-8">
                <style type="text/css">
                    /*
                      Custom CSS styling of HTML formatted text.
                      Note, only a limited number of CSS features are supported by NSAttributedString/UITextView.
                    */

                    body {
                        font: -apple-system-body;
                        color: \(UIColor.secondaryLabel.hex);
                    }

                    h1, h2, h3, h4, h5, h6 {
                        color: \(UIColor.label.hex);
                    }

                    a {
                        color: \(UIColor.systemGreen.hex);
                    }

                    li:last-child {
                        margin-bottom: 1em;
                    }
                </style>
            </head>
            <body>
                \(body)
            </body>
            </html>
            """.data(using: .utf8)!,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: NSUTF8StringEncoding,
            ],
            documentAttributes: nil
        )) ?? NSAttributedString(string: body)
    }
}

// MARK: Converting UIColors into CSS friendly color hex string

private extension UIColor {
    var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return String(
            format: "#%02lX%02lX%02lX%02lX",
            lroundf(Float(red * 255)),
            lroundf(Float(green * 255)),
            lroundf(Float(blue * 255)),
            lroundf(Float(alpha * 255))
        )
    }
}


extension Dictionary where Key == String, Value == Any {
    func toJSONString(prettyPrinted: Bool = true) -> String? {
        do {
            let options: JSONSerialization.WritingOptions = prettyPrinted ? .prettyPrinted : []
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            return nil
        }
    }
}

extension Int {
    var asMin: Int {
        return self / 60
    }
    
    var seconds: Int {
        return self % 60
    }
    
    func restTimer() -> String {
        if self.asMin > 0 {
            return "\(self.asMin)min"
        } else {
            return "\(self.seconds)sec"
        }
    }
}


extension Double {
    var percentageString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2 // Set the number of decimal places you want
        formatter.minimumFractionDigits = 0  // Optional: Set minimum fraction digits
        
        // Convert the Double to a NSNumber and format it
        return formatter.string(from: NSNumber(value: self)) ?? "Invalid value"
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
