//
//  AccountView.swift
//  Palpi
//
//  Created by  on 8/23/22.
//

import SwiftUI
import GoogleSignIn

struct AccountView: View{
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    private let user = GIDSignIn.sharedInstance.currentUser
    init() {

        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemIndigo]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemIndigo]
        }
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingSettingsView = false

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
            }.navigationTitle("Palpi").toolbar {
                
                NavigationLink(  destination: SettingsView(), isActive: $isShowingSettingsView){
                    Image(systemName: "gearshape" ).resizable()
                }
            
                
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle(Text("Profile"), displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
        // Hide the system back button
        .navigationBarBackButtonHidden(true)
        // Add your custom back button here
        .navigationBarItems(leading:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.backward")
                    
                }
        })
        
        
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


struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(AuthenticationViewModel())
    }
}

