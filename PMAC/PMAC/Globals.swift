//
//  Globals.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/6/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import Foundation


//MARK: System-wide variables and mutators
class Globals {
    
    static var totalUserCO2Saved: Double = 0.0                  //The total amount of CO2 saved by the user
    static var totalUserTreesSaved: Int = 0                     //The total number of completed trees
    
    static var treeCO2Saved: Double = 0.0                       //The tree specific amount of CO2 saved
    static var treeStage: Int = 1                               //The stage we are currently on for our tree
    
    static var lastTimeAppOpened:NSDate = NSDate()              //Saving when the app was last opened for HealthKit
    static var systemFirstLoad:Bool = true                      //A check if its the first time we are running the app
    
    //The maximum amount of CO2 saved to finish each stage
    static let stage1:Double = 7.0
    static let stage2:Double = 15.0
    static let stage3:Double = 26.0
    static let stage4:Double = 38.0
    static let stage5:Double = 48.0
    
    
    
    /// Adds CO2 to our total and tree specific amounts and increments our stages appropriately
    ///
    /// - Parameter amountOfCO2ToAdd: The amount of CO2 to add to the user and tree specific
    static func incrementUserCO2(amountOfCO2ToAdd: Double) {
        Globals.totalUserCO2Saved += amountOfCO2ToAdd
        Globals.treeCO2Saved += amountOfCO2ToAdd
        
        let printString = String(format: "Tree CO2 Saved: %.2f, Total CO2 Saved: %.2f", Globals.treeCO2Saved, Globals.totalUserCO2Saved)
        print("\(printString)")
        
        if(Globals.treeCO2Saved < Globals.stage1) {         //0-7 is stage 1
            Globals.treeStage = 1
        }
        else if(Globals.treeCO2Saved < Globals.stage2) {   //7-15 is stage 2
            Globals.treeStage = 2
        }
        else if(Globals.treeCO2Saved < Globals.stage3) {   //15-26 is stage 3
            Globals.treeStage = 3
        }
        else if(Globals.treeCO2Saved < Globals.stage4) {   //26-38 is stage 4
            Globals.treeStage = 4
        }
        else if(Globals.treeCO2Saved < Globals.stage5){     //38-48 is stage 5
            Globals.treeStage = 5
        }                                                   //If we hit 48, we completed a tree! Start over and increment tree counter
        else {
            Globals.completedTree(remainingCO2: (Globals.treeCO2Saved - 48))
        }
    }
    
    
    
    
    /// Once we reach at least enough CO2, we increment our tree counter and call our other method to increment user CO2 for the remaining amount
    ///
    /// - Parameter remainingCO2: However much CO2 there still is to add
    static func completedTree(remainingCO2: Double) {
        
        Globals.totalUserTreesSaved += 1                                //Increment the trees saved

        //Maybe add in a popup or special something here...
        print("You completed a Tree! Your total tree count is: \(Globals.totalUserTreesSaved)")
        
        
        Globals.treeCO2Saved = 0                                        //Reset the tree specific CO2 saved
        Globals.totalUserCO2Saved -= remainingCO2                       //Subtract the remaining from the total, since it will be added back in with the next method call
        
        Globals.incrementUserCO2(amountOfCO2ToAdd: remainingCO2)        //Add in the rest of the CO2 saved
    }
    
    
    ///Returns the amount of CO2 needed for the stage passed in
    ///
    /// - Parameter currentStage: The stage that you are on
    /// - Returns: The CO2 needed to advance to the next stage
    static func CO2ForStage(currentStage: Int) -> Double {
        switch currentStage {
        case 1:
            return self.stage1
        case 2:
            return self.stage2
        case 3:
            return self.stage3
        case 4:
            return self.stage4
        case 5:
            return self.stage5
        default:
            return 0.0
        }
    }
    
}
