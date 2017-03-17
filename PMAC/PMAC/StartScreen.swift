//
//  StartScreen.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/17/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import Foundation
import UIKit


class StartScreen: UIViewController {
    
    
    @IBOutlet weak var startScreenBackground: UIImageView!
    
    //Called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Draw the background image based on the current stage
        self.startScreenBackground.image = getStageImage(stageNumber: Globals.treeStage)
        
        
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
