//
//  Date+Extension.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/23/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import Foundation

extension Date {
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func daysSince(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day!
    }
}
