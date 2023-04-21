//
//  ConnectivityProvider.swift
//  Palpi
//
//  Created by  on 10/4/22.
//

import WatchConnectivity

class SessionDelegator: NSObject, WCSessionDelegate,ObservableObject {
 
    
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
      #if os(iOS)
        let watchConnect: [String: Int] = ["count":ApplicationDelegate.instance.modelData.count]
        WCSession.default.transferUserInfo(watchConnect)
        #endif
    }
    
    func send(message: [String:Any]) -> Void {
        session.sendMessage(message, replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }
    func transferUserInfo(_ userInfo: [String: Any]) {
        var commandStatus = CommandStatus(phrase: .transferring)

        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: commandStatus)
        }

        commandStatus.userInfoTranser = WCSession.default.transferUserInfo(userInfo)
        
        //todo
        
       
      //  postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        let key = "count"
        guard let count = userInfo[key] as? Int else {
            return
        }

        DispatchQueue.main.async{
#if os(watchOS)
          //  print("COUNT printed " + count)
          //  if(count > 0 && count >   ExtensionDelegate.instance.modelData.count  )
        //    {
                ExtensionDelegate.instance.modelData.count = count
                ExtensionDelegate.instance.notificationHandler!.requestUserNotification()
        //    }
            
          
#endif
#if os(iOS)
   ApplicationDelegate.instance.modelData.count = count
#endif


          
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
    private func handleSessionUnactivated(with commandStatus: CommandStatus) {
        var mutableStatus = commandStatus
        mutableStatus.phrase = .failed
        mutableStatus.errorMessage = "WCSession is not activated yet!"
       // postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
#if os(iOS)
func sessionDidBecomeInactive(_ session: WCSession) {
    print("\(#function): activationState = \(session.activationState.rawValue)")
}

func sessionDidDeactivate(_ session: WCSession) {
    // Activate the new session after having switched to a new watch.
    session.activate()
}

func sessionWatchStateDidChange(_ session: WCSession) {
    print("\(#function): activationState = \(session.activationState.rawValue)")
    if(session.activationState == .activated){
  let watchConnect: [String: Int] = ["count":ApplicationDelegate.instance.modelData.count]
  WCSession.default.transferUserInfo(watchConnect)
 
    }
}
#endif
}
//mark
struct CommandStatus {
    var phrase: Phrase

    var fileTransfer: WCSessionFileTransfer?
    var file: WCSessionFile?
    var userInfoTranser: WCSessionUserInfoTransfer?
    var errorMessage: String?
    init( phrase: Phrase) {
        self.phrase = phrase
    }
    

}
enum Phrase: String {
    case updated = "Updated"
    case sent = "Sent"
    case received = "Received"
    case replied = "Replied"
    case transferring = "Transferring"
    case canceled = "Canceled"
    case finished = "Finished"
    case failed = "Failed"
}
