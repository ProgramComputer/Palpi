//
//  BluetoothConstants.swift
//  Palpi
//
//  Created by  on 10/5/22.
//

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Bluetooth identifiers to use throughout the project.
*/

import CoreBluetooth
//Bluetooth constants is for the running device
enum BluetoothConstants {
    
    /// An identifier for the sample service.
    static var serviceUUID = CBUUID(string: "AAAA")
    
    /// An identifier for the sample characteristic.
    static var characteristicUUID = CBUUID(string: "BBBB")

    /// The defaults key to use for persisting the most recently received data.
    static let receivedDataKey = "received-data"
    
    
   
}

