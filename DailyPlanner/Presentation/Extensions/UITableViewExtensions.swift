//
//  UITableViewExtensions.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/23/19.
//  Copyright © 2019 Alexandr Vdovicenco. All rights reserved.
//

import UIKit

extension UITableView {
    public func register<T: UITableViewCell & NibLoadable>(_ type: T.Type) {
        register(type.nib, forCellReuseIdentifier: type.identifier)
    }

    public func register<T: UITableViewCell & Identifiable>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: type.identifier)
    }

    public func registerHeaderFooterView<T: UITableViewHeaderFooterView & NibLoadable>(_ type: T.Type) {
        register(type.nib, forHeaderFooterViewReuseIdentifier: type.identifier)
    }

    public func registerHeaderFooterView<T: UITableViewHeaderFooterView & Identifiable>(_ type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: type.identifier)
    }
}

extension UITableView {
    public func dequeue<R: Identifiable & Populatable>(for indexPath: IndexPath) -> R {
        return dequeue(R.self, for: indexPath)
    }

    public func dequeue<R: Identifiable & Populatable>(_ type: R.Type, for indexPath: IndexPath) -> R {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! R
    }

    public func dequeueSupplementaryView<R: Identifiable>() -> R {
        return dequeueReusableHeaderFooterView(withIdentifier: R.identifier) as! R
    }
}
