//
//  DateFormatter.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/14/19.
//  Copyright © 2019 Hackintosh. All rights reserved.
//

import Foundation

extension DateFormatter {
    enum DateFormats {
        case dateMonthYear
        case yearMonthDate
        case dateAndTime
        case time
        case year
        case monthName
        case dayName

        var formatter: String {
            switch self {
            case .dateMonthYear:
                return "dd-MM-yyyy"
            case .yearMonthDate:
                return "yyyy MM dd"
            case .dateAndTime:
                return "dd-MM-yyyy HH:mm"
            case .time:
                return "HH:mm"
            case .year:
                return "yyyy"
            case .monthName:
                return "MMMM"
            case .dayName:
                return "EEEE"
            }
        }
    }

    func format(pattern: DateFormats) -> DateFormatter {
        self.dateFormat = pattern.formatter
        return self
    }
    
    func string(_ dateFormat: DateFormats, from date: Date) -> String {
       return format(pattern: dateFormat).string(from: date)
    }
    
    func date(_ dateFormat: DateFormats, from string: String) -> Date {
        return format(pattern: dateFormat).date(from: string) ?? Date()
    }
}
