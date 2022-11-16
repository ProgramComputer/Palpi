//
//  UUIDModel.swift
//  Palpi
//
//  Created by  on 10/4/22.
//
import CoreBluetooth
import Foundation
struct UUIDModel: Identifiable, Codable {
    var id: String?
    var uid: String
    var uuid: String
    
    enum CodingKeys: String, CodingKey {
         case uid = "uid"
         case uuid = "uuid"
       
     }
   
}
