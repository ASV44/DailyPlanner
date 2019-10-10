//
//  String.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/22/19.
//  Copyright © 2019 Alexandr Vdovicenco. All rights reserved.
//

import Foundation

extension String {
    public static let empty = ""
    public static let space = " "
    public static let slash = "/"
    public static let questionMark = "?"
    public static let colon = ":"
    public static let dash = "-"
    public static let newLine = "\n"

    public var localized: String {
        return NSLocalizedString(self, comment: .empty)
    }

    public var removingSpaces: String {
        return replacingOccurrences(of: String.space, with: String.empty)
    }

    public func separated(by separator: Character) -> [String] {
        return split(separator: separator).map(String.init)
    }

    public subscript(idx: Int) -> Character {
        return self[index(startIndex, offsetBy: idx)]
    }
}

extension String {
    public var withoutSlashes: String {
        let withoutDoubleSlashes = replacingOccurrences(of: "\\\\", with: "\\")
        let withoutWrongQuotes = withoutDoubleSlashes.replacingOccurrences(of: "\\\"", with: "\"")

        return withoutWrongQuotes.replacingOccurrences(of: "\\n", with: "\n")
    }

    public var nonLossyASCII: String? {
        return String(data: Data(utf8), encoding: .nonLossyASCII)
    }
}

extension Swift.Optional where Wrapped == String {
    public var isEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
