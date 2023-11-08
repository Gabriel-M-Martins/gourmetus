//
//  AppDelegate.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation
import UIKit

// AppDelegate.swift
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        Dependencies.register(CoreDataRepository<Recipe>("RecipeEntity"), for: (any Repository<Recipe>).self)
        Dependencies.register(CoreDataRepository<Ingredient>("IngredientEntity"), for: (any Repository<Ingredient>).self)
        Dependencies.register(CoreDataRepository<Cookbook>("CookbookEntity"), for: (any Repository<Cookbook>).self)
        Dependencies.register(CoreDataRepository<Step>("StepEntity"), for: (any Repository<Step>).self)
        Dependencies.register(CoreDataRepository<Tag>("TagEntity"), for: (any Repository<Tag>).self)
        
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
