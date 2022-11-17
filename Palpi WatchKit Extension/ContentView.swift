//
//  ContentView.swift
//  Palpi WatchKit Extension
//
//  Created by  on 8/22/22.
//

import SwiftUI
import WatchConnectivity
struct ContentView: View {
    @EnvironmentObject var data: ModelData
    private var notificationHandler = ExtensionDelegate.instance.notificationHandler
  

    var body: some View {
      //  Text("Hello, World!")
        //    .padding()
        
        VStack{
        
        Spacer()
            Polar(connections: $data.count)
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ContentView()
//    }
//}
