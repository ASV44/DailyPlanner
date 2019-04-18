//
//  Event.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/18/19.
//  Copyright © 2019 Hackintosh. All rights reserved.
//

import Foundation

struct Event: Codable, Equatable {
    var date: Date
    var title: String
    var description: String
    var isCompleted: Bool
    
    init(date: Date, title: String, description: String, isCompleted: Bool = false) {
        self.date = date
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
    }
}
