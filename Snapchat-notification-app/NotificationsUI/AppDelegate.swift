//
//  AppDelegate.swift
//  NotificationsUI
//
//  Copyright © 2020 Stephen Eades. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var i:Double = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Request local notification authorizations.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { accepted, error in
            if !accepted {
                print("Notification access denied.")
            } else {
                print("Notification access accepted")
            }
        }
        
        /// Render actions for notification.
        let action = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
        let category = UNNotificationCategory(identifier: "normal", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }
    
    /// Create a local notification at specific date.
    ///
    /// - Parameter date: Time to trigger notification.
    func scheduleNotification(at date: Date) {
        
        UNUserNotificationCenter.current().delegate = self
        var mutableDate: Date = date // Create a mutable instance of Date
        //mutableDate.addTimeInterval(5) // Ex: add 5 seconds to the alert time
        let alert = "Snapchat" // Set the alerts origin
        
        /// Create date component from date.
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: mutableDate)
        let newComponents = DateComponents.init(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        /// Create trigger and content.
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Story Update"
        content.body = "Your story has been viewed 1,028 times today!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = alert
        content.threadIdentifier = alert
        
        /// Make a notification request.
        let request = UNNotificationRequest(identifier: alert, content: content, trigger: trigger)
        
        /// Provide request to notification center.
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error: " + error.localizedDescription)
            }
        }
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "remindLater" {
            /// Set the snooze on the notifiaction to 60 seconds later
            let newDate = Date(timeInterval: 60, since: Date())
            scheduleNotification(at: newDate)
        }
    }
}
