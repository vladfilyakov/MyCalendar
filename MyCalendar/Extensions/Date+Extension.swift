//
//  Date+Extension.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/23/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import Foundation

let secondsPerDay: TimeInterval = 24 * 60 * 60

extension Date {
    func addingDays(_ days: Int) -> Date {
//        return addingTimeInterval(TimeInterval(days) * secondsPerDay)
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func daysSince(_ date: Date) -> Double {
        return timeIntervalSince(date) / secondsPerDay
    }
}
