//
//  MainMenu.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/4/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {
    
    @IBOutlet weak var newRunButton: UIButton!
    @IBOutlet weak var treeStatsButton: UIButton!
    @IBOutlet weak var mainMenuImageView: UIImageView!
    
    //Called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Bevel the buttons
        self.newRunButton.layer.cornerRadius = 4
        self.treeStatsButton.layer.cornerRadius = 4
    
        //Testing the image view
        mainMenuImageView.image = UIImage(named: "1st stage")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
