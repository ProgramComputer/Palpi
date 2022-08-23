//
//  LoginView.swift
//  Palpi
//
//  Created by  on 8/23/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View{
        VStack{
            Spacer()
            
            Image("header_image").resizable().aspectRatio(contentMode:.fit)
            //TODO set the header_image
            Text("Welcome to Palpi").fontWeight(.black).foregroundColor((Color(.systemIndigo))).font(.largeTitle).multilineTextAlignment(.center)
            
            Text("Find your heart's flutter").fontWeight(.light).multilineTextAlignment(.center).padding()
            
            Spacer()
            
            
            GoogleSignInButton().padding().onTapGesture {
                viewModel.signIn()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}