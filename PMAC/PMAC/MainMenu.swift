//
//  MainMenu.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/4/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var newRunButton: UIButton!
    @IBOutlet weak var treeStatsButton: UIButton!
    @IBOutlet weak var mainMenuImageView: UIImageView!
    
    //MARK: Global variables
    
    
    
    //Called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Bevel the buttons
        self.newRunButton.layer.cornerRadius = 4
        self.treeStatsButton.layer.cornerRadius = 4
    
        //Draw the background image based on the current stage
        self.mainMenuImageView.image = getStageImage(stageNumber: getUserStageNumber())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    /// Called when the Tree Stats button is pushed
    /// - Parameter sender: The tree stats button
    @IBAction func treeStatsButtonPushed(_ sender: UIButton) {
        Globals.totalUserCO2Saved += 1
        Globals.CO2SavedForTree += 1
        
        self.mainMenuImageView.image = getStageImage(stageNumber: getUserStageNumber())
    }
    
    
    
    //MARK: ImageVIew Helper Methods
    
    
    /// The current stage determined by the amount of CO2 saved by the user for this tree
    ///
    /// - Returns: The current stage based on the leveling algorithm
    func getUserStageNumber() -> Int {
        
        print(Globals.CO2SavedForTree)
        
        if(Globals.CO2SavedForTree < 7.0) {         //0-7 is stage 1
            return 1
        }
        else if(Globals.CO2SavedForTree < 17.0) {   //7-17 is stage 2
            return 2
        }
        else if(Globals.CO2SavedForTree < 28.0) {   //17-28 is stage 3
            return 3
        }
        else if(Globals.CO2SavedForTree < 40.0) {   //28-40 is stage 4
            return 4
        }
        else {                                      //40-48 is stage 5
            return 5
        }
    }
    
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
