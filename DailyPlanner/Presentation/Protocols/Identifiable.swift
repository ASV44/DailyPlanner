//
//  Identifiable.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/23/19.
//  Copyright © 2019 Hackintosh. All rights reserved.
//

import Foundation

public protocol Identifiable {
    static var identifier: String { get }
}

public extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
