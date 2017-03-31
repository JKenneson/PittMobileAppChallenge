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
        // The type of data we are requesting (walking and running distance traveled)
        let type = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)
        
        
        //let date = NSDate() as Date
        //let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        //let startDate = cal.startOfDay(for: date)
 
        let endDate = NSDate() as Date
        let startDate = Globals.lastTimeAppOpened! as Date
        
        print("Start date: \(startDate) End Date: \(endDate)")
 
        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: endDate as Date, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type!, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
            var value: Double = 0
            
            if error != nil {
                print("Error in fetching distanceWalkingRunning")
            }
            else if let quantity = statistics?.sumQuantity() {
                value = quantity.doubleValue(for: HKUnit.mile())
            }
            DispatchQueue.main.async {
                completion(value, error as NSError?)
            }
        }
        
        storage.execute(query)
        
        /*
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
        */
        
    }
    
    
}
