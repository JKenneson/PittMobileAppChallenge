//
//  MainMenu.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/4/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {
    
    let myHealthKit = HealthKitHelper()
    
    //MARK: IBOutlets
    @IBOutlet weak var newRunButton: UIButton!
    @IBOutlet weak var treeStatsButton: UIButton!
    @IBOutlet weak var mainMenuImageView: UIImageView!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var expBar: UIProgressView!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var testButton: UIButton!
    
    
    
    //Called when the view loads
    override func viewDidLoad() {
        //If we make it to the menu, the user has loaded the app at least once
        Globals.systemFirstLoad = false
        
        super.viewDidLoad()
    
        //Bevel the buttons
        self.newRunButton.layer.cornerRadius = 4
        self.treeStatsButton.layer.cornerRadius = 4
        self.testButton.layer.cornerRadius = 4
        self.infoButton.layer.cornerRadius = 0.5 * self.infoButton.bounds.width         //Circular info button
        self.infoButton.clipsToBounds = true
        
        //Border the buttons
        self.infoButton.layer.borderWidth = 1
        self.infoButton.layer.borderColor = UIColor.black.cgColor
        self.newRunButton.layer.borderWidth = 1
        self.newRunButton.layer.borderColor = UIColor.black.cgColor
        self.treeStatsButton.layer.borderWidth = 1
        self.treeStatsButton.layer.borderColor = UIColor.black.cgColor
        self.testButton.layer.borderWidth = 1
        self.testButton.layer.borderColor = UIColor.black.cgColor
    
        //Draw the background image based on the current stage
        self.mainMenuImageView.image = getStageImage(stageNumber: Globals.treeStage)
        
        //Update the Exp bar and label
        updateEXPBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
///*********************************************************************************************************///
    ///This is just a test function for incrementing the CO2... Get rid of it!!!
    @IBAction func testButtonPushed(_ sender: Any) {
        //Testing by adding to the CO2 every time button is clicked
        Globals.incrementUserCO2(amountOfCO2ToAdd: 1)
        
        self.mainMenuImageView.image = getStageImage(stageNumber: Globals.treeStage)        //Update the main screen
        updateEXPBar()                                                                      //Update the Exp bar and label
        
        //Also testing getting distance traveled from health kit
        if(myHealthKit.checkAuthorization() == true) {
            myHealthKit.recentDistance() { distanceTraveled, error in
                print("Distance traveled from health kit: \(distanceTraveled)")
            };
        }
        
    }
///*********************************************************************************************************///
    
    
    /// Called when the Tree Stats button is pushed
    /// - Parameter sender: The tree stats button
    @IBAction func treeStatsButtonPushed(_ sender: UIButton) {
        //Create a popup view for the tree stats
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "treeStatsPopUpID") as! TreeStatsViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        

    }
    
    /// Called when the info button is pushed
    /// - Paramter sender: the info button
    @IBAction func infoButtonPushed(_ sender: Any) {
        //Create a popup view for the info screen
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "infoScreenPopUpID") as! InformationViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)

        
    }
    
    
    
    /// Updating the EXP bar and label for our amount of CO2
    func updateEXPBar() {
        //Create the label by concatenating the current amount of CO2 and the stages' max CO2
        let expLabelString:String = String(format: "CO2 Saved: %.2f / %.1f", (Globals.treeCO2Saved), (Globals.CO2ForStage(currentStage: Globals.treeStage)))
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
