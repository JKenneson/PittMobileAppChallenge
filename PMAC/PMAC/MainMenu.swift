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
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var expBar: UIProgressView!
    
    //MARK: Global variables
    
    
    
    //Called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Bevel the buttons
        self.newRunButton.layer.cornerRadius = 4
        self.treeStatsButton.layer.cornerRadius = 4
    
        //Draw the background image based on the current stage
        self.mainMenuImageView.image = getStageImage(stageNumber: Globals.treeStage)
        
        //Update the Exp bar and label
        updateEXPBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    /// Called when the Tree Stats button is pushed
    /// - Parameter sender: The tree stats button
    @IBAction func treeStatsButtonPushed(_ sender: UIButton) {

        
        
//Testing by adding to the CO2 every time button is clicked
        Globals.incrementUserCO2(amountOfCO2ToAdd: 1)
        
        self.mainMenuImageView.image = getStageImage(stageNumber: Globals.treeStage)        //Update the main screen
        updateEXPBar()                                                                      //Update the Exp bar and label
    }
    
    
    
    
    /// Updating the EXP bar and label for our amount of CO2
    func updateEXPBar() {
        //Create the label by concatenating the current amount of CO2 and the stages' max CO2
        let expLabelString:String = "\(Globals.treeCO2Saved) / \(Globals.CO2ForStage(currentStage: Globals.treeStage))"
        //The value of the bar is division of the difference of each item from the stage before it
        //i.e. We're in stage 2 (trying to get to 15.0) Since stage 1 was 7 we do (currentCO2 - Stage1) / (Stage2 - Stage1) to get a nice percentage
        let numeratorValue:Float = Float(Globals.treeCO2Saved - Globals.CO2ForStage(currentStage: Globals.treeStage - 1))
        let denominatorValue:Float = Float(Globals.CO2ForStage(currentStage: Globals.treeStage) - Globals.CO2ForStage(currentStage: Globals.treeStage - 1))
        
        let expBarValue:Float = numeratorValue / denominatorValue
        
        self.expLabel.text = expLabelString
        self.expBar.setProgress(expBarValue, animated: false)
        
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
