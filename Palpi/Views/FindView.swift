//
//  FindView.swift
//  Palpi
//
//  Created by  on 9/1/22.
//

import SwiftUI
struct FindView: View {
    @State private var isShowingAccountView = false

    var body: some View {
            NavigationView {
                Polar()
                    .navigationBarTitle("Search").multilineTextAlignment(.center)
                    .toolbar {
                      
                        NavigationLink(  destination: AccountView(), isActive: $isShowingAccountView){
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
