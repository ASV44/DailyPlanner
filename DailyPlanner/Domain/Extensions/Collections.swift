//
//  Collections.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/19/19.
//  Copyright © 2019 Alexandr Vdovicenco. All rights reserved.
//

import Foundation

extension Array {
    // the mutating function should be named "filter" but
    // this is already taken by the non-mutating function
    mutating func filtering(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        try self = self.filter(isIncluded)
        return self
    }
    
    mutating func appending(_ element: Element) -> [Element] {
        self.append(element)
        return self
    }
}
