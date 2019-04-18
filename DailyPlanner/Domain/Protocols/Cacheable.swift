//
//  File.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 4/18/19.
//  Copyright © 2019 Hackintosh. All rights reserved.
//

import Foundation

protocol Cacheable where Self: Codable {
    var fileName: String { get }

    func restore(from data: Data) -> Self
}

extension Cacheable {
    func getFileUrl(_ name: String,
                    in directory: FileManager.SearchPathDirectory,
                    with domainMask: FileManager.SearchPathDomainMask) -> URL {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(directory, domainMask, true).first!
        let documentsDirectoryPath = URL(fileURLWithPath: documentsDirectoryPathString)
        let filePath = documentsDirectoryPath.appendingPathComponent(name)

        return filePath
    }

    func persist() {
        let filePath = getFileUrl(fileName, in: .documentDirectory, with: .userDomainMask)
        guard let cache = try? JSONEncoder().encode(self) else { return } //Encode to Json format
        try? cache.write(to: filePath)
    }

    func restoreData() -> Data? {
        let filePath = getFileUrl(fileName, in: .documentDirectory, with: .userDomainMask)
        return try? Data(contentsOf: filePath, options: .alwaysMapped)
    }

    func restore() -> Self {
        guard let data = restoreData() else { return self }
        return restore(from: data)
    }
}
