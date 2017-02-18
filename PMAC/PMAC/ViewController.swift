//
//  ViewController.swift
//  PMAC
//
//  Created by Jonathan Kenneson on 2/15/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    //MARK: IBOutlet Declarations
    @IBOutlet weak var MapView: MKMapView!
    
    //MARK: Global variable declarations
    let locationManager = CLLocationManager()
    var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        self.MapView.showsUserLocation = true
        
        isFirstLoad = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MARK: Location Delegate Methods
    
    
    
    /// Called every time a location gets updated in the location manager, the locations are
    /// stored in a CLLocation array with the newest location tacked onto the end
    ///
    /// - Parameters:
    ///   - manager: The CLLocationManager that is handling the location
    ///   - locations: The location array of all locations seen by this manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        if (isFirstLoad) {     //First time through the loop, zoom to the user's location
            initialZoomToPosition(locationToZoom: location!)
        }
        
        print (locations.count)
        
        //Option to stop updating location below
        //self.locationManager.stopUpdatingLocation()
    }
    
    
    
    /// Initially, the map will zoom into the location of the user, 
    /// this can be animated or non-animated by changing the animate parameter to true/false respectively
    ///
    /// - Parameter locationToZoom: A CLLocation that will be the center of the map screen when we zoom in
    func initialZoomToPosition(locationToZoom: CLLocation)  {
        let center = CLLocationCoordinate2D(latitude: locationToZoom.coordinate.latitude, longitude: locationToZoom.coordinate.longitude)   //Find the center
        
        var region = MKCoordinateRegion()
        
        //Zoom into the location of the user with a radius of 1
        region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.MapView.setRegion(region, animated: false)  //Change whether or not to be animated
        
        isFirstLoad = false
    }
    
    
    
    /// Handling the errors from the location manager
    ///
    /// - Parameters:
    ///   - manager: CLLocationManager that is handling the location
    ///   - error: The error received by this manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription)
    }
    
    
    
    


}

