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

    //MARK: Global constants
    let metersToMiles = 0.000621371             //Converting meters to a mile
    let locationManager = CLLocationManager()   //Tracks the user's location and returns a CLLocation object
    
    //MARK: IBOutlet Declarations
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var entireRouteButton: UIButton!
    @IBOutlet weak var currentPositionButton: UIButton!
    @IBOutlet weak var freeRoamButton: UIButton!
    @IBOutlet weak var distanceTraveledOutputLabel: UILabel!
    
    //MARK: Global variable declarations
    var locations: [CLLocation] = []            //To track all locations the user has gone on this run
    var polyline: MKPolyline?                   //The collection of locations represented as a polyline
    
    var totalDistance: Double = 0               //Tracking the total distance the user has gone
    
    var isFirstLoad = true                      //If this is the first time into the program
    var firstLoadAccuracyCount = 0              //Count to make sure our accuracy is good before tracking positions
    var isTrackingPosition = true               //Default to tracking the position only
    var isTrackingRoute = false                 //Show the entire route on the map
    
    //Called when the view loads, setup for the Location Manager and Map View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Position, Route, annd Free Roam Button Methods
    
    
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
    
    @IBAction func trackFreeRoamButton(_ sender: Any) {
        print("Free Roam")
        self.isTrackingRoute = false
        self.isTrackingPosition = false
    }
    
    
    
    //MARK: Map View Methods
    
    /// Creates a MKPolyline object of all the previous locations seen and tells the map to render this line
    func drawRoute() {
        var coordinates = self.locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })
        
        self.polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        self.mapView.add(polyline!, level: MKOverlayLevel.aboveRoads)
    }
    
    
    /// Takes the MKPolyline object and renders it to the screen
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay);
            pr.strokeColor = UIColor.red.withAlphaComponent(0.5);
            pr.lineWidth = 5;
            return pr;
        }
        
        return MKPolylineRenderer()
    }
    
    
    
    //MARK: Location Update Methods
    
    
    /// Called every time a location gets updated in the location manager, the locations are
    /// stored in a CLLocation array with the newest location tacked onto the end
    ///
    /// - Parameters:
    ///   - manager: The CLLocationManager that is handling the location
    ///   - locations: The location array of all locations seen by this manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations readLocations: [CLLocation]) {
        
        let location = readLocations.last
        
        print(location!.horizontalAccuracy)
        if(location!.horizontalAccuracy > 10.0) {   //Don't save any points that are not accurate enough
            return
        }
        
        if(self.isFirstLoad) {                      //Don't animate first zoom into location
            self.firstLoadAccuracyCount += 1
            
            if(self.firstLoadAccuracyCount > 5) {   //Wait until we've gotten a few points before tracking positions
                self.isFirstLoad = false
                self.locations.append(location!)    //Save the first position
                trackPosition(locationToZoom: location!, shouldAnimate: false)
            }
        }
        else if (self.isTrackingPosition) {    //Follow the user by setting the map region to their current position
            self.totalDistance += location!.distance(from: self.locations.last!)   //Find the distance from the last location to this new one
            self.locations.append(location!)
            trackPosition(locationToZoom: location!, shouldAnimate: true)
        }
        else if (self.isTrackingRoute) {       //Track the user's route; set the map region to the entire span of the route
            self.totalDistance += location!.distance(from: self.locations.last!)   //Find the distance from the last location to this new one
            self.locations.append(location!)
            trackRoute()
        }
        else {                          //Allow the user to move around the map
            self.totalDistance += location!.distance(from: self.locations.last!)   //Find the distance from the last location to this new one
            self.locations.append(location!)
        }
        
        if(self.locations.count >= 2) { //If we have at least 2 points, start drawing the route
            drawRoute()
            let printDistance = String(format: "%.2f Miles", self.totalDistance * self.metersToMiles)
            self.distanceTraveledOutputLabel.text = "\(printDistance)"
        }
        
        print("Total Distance \(totalDistance)")
        //Option to stop updating location below
        //self.locationManager.stopUpdatingLocation()
    }
    
    
    /// The map will track the user's position and keep them in the center of the map screen
    ///
    /// - Parameter locationToZoom: A CLLocation that will be the center of the map screen when we zoom in
    func trackPosition(locationToZoom: CLLocation, shouldAnimate: Bool)  {
        let center = CLLocationCoordinate2D(latitude: locationToZoom.coordinate.latitude, longitude: locationToZoom.coordinate.longitude)   //Find the center
        
        var region = MKCoordinateRegion()
        
        //Zoom into the location of the user with a radius of 1
        region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: shouldAnimate)  //Change whether or not to be animated
    }
    
    
    /// The map will track the user's entire route and keep it in the center of the map screen
    func trackRoute()  {
        if(self.polyline != nil) {  //If we currently have a polyline object
            let rectToDraw = self.polyline?.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rectToDraw!), animated: true)
        }
        
    }
    
    
    
    


}

