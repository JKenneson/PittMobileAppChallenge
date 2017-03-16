//
//  TreeStatsViewController.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/15/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import UIKit

class TreeStatsViewController: UIViewController {

    @IBOutlet weak var treeStatsView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set the background to slightly transparent to still see the menu
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.treeStatsView.layer.cornerRadius = 4
        
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
