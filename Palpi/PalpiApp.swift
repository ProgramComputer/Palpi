//
//  PalpiApp.swift
//  Palpi
//
//  Created by  on 8/22/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase
 var viewModel = AuthenticationViewModel()

@main
struct PalpiApp: App {
    static let name: String = "Palpi"
    // This delegate manages the life cycle of the app.
    @UIApplicationDelegateAdaptor var delegate: ApplicationDelegate
    init() {
        setupAuthentication()
     //  viewModel.state = /*AuthenticationViewModel.SignInState(/*rawValue: UserDefaults.standard.integer(forKey: "login")*/ ) ??*/ .signedOut
      }
    var body: some Scene {
        WindowGroup {

            ContentView().environmentObject(viewModel).environmentObject(delegate.modelData)
        }
    }
}
extension PalpiApp{
    private func setupAuthentication(){
        FirebaseApp.configure()
        viewModel.signIn()

        Database.database().isPersistenceEnabled = true //when ready TODO

    }
    
}
