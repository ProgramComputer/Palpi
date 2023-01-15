//
//  PalpiApp.swift
//  Palpi WatchKit Extension
//
//  Created by  on 8/22/22.
//

import SwiftUI

@main
struct PalpiApp: App {
    static let name: String = "Palpi"
    @WKExtensionDelegateAdaptor var delegate: ExtensionDelegate
    @StateObject private var workoutManager = WorkoutManager()
    init() {
        workoutManager.start();
      }

     var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView().environmentObject(delegate.modelData)//.environmentObject(delegate.bluetoothReceiver)
            }
        }

      //  WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
