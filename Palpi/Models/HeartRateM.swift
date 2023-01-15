//
//  HeartRateM.swift
//  Heart Control
//
//  Created by  on 11/2/22.
//  Copyright © 2022 Thomas Paul Mann. All rights reserved.
//

import Foundation
import HealthKit

//https://developer.apple.com/documentation/healthkit/hkhealthstore/1614175-enablebackgrounddelivery#discussion
class HKKit{
    var notificationHandler = ApplicationDelegate.instance.notificationHandler

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
                    // print(error!)
                    //  self.log.warn(error!)
                    return
                }
                /// When the completion is called, an other query is executed
                /// to fetch the latest heart rate
                self?.fetchLatestHeartRateSample(completion: { sample in
                    guard let sample = sample else {
                        return
                    }
                    
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
                        self?.notificationHandler!.requestUserNotification(temperature: Measurement(value: Double(0.0), unit: UnitTemperature.celsius),elevated: true)
                       // self?.heartRateLabel.text = ("\(Int(heartRate))")
                    }
                    cH();
                })
            }
    }
    
    public func fetchLatestHeartRateSample(
        completion: @escaping (_ sample: HKQuantitySample?) -> Void) {
            /// Create sample type for the heart rate
            guard let sampleType = HKObjectType
                .quantityType(forIdentifier: .heartRate) else {
                completion(nil)
                return
            }
            
            /// Predicate for specifiying start and end dates for the query
            let predicate = HKQuery
                .predicateForSamples(
                    withStart: Date.distantPast,
                    end: Date(),
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
                sortDescriptors: [sortDescriptor]) { (_, results, error) in
                    
                    guard error == nil else {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    completion(results?[0] as? HKQuantitySample)
                }
            
            self.healthStore.execute(query)
        }
}