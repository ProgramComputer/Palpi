//
//  PalpiApp.swift
//  Palpi WatchKit Extension
//
//  Created by  on 8/22/22.
//

import SwiftUI

@main
struct PalpiApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
