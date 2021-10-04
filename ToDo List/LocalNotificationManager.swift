//
//  LocalNotificationManager.swift
//  ToDo List
//
//  Created by Richard Shum on 10/4/21.
//

import Foundation
import UserNotifications

struct LocalNotificationManager {
    static func authorizeLocalNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if granted {
                print("Notification authorization granted")
            } else {
                print("The user has denied notifications!")
                //TODO: Put an alert in here telling the user what to do
            }
        }
    }
    
    static func setCalendarNotification(title: String, subtitle: String, body:String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String{
        // Create Content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        // Create Trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Create Request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        // Register request with the Notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription) Yikes, adding notification request went wrong!")
            } else {
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
        }
        return notificationID
    }
    
}
