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
 
    func requestUserNotification(temperature: Measurement<UnitTemperature>, elevated: Bool = false) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
              success, error in
                  if !success {
                      print("notification authorization is not granted")
                  } else {
                      let temperatureString = (Int(temperature.value) == -1) ? "--" : "\(Int(temperature.value))"
                      let temperatureSymbol = temperature.unit.symbol

                      let content = UNMutableNotificationContent()
                      content.title = "Heart Alert"
                      if elevated{
                          content.body = "Your heartRate elevated"
                      }
                      else{
                          content.body = "You found a match"//"It is \(temperatureString)\(temperatureSymbol)"
                      }
                      content.sound = UNNotificationSound.default
                               
                      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                      let request = UNNotificationRequest(identifier: "temperaturealertnotification-01", content: content, trigger: trigger)

                      UNUserNotificationCenter.current().add(request)
                  }
        }
    }
    
    // Display the notification even if the app is front-most.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                                    completionHandler([.banner, .badge, .sound])
    }

}
