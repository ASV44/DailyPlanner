//
//  EventListing.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/18/19.
//  Copyright © 2019 Hackintosh. All rights reserved.
//

import Foundation


struct EventListing: Codable {
    var events: [Date: [Event]]
}
