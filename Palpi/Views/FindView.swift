//
//  FindView.swift
//  Palpi
//
//  Created by  on 9/1/22.
//

import SwiftUI
struct FindView: View {
    @State private var isShowingAccountView = false
    @EnvironmentObject private var data: ModelData

    var body: some View {
        let w = print(data.count)
//        let _ = {
//
//            while(true){
//                print(data.count)
//            }
//        }
              NavigationView {
                  Polar(connections: $data.count) //TODO: currently receiving potential matches
                .navigationBarTitle("Search").multilineTextAlignment(.center)
                .toolbar {
                
                NavigationLink(  destination: AccountView(), isActive: $isShowingAccountView){
                    Image(systemName: "person" ).resizable()
                }
                
                
            
                }
            }.navigationViewStyle(StackNavigationViewStyle())
        
}
}

//struct FindView_Previews: PreviewProvider {
//    static var previews: some View {
//        FindView().environmentObject(AuthenticationViewModel())
//    }
//}
