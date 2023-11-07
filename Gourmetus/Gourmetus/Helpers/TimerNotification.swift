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

// AppDelegate.swift
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Here we actually handle the notification
        //print("Notification received with identifier \(notification.request.identifier)")
        // So we call the completionHandler telling that the notification should display a banner and play the notification sound - this will happen while the app is in foreground
        completionHandler([.banner, .sound])
    }
}
