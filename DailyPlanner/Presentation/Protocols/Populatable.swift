//
//  Populatable.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/23/19.
//  Copyright © 2019 Alexandr Vdovicenco. All rights reserved.
//

public protocol Populatable {
    func populate<T>(with data: T)
}
