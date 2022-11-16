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
  //  @WKExtensionDelegateAdaptor var delegate: ExtensionDelegate

     var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()//.environmentObject(delegate.bluetoothReceiver)
            }
        }

      //  WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
