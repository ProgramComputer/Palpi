//
//  ApplicationDelegate.swift
//  Palpi
//
//  Created by  on 11/15/22.
//


import UIKit
import CoreBluetooth
import WatchConnectivity



class ApplicationDelegate: NSObject, UIApplicationDelegate, BluetoothSenderDelegate,BluetoothReceiverDelegate {
    private lazy var sessionDelegator: SessionDelegator = {
        return SessionDelegator()
    }()
   
    
    
    static private(set) var instance: ApplicationDelegate! = nil
    var bluetoothSender: BluetoothSender!
    var bluetoothReceiver: BluetoothReceiver!
    private(set) var notificationHandler: NotificationHandler!

    var peripheralValue: Measurement<UnitTemperature> {
        /// Calculates a mock temperature value based on the current time of day.
        /// This is to slowly change the temperature as time passes, and not necesarily a meaningful calculation.
            let secondsPerDay: Int = 24 * 60 * 60
            let secondsToday = Int(Date().timeIntervalSince1970) % secondsPerDay
            let percent = Double(secondsToday) / Double(secondsPerDay)
            return Measurement(value: (20 + (percent * 10)), unit: UnitTemperature.celsius)
        }

    let characteristic = CBMutableCharacteristic(
        type: BluetoothConstants.characteristicUUID,
        properties: [.read, .write, .notify],
        value: nil,
        permissions: [.readable, .writeable]
    )
   
    override init() {
        super.init()
        
        ApplicationDelegate.instance = self
        notificationHandler = NotificationHandler()

        /// Initialize the Bluetooth sender with a service and a characteristic.
        let service = CBMutableService(type: BluetoothConstants.serviceUUID, primary: true)
        service.characteristics = [characteristic]
        
        bluetoothSender = BluetoothSender(service: service)
        bluetoothSender.delegate = self
        
        
        bluetoothReceiver = BluetoothReceiver(
            service: BluetoothConstants.serviceUUID,
            characteristic: BluetoothConstants.characteristicUUID
        )
        
        bluetoothReceiver.delegate = self
        
        
        // Trigger WCSession activation at the early phase of app launching.
        //
        assert(WCSession.isSupported(), "This sample requires Watch Connectivity support!")
        WCSession.default.delegate = sessionDelegator
        WCSession.default.activate()

    }
    // MARK: BluetoothReceiverDelegate
    func didReceiveData(_ message: Data) -> Int {
//          guard let value = try? JSONDecoder().decode(Int.self, from: data) else {
//        logger.error("failed to decode float from data")
//        return -1
//    }
//
//    logger.info("received value from peripheral: \(value)")
//    UserDefaults.standard.setValue(value, forKey: BluetoothConstants.receivedDataKey)
//
//    ComplicationController.updateAllActiveComplications()
//
//    /// When you're handling a background refresh task and are done interacting with the peripheral,
//    /// disconnect from it as soon as possible if not in watchOS 9 or later.
//    /// watchOS 9 adds the capability to continue scanning and to maintain connections in the background.
//    if #unavailable(watchOS 9.0) {
//        if currentRefreshTask != nil, let peripheral = bluetoothReceiver.connectedPeripheral {
//            bluetoothReceiver.disconnect(from: peripheral, mustDisconnect: true)
//        }
//    }
//
//    return value
        return -1
    }


    func didCompleteDisconnection(from peripheral: CBPeripheral, mustDisconnect: Bool) {
//        if let refreshTask = currentRefreshTask {
//            completeRefreshTask(refreshTask)
//            currentRefreshTask = nil
//        } else {
//            if #available(watchOS 9, *) {
//                if !mustDisconnect && bluetoothReceiver.knownDisconnectedPeripheral != nil {
//                    bluetoothReceiver.connect(to: bluetoothReceiver.knownDisconnectedPeripheral!)
//                }
//
//                /// Clear the complication value to demonstrate disconnect/reconnect actions.
//                UserDefaults.standard.setValue(-1, forKey: BluetoothConstants.receivedDataKey)
//                ComplicationController.updateAllActiveComplications()
//
//            }
//        }
    }
    
    func didFailWithError(_ error: BluetoothReceiverError) {
//        /// If the `BluetoothReceiver` fails and you're handling a background refresh task, complete the task.
//        if let refreshTask = currentRefreshTask {
//            completeRefreshTask(refreshTask)
//            currentRefreshTask = nil
//        }
    }
    // MARK: BluetoothSenderDelegate
    
    /// Respond to a read request by sending a value for the characteristic.
    func getDataFor(requestCharacteristic: CBCharacteristic) -> Data? {
        if requestCharacteristic == characteristic {
            let data = Int(peripheralValue.value)
            return try? JSONEncoder().encode(data)
        } else {
            return nil
        }
    }
}

