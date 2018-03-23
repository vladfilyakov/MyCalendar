//
//  Calendar+Extension.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/23/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import Foundation

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let date = startOfDay(for: date)
        let weekday = component(.weekday, from: date)
        return self.date(byAdding: .day, value: -((weekday - firstWeekday + 7) % 7), to: date)!
    }
}
