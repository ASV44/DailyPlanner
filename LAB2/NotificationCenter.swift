//
//  NotificationCenter.swift
//  LAB2
//
//  Created by Hackintosh on 12/9/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
//

import Foundation

import UserNotifications

@available(iOS 10.0, *)
class NotificationCenter: NSObject, UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == "localNotification"{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}
