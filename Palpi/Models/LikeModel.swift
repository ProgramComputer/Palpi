//
//  LikeModel.swift
//  Palpi
//
//  Created by  on 10/4/22.
//

import SwiftUI

final class ViewModel: ObservableObject {
    
    private(set) var connectivityProvider: ConnectivityProvider
    var userID: String = ""
    
    init(connectivityProvider: ConnectivityProvider) {
        self.connectivityProvider = connectivityProvider
    }
    
    func sendMessage() -> Void {
        let txt = userID
        let message = ["message":txt]
        connectivityProvider.send(message: message)
    }
}
