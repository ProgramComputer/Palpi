//
//  FindView.swift
//  Palpi
//
//  Created by  on 9/1/22.
//

import SwiftUI
struct FindView: View {
   // @State private var isShowingAccountView = false
    @EnvironmentObject private var data: ModelData

    var body: some View {
//        let _ = {
//
//            while(true){
//                print(data.count)
//            }
//        }
            NavigationStack {
                Polar(connections: $data.count) 
                    .navigationBarTitle("Search").multilineTextAlignment(.center)
                    .toolbar {
                        
                        NavigationLink(  destination: AccountView()/*, isActive: $isShowingAccountView*/){
                            Image(systemName: "person" ).resizable()
                        }
                        
                        
                        
                    }
            }.navigationViewStyle(StackNavigationViewStyle())
        
        
}
}

struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView().environmentObject(AuthenticationViewModel())
    }
}
