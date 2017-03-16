//
//  TreeStatsViewController.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/15/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import UIKit

class TreeStatsViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var treeStatsView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var totalCO2SavedLabel: UILabel!
    @IBOutlet weak var totalTreesSavedLabel: UILabel!
    @IBOutlet weak var CO2ForTreeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set the background to slightly transparent to still see the menu
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        //Bevels, so nice
        self.treeStatsView.layer.cornerRadius = 4
        self.closeButton.layer.cornerRadius = 4
        
        //Setting the text for the labels according to the values in the Globals class
        self.totalCO2SavedLabel.text = String(format: "%.2f lbs", Globals.totalUserCO2Saved)
        self.totalTreesSavedLabel.text = "\(Globals.totalUserTreesSaved)"
        self.CO2ForTreeLabel.text = String(format: "%.2f lbs", Globals.treeCO2Saved)
        
        self.showAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    ///Close the tree stats popup view
    @IBAction func closePopUp(_ sender: Any) {
        self.removeAnimate()
        //self.view.removeFromSuperview()
    }

    
    
    //MARK: Animation Methods
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    
}
