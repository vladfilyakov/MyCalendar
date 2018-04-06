//
//  CalendarEvents.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 4/5/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import Foundation

class CalendarEvent {
    init(subject: String, start: Date, duration: TimeInterval) {
        self.subject = subject
        self.start = start
        self.duration = duration
    }
    
    var subject: String
    var start: Date
    var duration: TimeInterval
}

class CalendarEvents {
    static let shared = CalendarEvents()
    
    private init() {
        generateMockData()
    }
    
    private(set) var events: [Date : [CalendarEvent]] = [:]
    
    private func generateMockData() {
        let minDay = -1000
        let maxDay = 1000
        let eventStartHour: TimeInterval = 9
        let maxEventCountPerDay = 5
        let eventSpacingUnitMinutes: UInt32 = 15
        let maxEventSpacingUnits: UInt32 = 4
        let eventDurationUnitMinutes: UInt32 = 15
        let maxEventDurationUnits: UInt32 = 8

        let today = Calendar.current.startOfDay(for: Date())
        for day in minDay...maxDay {
            let date = today.addingDays(day)
            var start = date.addingTimeInterval(eventStartHour * 60 * 60)
            var dayEvents = [CalendarEvent]()
            for _ in 0..<arc4random_uniform(UInt32(maxEventCountPerDay + 1)) {
                let subject = "Office UX Team meeting to discuss the recent changes in UI"    //!!!

                start.addTimeInterval(TimeInterval(arc4random_uniform(maxEventSpacingUnits + 1) * eventSpacingUnitMinutes * 60))
                let duration = TimeInterval((1 + arc4random_uniform(maxEventDurationUnits)) * eventDurationUnitMinutes * 60)
                
                dayEvents.append(CalendarEvent(subject: subject, start: start, duration: duration))
                
                start.addTimeInterval(duration)
            }
            events[date] = dayEvents.isEmpty ? nil : dayEvents
        }
    }
}
