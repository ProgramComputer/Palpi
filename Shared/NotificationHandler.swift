//
//  NotificationHandler.swift
//  Palpi WatchKit Extension
//
//  Created by  on 10/5/22.
//

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A class for scheduling local notifications in response to certain Bluetooth events.
*/

import Foundation
import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    @Published private(set) var notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
 
    func requestUserNotification() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
//              success, error in
//                  if !success {
//                      print("notification authorization is not granted")
//                      print(error)
//                  } else {
                      

                      let content = UNMutableNotificationContent()
                      content.title = "Heart Alert"
                      content.body = "You found a match❤️"
                      
                      content.sound = UNNotificationSound.default
                               
                      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                      let request = UNNotificationRequest(identifier: "matchnotification-01", content: content, trigger: trigger)

                      UNUserNotificationCenter.current().add(request)
//                  }
//        }
    }
    
    // Display the notification even if the app is front-most.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                                    completionHandler([.banner, .badge, .sound])
    }

}
