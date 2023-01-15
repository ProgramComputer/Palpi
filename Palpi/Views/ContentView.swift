//
//  ContentView.swift
//  Palpi
//
//  Created by  on 8/22/22.
//

import SwiftUI
struct ContentView: View {
    @EnvironmentObject  var viewModel: AuthenticationViewModel
    @State var isSplashActive:Bool = true
   // @ObservedObject var modelData: ModelData
 
    var body: some View {
        let _ =    UserDefaults.standard.set(self.viewModel.state.rawValue, forKey: "login")
        VStack{
            if !self.isSplashActive{
                switch viewModel.state{
                case .signedIn:
                    FindView()
                case .signedOut: LoginView().onAppear{
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(TurnOnBackground.backgroundRefreshStatusDidChange),
                        name: UIApplication.backgroundRefreshStatusDidChangeNotification, object: nil)
                    
                    
                    
                }
                }
            }
            else{
                SwiftUIGIFPlayerView(gifName: "Palpi-Logo").ignoresSafeArea()
                
            }
        }      .onAppear {
            // 6.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // 7.
                withAnimation {
                    self.isSplashActive = false
                }
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
