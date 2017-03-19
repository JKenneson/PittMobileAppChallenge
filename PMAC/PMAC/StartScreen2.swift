//
//  StartScreen2.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/19/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import Foundation
import UIKit


class StartScreen2: UIViewController {
    
    let myHealthKit = HealthKitHelper()         //Retrieve HealthKitData
    let poundsCO2SavedPerMile = 0.906           //0.906 pounds of CO2 are emitted on average per mile of driving
    
    @IBOutlet weak var startScreenBackground: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var riseButton: UIButton!
    
    //Called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var distanceTraveledWhileClosed:Double = 0
        
        //Get the data from HealthKit for distance traveled since last load
        if(myHealthKit.checkAuthorization() == true) {
            myHealthKit.recentDistance() { distanceTraveled, error in
                print("Distance traveled from health kit: \(distanceTraveled)")
                distanceTraveledWhileClosed = distanceTraveled
            };
        }
        
        //Increment the user CO2
        let CO2SavedWhileClosed = distanceTraveledWhileClosed * self.poundsCO2SavedPerMile
        Globals.incrementUserCO2(amountOfCO2ToAdd: CO2SavedWhileClosed)
        
        //Set the text appropriately
        self.textLabel.text = String(format: "Welcome back.\nSince you were last here, you've\nwalked %.2f miles,\nsaving %.2f lbs of CO2. ", distanceTraveledWhileClosed, CO2SavedWhileClosed)
        
        
        
        //Draw the background image based on the current stage
        self.startScreenBackground.image = getStageImage(stageNumber: Globals.treeStage)
        self.riseButton.layer.cornerRadius = 4  //Bevel that button
        self.riseButton.layer.borderWidth = 1
        self.riseButton.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: ImageVIew Helper Methods
    
    /// Returns the main menu stage from the pased in number
    ///
    /// - Parameter stageNumber: Which stage to return
    /// - Returns: The UIImage to draw on the main menu
    func getStageImage(stageNumber: Int) -> UIImage {
        switch stageNumber {
        case 1:
            return UIImage(named: "1st stage")!
        case 2:
            return UIImage(named: "2nd stage")!
        case 3:
            return UIImage(named: "3rd stage")!
        case 4:
            return UIImage(named: "4th stage")!
        case 5:
            return UIImage(named: "5th stage")!
        //Return the first stage in the default case
        default:
            return UIImage(named: "1st stage")!
        }
    }
    
    
}
