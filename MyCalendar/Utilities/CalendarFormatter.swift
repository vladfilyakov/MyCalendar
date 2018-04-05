//
//  CalendarFormatter.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 4/3/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import Foundation

class CalendarFormatter {
    private static let dateFormatterWithYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d, yyyy")
        return dateFormatter
    }()
    private static let dateFormatterWithoutYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return dateFormatter
    }()
    
    private static let monthFormatterWithYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return dateFormatter
    }()
    private static let monthFormatterWithoutYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        return dateFormatter
    }()
    
    private static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        return numberFormatter
    }()

    private static let shortMonthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM")
        return dateFormatter
    }()
    
    static func fullMonthString(from date: Date) -> String {
        let formatter = date.isInCurrentYear ? monthFormatterWithoutYear : monthFormatterWithYear
        return formatter.string(from: date)
    }
    
    static func fullString(from date: Date) -> String {
        let formatter = date.isInCurrentYear ? dateFormatterWithoutYear : dateFormatterWithYear
        var string = formatter.string(from: date)
        if let prefix = relativeDayName(from: date) {
            string = prefix + " • " + string
        }
        return string
    }
    
    static func shortMonthString(from date: Date) -> String {
        return shortMonthFormatter.string(from: date)
    }
    
    static func string(from number: Int) -> String {
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    private static func relativeDayName(from date: Date) -> String? {
        if Calendar.current.isDateInYesterday(date) {
            return NSLocalizedString("RelativeDayName.Yesterday", comment: "")
        }
        if Calendar.current.isDateInToday(date) {
            return NSLocalizedString("RelativeDayName.Today", comment: "")
        }
        if Calendar.current.isDateInTomorrow(date) {
            return NSLocalizedString("RelativeDayName.Tomorrow", comment: "")
        }
        return nil
    }
}
