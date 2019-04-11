//
//  File.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/11/19.
//  Copyright © 2019 Hackintosh. All rights reserved.
//

import UIKit

public protocol StoryboardInstantiable where Self: UIViewController {
    static var bundle: Bundle { get }
    static var storyboardName: String { get }
    static var identifier: String { get }
    static func instantiate() -> Self
}

public extension StoryboardInstantiable {
    static var bundle: Bundle {
        return Bundle(for: Self.self)
    }

    private static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: bundle)
    }

    static var identifier: String {
        return String(describing: self)
    }

    static func instantiate() -> Self {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Could not instantiate \(identifier) from storyboard file.")
        }

        return viewController
    }
}
