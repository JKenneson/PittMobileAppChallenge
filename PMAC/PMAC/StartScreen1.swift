//
//  StartScreen.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/17/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import Foundation
import UIKit


class StartScreen1: UIViewController {
    
    
    @IBOutlet weak var startScreenBackground: UIImageView!
    @IBOutlet weak var riseButton: UIButton!
    
    //Called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Draw the background image for the first stage only
        self.startScreenBackground.image = UIImage(named: "1st stage")!
        
        self.riseButton.layer.cornerRadius = 4  //Bevel that button
        self.riseButton.layer.borderWidth = 1
        self.riseButton.layer.borderColor = UIColor.black.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func riseButtonPushed(_ sender: Any) {
        //Set first load to false so we don't show this screen again
        Globals.systemFirstLoad = 0
    }
    
}
