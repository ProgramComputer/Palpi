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
    
    enum SignInState{
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    init(){
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true

    }
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
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController){
                [unowned self] user, error in authenticateUser(for: user, with: error)
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
        guard let userID = Auth.auth().currentUser?.uid else { return }
        print(userID)
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
                ref.child("users/\(uid)/UUID").observeSingleEvent(of: .value, with: {[weak self] snapshot in
                    if snapshot.exists(){
                    }else{
                        do{
                            guard
                                  let self = self,
                                  var json = snapshot.value as? [String: Any]
                                else {
                                  return
                                }
                        let UUIDData = try JSONSerialization.data(withJSONObject: json)
                        let decoder = JSONDecoder()

                        // 6
                        let thought = try decoder.decode(UUIDModel.self, from: UUIDData)
                        
                       
                         

                            // 3
                            let newUUID = UUIDModel(uid:uid!,uuid: CBUUID().uuidString)

                            
                              let encoder = JSONEncoder()


                              // 4
                              let data = try encoder.encode(newUUID)

                              // 5
                               let jsonSend = try JSONSerialization.jsonObject(with: data)

                              // 6
                                ref.childByAutoId().setValue(jsonSend)
                            } catch {
                              print("an error occurred", error)
                            }
                                        }
                })
//                databasePath.getData(completion:  { error, snapshot in
//                  guard error == nil else {
//                    print(error!.localizedDescription)
//                    return;
//                  }
                  
                    
                    
             //   });
                
            }
        }
        
        
    }
}
