//
//  Event.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/18/19.
//  Copyright © 2019 Hackintosh. All rights reserved.
//

import Foundation

struct Event: Codable {
    var date: Date
    var title: String
    var desctiption: String
    var isCompleted: Bool
}
