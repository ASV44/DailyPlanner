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
        case dateAndTime
        case time

        var formatter: String {
            switch self {
            case .dateAndTime:
                return "dd-MM-yyyy HH:mm"
            case .time:
                return "HH:mm"
            }
        }
    }

    func format(pattern: DateFormats) -> DateFormatter {
        self.dateFormat = pattern.formatter
        return self
    }
}
