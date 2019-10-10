//
//  EventListing.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/18/19.
//  Copyright © 2019 Alexandr Vdovicenco. All rights reserved.
//

import Foundation


class EventListing: Codable  {
    var calendarEvents: [Date: [Event]]
    
    init() {
        self.calendarEvents = [Date: [Event]]()
    }
    
    func eventsList(for date: Date) -> [Event] {
        return calendarEvents[date] ?? []
    }
    
    func add(_ event: Event, for date: Date) {
        if calendarEvents[date] == nil { calendarEvents[date] = [] }
        calendarEvents[date]?.append(event)
    }
    
    func replace(old eventOld: Event, new eventNew: Event, for date: Date) {
        let newEvents = calendarEvents[date]?.filter { $0 == eventOld }
        guard var updatedEvents = newEvents else { return }
        calendarEvents[date] = updatedEvents.appending(eventNew)
    }
}

extension EventListing: Cacheable {
    var fileName: String { return "calendarEvents.json" }
}
