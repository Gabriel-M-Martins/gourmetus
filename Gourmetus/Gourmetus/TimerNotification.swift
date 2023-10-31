//
//  TimerNotification.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 30/10/23.
//

import SwiftUI
import UserNotifications

struct Notification {
    static func setTimer(time:Int, title:String, subtitle:String, sound:UNNotificationSound = .default) {
        let Content = UNMutableNotificationContent()
        let Notification:TimeInterval = TimeInterval(time)
        Content.title = title 
        Content.subtitle = subtitle
        Content.sound = sound
        
        let Trigger = UNTimeIntervalNotificationTrigger(timeInterval: Notification, repeats: false)
        
        let Request = UNNotificationRequest(identifier: UUID().uuidString, content: Content, trigger: Trigger)
        
        UNUserNotificationCenter.current().add(Request)
    }
}
