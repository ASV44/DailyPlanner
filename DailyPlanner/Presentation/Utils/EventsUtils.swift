//
//  EventsUtils.swift
//  LAB2
//
//  Created by Hackintosh on 2/11/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import SwiftyJSON

class EventsUtils {
    
    static private let EVENTS_FILE_NAME = "calendarEvents.json"
    
    static func cacheEvents(_ events: JSON) {
        let jsonFilePath = getFileUrl(EVENTS_FILE_NAME, in: .documentDirectory, with: .userDomainMask)
        
        do {
            let data = try events.rawData()
            try data.write(to: jsonFilePath, options: [])
        }
        catch {
            print(error)
        }
        
    }
    
    static func getCachedEvents() -> JSON {
        let jsonFilePath = getFileUrl(EVENTS_FILE_NAME, in: .documentDirectory, with: .userDomainMask)
        
        var events = JSON()
        
        if FileManager.default.fileExists(atPath: jsonFilePath.path) {
            do {
                let data = try Data(contentsOf: jsonFilePath, options: .alwaysMapped)
                events = JSON(data)
            } catch {
                print(error)
            }
        }
        
        return events
    }
    
    static func getFileUrl(_ name: String,
                            in directory: FileManager.SearchPathDirectory,
                            with domainMask: FileManager.SearchPathDomainMask) -> URL {
        
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(directory, domainMask, true).first!
        let documentsDirectoryPath = URL(fileURLWithPath: documentsDirectoryPathString)
        let filePath = documentsDirectoryPath.appendingPathComponent(name)
        
        return filePath
    }
}
