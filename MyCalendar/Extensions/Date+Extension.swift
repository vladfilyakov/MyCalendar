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
        return addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
    }
}