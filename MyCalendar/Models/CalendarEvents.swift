//
//  CalendarEvents.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 4/5/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import Foundation

class CalendarEvent {
    init(subject: String, start: Date, duration: TimeInterval, location: String) {
        self.subject = subject
        self.start = start
        self.duration = duration
        self.location = location
    }
    
    var subject: String
    var start: Date
    var duration: TimeInterval
    var location: String
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
        
        let subjects = [
            "Outlook UX Team meeting to discuss the recent changes in UI",
            "Chat with the team about new hires",
            "1:1 with Satya",
            "Discussion panel about plans for weekend",
            "Product planning for FY2019"
        ]
        let locations = [
            "",
            "Building 32",
            "Lincoln Square",
            "City Center",
            "Some tree house",
            "Peet's Coffee"
        ]

        let today = Calendar.current.startOfDay(for: Date())
        for day in minDay...maxDay {
            let date = today.addingDays(day)
            var start = date.addingTimeInterval(eventStartHour * 60 * 60)
            
            var dayEvents = [CalendarEvent]()
            for _ in 0..<arc4random_uniform(UInt32(maxEventCountPerDay + 1)) {
                let subject = subjects[Int(arc4random_uniform(UInt32(subjects.count)))]
                let location = locations[Int(arc4random_uniform(UInt32(locations.count)))]

                start.addTimeInterval(TimeInterval(arc4random_uniform(maxEventSpacingUnits + 1) * eventSpacingUnitMinutes * 60))
                let duration = TimeInterval((1 + arc4random_uniform(maxEventDurationUnits)) * eventDurationUnitMinutes * 60)
                
                dayEvents.append(CalendarEvent(subject: subject, start: start, duration: duration, location: location))
                
                start.addTimeInterval(duration)
            }
            
            events[date] = dayEvents.isEmpty ? nil : dayEvents
        }
    }
}
