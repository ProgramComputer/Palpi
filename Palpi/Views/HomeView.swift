//
//  HomeView.swift
//  Palpi
//
//  Created by  on 8/23/22.
//

import SwiftUI
import GoogleSignIn

struct HomeView: View{
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    private let user = GIDSignIn.sharedInstance.currentUser
    
    var body: some View{
        NavigationView{
            
            VStack{
                HStack{
                    
                    NetworkImage(url: user?.profile?.imageURL(withDimension: 200)).aspectRatio(contentMode:.fit).frame(width:100,height: 100, alignment: .center).cornerRadius(8)
                    
                    
                    VStack(alignment: .leading) {
                        Text(user?.profile?.name ?? "").font(.headline)
                        
                        Text(user?.profile?.email ?? "").font(.subheadline)
                    }
                    Spacer()
                }.padding().frame(maxWidth: .infinity).background(Color(.secondarySystemBackground)).cornerRadius(12).padding()
                
                Spacer()
                
                
                Button(action: viewModel.signOut){
                    Text("Sign out").foregroundColor(.white).padding().frame(maxWidth:.infinity).background(Color(.systemIndigo)).cornerRadius(12).padding()
                }
            }.navigationTitle("Palpi")
        }.navigationViewStyle(StackNavigationViewStyle())
        
        
    }
}


//view that shows images from the network
struct NetworkImage: View{
    let url: URL?
    
    var body: some View{
        if let url = url,
           let data = try? Data(contentsOf: url),
            let uiImage = UIImage(data: data){
            Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fit)
        }
        else{
            Image(systemName: "person.circle.fill").resizable().aspectRatio(contentMode: .fit)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

