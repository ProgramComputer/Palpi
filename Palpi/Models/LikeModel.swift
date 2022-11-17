//
//  LikeModel.swift
//  Palpi
//
//  Created by  on 10/4/22.
//

import SwiftUI

final class ViewModel: ObservableObject {
    
//    private(set) var sessionDelegator: SessionDelegator
//    var userID: String = ""
//
//    init(sessionDelegator: SessionDelegator) {
//        self.sessionDelegator = sessionDelegator
//    }
    
//    func sendMessage() -> Void {
//        let txt = userID
//        let message = ["message":txt]
//    //sessionnDelegator.send(message: message)
//    }
    
    
}
class ModelData : ObservableObject {
    @Published var count: Int =  UserDefaults.standard.integer( forKey: "count")
 // Gets an array of ItemDetail from the defaults

   
}
