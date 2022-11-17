//
//  AuthenticationViewModel.swift
//  Palpi
//
//  Created by  on 8/23/22.
//

import Firebase
import FirebaseDatabase
import GoogleSignIn
import CoreBluetooth
//CITE - https://blog.codemagic.io/google-sign-in-firebase-authentication-using-swift/

class AuthenticationViewModel: ObservableObject{
    
    enum SignInState:Int{
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    
    func signIn(){
        if GIDSignIn.sharedInstance.hasPreviousSignIn(){
            GIDSignIn.sharedInstance.restorePreviousSignIn(){
                [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }else{
            guard let clientID = FirebaseApp.app()?.options.clientID else{return}
            let configuration = GIDConfiguration(clientID: clientID)
            
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return}
            
            guard let rootViewController = windowScene.windows.first?.rootViewController else {return}
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController)
            {
                [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
        
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        
        do{
            try Auth.auth().signOut()
            
            state = .signedOut
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?){
        
        if let error = error{
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else {return}
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential){[unowned self](_,error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                
                self.state = .signedIn
               
                
                
                
                
                
                
                
                    
                    
                    
                    let uid = Auth.auth().currentUser?.uid
                    //
                    //                 lazy var databasePath: DatabaseReference? = {
                    //                  // 1
                    //                  guard let uid = Auth.auth().currentUser?.uid else {
                    //                    return nil
                    //                  }
                    //
                    //                  // 2
                    //                  let ref = Database.database()
                    //                    .reference()
                    //                    .child("users/\(uid)/UUID")
                    //                  return ref
                    //
                    //                }()
                    var ref = Database.database().reference()
                    //                guard let databasePath = databasePath else {
                    //                  return
                    //                }
                ref.child("users").child(uid!).child("UUID").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                        do{
                      
                            if snapshot.exists(){
                                guard var json = snapshot.value as? [String: Any]
                                else {
                                    return
                                }
                                print(json)
                                json["id"] = snapshot.key
                                let UUIDData = try JSONSerialization.data(withJSONObject: json)
                            
                                let decoder = JSONDecoder()
                                
                                // 6
                                let oldUUID = try decoder.decode(UUIDModel.self, from: UUIDData)

                                
                                BluetoothConstants.characteristicUUID = CBUUID(string: oldUUID.uuid)
                                
                            }else{
                                
                            
                                // 3
                                let newUUID = UUIDModel(uid:uid!,uuid: CBUUID(string: UUID().uuidString).uuidString)
                                
                                
                                let encoder = JSONEncoder()
                                
                                
                                // 4
                                let data = try encoder.encode(newUUID)
                                
                                // 5
                                let jsonSend = try JSONSerialization.jsonObject(with: data)
                                
                                // 6
                                ref.child("users").child(uid!).child("UUID").setValue(jsonSend)
                                
                                
                                BluetoothConstants.characteristicUUID = CBUUID(string: newUUID.uuid)
                                
                                
                            }
                        }
                        catch{
                            print(error)
                        }
                    ref.removeAllObservers()

                        //                databasePath.getData(completion:  { error, snapshot in
                        //                  guard error == nil else {
                        //                    print(error!.localizedDescription)
                        //                    return;
                        //                  }
                        
                        
                        
                    }) { error in
                        print(error.localizedDescription)
                      };
                    
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
            
        }
        
        
        
        
        
        
        
        
        
        
 
    }
    
    
    
    
}
