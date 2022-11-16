import SwiftUI

struct SettingsView: View {
    
    private let settings:[SettingItem] = [ SettingItem(name:"Open source licenses",description: "./LICENSE/LICENSE.txt")
                                           
    ]
    
    var body: some View {
        NavigationView {
            List(settings) { settingItem in
                NavigationLink(destination: DetailsView(settingItem: settingItem.name)) {
                    HStack {
                        Text(settingItem.name)
                            .font(.headline)
                    }.padding(7)
                }
                
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct DetailsView: View {
    
    let settingItem: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                if let fileURL = Bundle.main.url(forResource: "LICENSE", withExtension: "txt") {
                    let contents = (try? String(contentsOf: fileURL, encoding: .utf8)) ?? " "
                    
                    Text(contents)
                        .padding(.top)  .lineLimit(nil)
                }
            }
        .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
        .navigationBarTitle(Text(settingItem), displayMode: .inline) .edgesIgnoringSafeArea(.bottom)
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
struct SettingItem: Identifiable {
    let id = UUID()
    let name: String
                let description: String
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

