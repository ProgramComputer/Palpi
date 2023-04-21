//
//  HeartRateM.swift
//  Heart Control
//
//  Created by  on 11/2/22.
//  Copyright © 2022 Thomas Paul Mann. All rights reserved.
//

import Foundation
import HealthKit
import StatKit
import Firebase
import WatchConnectivity

//https://developer.apple.com/documentation/healthkit/hkhealthstore/1614175-enablebackgrounddelivery#discussion
class HKKit{
    var notificationHandler = ApplicationDelegate.instance.notificationHandler
    let modelData: ModelData = ApplicationDelegate.instance.modelData

    var heartRateQuery: HKObserverQuery?
    let healthStore = HKHealthStore();
    public func subscribeToHeartBeatChanges() {
        
        // Creating the sample for the heart rate
        guard let sampleType: HKSampleType =
                HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        /// Creating an observer, so updates are received whenever HealthKit’s
        // heart rate data changes.
        self.heartRateQuery = HKObserverQuery.init(
            sampleType: sampleType,
            predicate: nil) { [weak self] oQ, cH, error in
                guard error == nil else {
                    print(error!)
                    // self.log.warn(error!)
                    return
                }
                /// When the completion is called, an other query is executed
                /// to fetch the latest heart rate
                self?.fetchLatestHeartRateSample(type: .heartRate,completion: { sample in
                    guard let sample = sample else {
                        return
                    }
//                    self?.fetchLatestHeartRateSample(type: .heartRateVariabilitySDNN,completion: { sample in
//                        guard let sample = sample else {
//                            print("hello")
//                            return
//                        }
//                        let heartRateUnit = HKUnit(from: "ms")
//                        let sdnn = sample
//                            .quantity
//                            .doubleValue(for: heartRateUnit)
//                        print("sdnn")
//                        print(sdnn)
//
//                    })
                    /// The completion in called on a background thread, but we
                    /// need to update the UI on the main.
                    DispatchQueue.main.async {
                        
                        /// Converting the heart rate to bpm
                        let heartRateUnit = HKUnit(from: "count/min")
                        let heartRate = sample
                            .quantity
                            .doubleValue(for: heartRateUnit)
                        print(heartRate);
                        /// Updating the UI with the retrieved value
                       // self?.notificationHandler!.requestUserNotification()
                       // self?.heartRateLabel.text = ("\(Int(heartRate))")
                    }
                    cH();
                })
            }
    }
    
    public func fetchLatestHeartRateSample(type: HKQuantityTypeIdentifier,
        completion: @escaping (_ sample: HKQuantitySample?) -> Void) {
            /// Create sample type for the heart rate
            guard let sampleType = HKObjectType
                .quantityType(forIdentifier: type) else {
                completion(nil)
                return
            }
            
            /// Predicate for specifiying start and end dates for the query
            let predicate = HKQuery
                .predicateForSamples(
                    withStart: .now - 1000,// Date.distantPast, //TODO change the dates
                    end: .now,// Date(),
                    options: .strictEndDate)
            
            /// Set sorting by date.
            let sortDescriptor = NSSortDescriptor(
                key: HKSampleSortIdentifierStartDate,
                ascending: false)
            
            /// Create the query
            let query = HKSampleQuery(
                sampleType: sampleType,
                predicate: predicate,
                limit: Int(HKObjectQueryNoLimit),
                sortDescriptors: [sortDescriptor]) { (_, results, error) in //TODO Windowed cross-correlation with more than 1 result
                    
                    guard error == nil else {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    //TODO return z-score from average of sample or from resting
                    if( results != nil && !results!.isEmpty && type == .heartRate){
                        print(BluetoothConstants.characteristicUUID.uuidString)
                        let heartRateUnit = HKUnit(from: "count/min")
                        let doubleResults = self.quantityToDouble(quantities: results as! [HKQuantitySample], unit: heartRateUnit)
                        let dict = Dictionary(uniqueKeysWithValues: doubleResults.enumerated().map { ($0.offset.description, $0.element) })
                        let ref = Database.database().reference()
                        ref.child("data").child(BluetoothConstants.characteristicUUID.uuidString).setValue(dict){
                            (error:Error?, ref:DatabaseReference) in
                            if let error = error {
                              print("Data could not be saved: \(error).")
                            } else {
                              print("Data saved successfully!")
                            }
                          }
                        if(ApplicationDelegate.instance.bluetoothReceiver == nil){
                            print("out")
                            return
                        }
                        print(ApplicationDelegate.instance.bluetoothReceiver.bluetoothPoints)
                        for element in ApplicationDelegate.instance.bluetoothReceiver!.bluetoothPoints{
                            print("Inside")
                        
                            ref.child("data").child(element.actualUUID.uuidString).getData(completion: { error, snapshot in
                                            guard error == nil else {
                                                                                        print(error!.localizedDescription)
                                                                                             return;
                                                                                           }
                                if let dict = snapshot?.value as? [Double]/*[String:Double] */{
                                   // let peerArray = dict.sorted(by: { $0.key < $1.key }).map { $0.value }
                                    let peerArray = dict;
                                    print(dict)
                                   let correlation =  crossCorrelation(x: doubleResults, y: peerArray)
                                    print("Correlation pvalue \( correlation.pValue)")
                                    if( correlation.pValue > 0 /*< 0.05*/){ //TODO commented out for DEMO
                                        self.modelData.count += 1;
                                        UserDefaults.standard.setValue(self.modelData.count, forKey: "count")
                                       
                                        let watchConnect: [String: Int] = ["count":self.modelData.count]
                                        WCSession.default.transferUserInfo(watchConnect)
                                    }
                                }
                                
                            })

                        }
                        completion(results?[0] as? HKQuantitySample)
                    }
                       if(results != nil && !results!.isEmpty){
                            print("heartrate")
                           completion(results?[0] as? HKQuantitySample)

                        }
                    }
   
    

            
            self.healthStore.execute(query)
        }
    private func quantityToDouble(quantities:[HKQuantitySample],unit:HKUnit) -> [Double]{

        var doubleArr = [Double]()
        for quantity in quantities {
            doubleArr.append(  quantity.quantity.doubleValue(for: unit))
        }
        return doubleArr
    }
}
