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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        if notification.request.identifier == "localNotification"{
            completionHandler( [.alert,.sound,.badge])
        }
    }
}
