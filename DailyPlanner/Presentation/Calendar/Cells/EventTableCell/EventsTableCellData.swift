//
//  EventTableCellData.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/23/19.
//  Copyright © 2019 Hackintosh. All rights reserved.
//

struct EventsTableCellData {
    let event: Event
    let checkAction: (String, Int, Bool) -> ()
}
