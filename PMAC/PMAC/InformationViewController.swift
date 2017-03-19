//
//  InformationViewController.swift
//  RISE
//
//  Created by Jonathan Kenneson on 3/18/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import Foundation
import UIKit

class InformationViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var infoScreenView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var EPAButton: UIButton!
    @IBOutlet weak var tempIncreaseButton: UIButton!
    @IBOutlet weak var forestFactsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the background to slightly transparent to still see the menu
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        //Bevels, so nice
        self.infoScreenView.layer.cornerRadius = 4
        self.closeButton.layer.cornerRadius = 4
        self.EPAButton.layer.cornerRadius = 4
        self.tempIncreaseButton.layer.cornerRadius = 4
        self.forestFactsButton.layer.cornerRadius = 4
        self.resetButton.layer.cornerRadius = 4
        
        //Borders
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.borderColor = UIColor.black.cgColor
        self.resetButton.layer.borderWidth = 1
        self.resetButton.layer.borderColor = UIColor.black.cgColor
        self.EPAButton.layer.borderWidth = 1
        self.EPAButton.layer.borderColor = UIColor.black.cgColor
        self.tempIncreaseButton.layer.borderWidth = 1
        self.tempIncreaseButton.layer.borderColor = UIColor.black.cgColor
        self.forestFactsButton.layer.borderWidth = 1
        self.forestFactsButton.layer.borderColor = UIColor.black.cgColor
        
        //Set the scale of the buttons
        self.EPAButton.titleLabel?.minimumScaleFactor = 0.5;
        self.EPAButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        
        self.showAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func resetButtonPushed(_ sender: Any) {
    }
    
    
    ///Close the tree stats popup view
    @IBAction func closePopUp(_ sender: UIButton) {
        self.removeAnimate()
        //self.view.removeFromSuperview()
    }
    
    //MARK: Safari Links
    
    @IBAction func EPAButtonPushed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.epa.gov/sites/production/files/2016-02/documents/420f14040a.pdf")!, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func tempButtonPushed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://phys.org/news/2016-01-temperature-co2-emissions.html")!, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func forestFactsButtonPushed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://www.americanforests.org/explore-forests/forest-facts/")!, options: [:], completionHandler: nil)
        
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
