//
//  PalpiApp.swift
//  Palpi
//
//  Created by  on 8/22/22.
//

import SwiftUI
import Firebase
@main

struct PalpiApp: App {
    @StateObject var viewModel = AuthenticationViewModel()
    init() {
        setupAuthentication()
      }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
extension PalpiApp{
    private func setupAuthentication(){
        FirebaseApp.configure()
    }
    
}
