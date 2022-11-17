//
//  ContentView.swift
//  Palpi
//
//  Created by  on 8/22/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject  var viewModel: AuthenticationViewModel
    
   // @ObservedObject var modelData: ModelData
 
    var body: some View {
        let _ =    UserDefaults.standard.set(self.viewModel.state.rawValue, forKey: "login")

        switch viewModel.state{
        case .signedIn: FindView()
        case .signedOut: LoginView().onAppear{
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(TurnOnBackground.backgroundRefreshStatusDidChange),
                name: UIApplication.backgroundRefreshStatusDidChangeNotification, object: nil)
            
            
            
        }
        }
    }
    
    
    
}

class TurnOnBackground{
    @objc static func backgroundRefreshStatusDidChange(notification: NSNotification) {
        //TODO show a POPUP
      print("New status: \(UIApplication.shared.backgroundRefreshStatus)")
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
