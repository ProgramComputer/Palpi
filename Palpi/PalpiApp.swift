//
//  PalpiApp.swift
//  Palpi
//
//  Created by  on 8/22/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase

@main
struct PalpiApp: App {
    // This delegate manages the life cycle of the app.
    static let name: String = "Palpi"

    @UIApplicationDelegateAdaptor var delegate: ApplicationDelegate
    @StateObject var viewModel = AuthenticationViewModel()
    init() {
        setupAuthentication()
      }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
extension PalpiApp{
    private func setupAuthentication(){
        FirebaseApp.configure()
       // Database.database().isPersistenceEnabled = true //when ready

    }
    
}
