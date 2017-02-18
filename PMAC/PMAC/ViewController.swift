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
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var entireRouteButton: UIButton!
    @IBOutlet weak var currentPositionButton: UIButton!
    
    //MARK: Global variable declarations
    let locationManager = CLLocationManager()
    var firstLocation: CLLocation? //To track our initial location
    var isFirstLoad = true
    var isTrackingPosition = true     //Default to tracking the position only
    var isTrackingRoute = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        self.mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Position and Route Button Methods
    
    
    /// Will switch the map view to tracking the entire route in the map region
    ///
    /// - Parameter sender: The Entire Route UIButton
    @IBAction func trackEntireRouteButton(_ sender: UIButton) {
        print("Entire Route")
        self.isTrackingRoute = true
        self.isTrackingPosition = false
    }
    
    
    /// Will switch the map view to tracking only the user in the map region
    ///
    /// - Parameter sender: The Current Position UIButton
    @IBAction func trackCurrentPositionButton(_ sender: UIButton) {
        print("Tracking Position")
        self.isTrackingPosition = true
        self.isTrackingRoute = false
    }
    
    //MARK: Map View Methods
    
    
    
    
    //MARK: Location Delegate Methods
    
    
    /// Called every time a location gets updated in the location manager, the locations are
    /// stored in a CLLocation array with the newest location tacked onto the end
    ///
    /// - Parameters:
    ///   - manager: The CLLocationManager that is handling the location
    ///   - locations: The location array of all locations seen by this manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        if(self.isFirstLoad) {               //Save the initial location
            self.firstLoad(initialLocation: location!)
        }
        else if (self.isTrackingPosition) {    //Follow the user by setting the map region to their current position
            self.trackPosition(locationToZoom: location!)
        }
        else if (self.isTrackingRoute) {       //Track the user's route by setting the map region to the entire span of the route
        
        }
        else {                          //Allow the user to move around the map
            //For now, do nothing

        }
        
        //Option to stop updating location below
        //self.locationManager.stopUpdatingLocation()
    }
    
    
    
    /// The map will track the user's position and keep them in the center of the map screen
    ///
    /// - Parameter locationToZoom: A CLLocation that will be the center of the map screen when we zoom in
    func trackPosition(locationToZoom: CLLocation)  {
        let center = CLLocationCoordinate2D(latitude: locationToZoom.coordinate.latitude, longitude: locationToZoom.coordinate.longitude)   //Find the center
        
        var region = MKCoordinateRegion()
        
        //Zoom into the location of the user with a radius of 1
        region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)  //Change whether or not to be animated
    }
    
    /// The map will track the user's entire route and keep it in the center of the map screen
    ///
    func trackRoute()  {
        //Not yet implemented
        
    }
    
    
    /// Initially, the map will locate the user and save their starting point as firstLocation
    ///
    /// - Parameter locationToZoom: A CLLocation that will be the center of the map screen when we zoom in
    func firstLoad(initialLocation: CLLocation)  {
        
        self.firstLocation = initialLocation
        
        let center = CLLocationCoordinate2D(latitude: locationToZoom.coordinate.latitude, longitude: locationToZoom.coordinate.longitude)   //Find the center
        var region = MKCoordinateRegion()
        
        //Zoom into the location of the user with a radius of .01
        region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: false)  //Change whether or not to be animated
        
        self.isFirstLoad = false
    
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

