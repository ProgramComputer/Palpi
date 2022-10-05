//
//  ConnectivityProvider.swift
//  Palpi
//
//  Created by  on 10/4/22.
//

import WatchConnectivity

class ConnectivityProvider: NSObject, WCSessionDelegate {
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()

    }
#endif
    
    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
    }
    
    func connect() {
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }
       
        session.activate()
    }
    
    func send(message: [String:Any]) -> Void {
        session.sendMessage(message, replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // code
    }
    
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        // code
//    }
//    
//    func sessionDidDeactivate(_ session: WCSession) {
//        // code
//    }
}
