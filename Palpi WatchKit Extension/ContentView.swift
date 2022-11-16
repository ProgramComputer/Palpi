//
//  ContentView.swift
//  Palpi WatchKit Extension
//
//  Created by  on 8/22/22.
//

import SwiftUI
import WatchConnectivity
struct ContentView: View {
    @State var count: Int = 0
    private var notificationHandler = ExtensionDelegate.instance.notificationHandler

    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
      let key = "count"
      guard let count = userInfo[key] as? Int else {
        return
      }
      
      self.count = count
        notificationHandler!.requestUserNotification(temperature: Measurement(value: Double(99), unit: UnitTemperature.celsius))
    }
    var body: some View {
      //  Text("Hello, World!")
        //    .padding()
        VStack{
        Spacer()
            Polar(connections: $count)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
