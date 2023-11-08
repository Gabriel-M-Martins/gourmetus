//
//  TimerNotification.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 30/10/23.
//

import SwiftUI
import UserNotifications

struct NotificationService {
    static func setTimer(time:Int, title:String, subtitle:String, sound:UNNotificationSound = .default) -> UUID{
        let Content = UNMutableNotificationContent()
        let Notification:TimeInterval = TimeInterval(time)
        Content.title = title 
        Content.subtitle = subtitle
        Content.sound = sound
        
        let Trigger = UNTimeIntervalNotificationTrigger(timeInterval: Notification, repeats: false)
        
        let notificationId = UUID()
        
        let Request = UNNotificationRequest(identifier: notificationId.uuidString, content: Content, trigger: Trigger)
        
        UNUserNotificationCenter.current().add(Request)
        
        return notificationId
    }
    
    static func deleteTimer(id:UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
}

