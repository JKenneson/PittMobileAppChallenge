//
//  HealthKitHelper.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/18/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import Foundation
import HealthKit


class HealthKitHelper {
    
    let storage = HKHealthStore()
    
    init() {
        _ = checkAuthorization()
    }
    
    
    func checkAuthorization() -> Bool {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            var readTypes = Set<HKObjectType>()
            readTypes.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!)
            
            // Now we can request authorization for step count data
            storage.requestAuthorization(toShare: nil, read: readTypes) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else {
            isEnabled = false
        }
        
        return isEnabled
    
    }
    
    
    
    func recentDistance(completion: @escaping (Double, NSError?) -> () ) {
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        
        // Our search predicate which will fetch data from now until a day ago
        // (Note, 1.day comes from an extension
        // You'll want to change that to your own NSDate
        let predicate = HKQuery.predicateForSamples(withStart: NSDate() as Date - TimeInterval(CFCalendarUnit.hour.rawValue), end: NSDate() as Date, options: [])
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var distanceTraveled: Double = 0
            
            if (results?.count)! > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    distanceTraveled += result.quantity.doubleValue(for: HKUnit.count())
                }
            }
            
            completion(distanceTraveled, error as NSError?)
        }
        
        storage.execute(query)
    
    }
    
    
}
