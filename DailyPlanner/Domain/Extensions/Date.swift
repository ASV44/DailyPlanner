//
//  File.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/22/19.
//  Copyright © 2019 Alexandr Vdovicenco. All rights reserved.
//

import Foundation

extension Date {
    static func setTime(of date: Date, hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        var comp = calendar.dateComponents(in: TimeZone.current, from: date)
        comp.hour = hour
        comp.minute = minute

        return calendar.date(from: comp)!
    }

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
