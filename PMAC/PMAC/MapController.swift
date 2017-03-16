//
//  MapController.swift
//  RISE
//
//  Created by Jonathan Kenneson on 2/15/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    //MARK: Global constants
    let metersToMiles = 0.000621371             //Converting meters to a mile
    let poundsCO2SavedPerMile = 0.906           //0.906 pounds of CO2 are emitted on average per mile of driving
    let locationManager = CLLocationManager()   //Tracks the user's location and returns a CLLocation object
    
    //MARK: IBOutlet Declarations
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var entireRouteButton: UIButton!
    @IBOutlet weak var currentPositionButton: UIButton!
    @IBOutlet weak var freeRoamButton: UIButton!
    @IBOutlet weak var endRunButton: UIButton!
    
    @IBOutlet weak var distanceTraveledOutputLabel: UILabel!
    @IBOutlet weak var co2SavedLabel: UILabel!
    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var determineLocationLabel: UILabel!
    @IBOutlet weak var determineLocationWheel: UIActivityIndicatorView!
    
    //MARK: Global variable declarations
    var locations: [CLLocation] = []            //To track all locations the user has gone on this run
    var polyline: MKPolyline?                   //The collection of locations represented as a polyline
    
    var startTime = TimeInterval()              //Used for the timer to track time
    var timer = Timer()                         //Timer that calls updateTime every second
    
    var totalCO2Saved: Double = 0               //Tracking the total amount of CO2 saved on the run
    
    var totalDistance: Double = 0               //Tracking the total distance the user has gone
    var totalSeconds: Double = 0                //Tracking the total amount of seconds the user has been moving
    
    var isFirstLoad = true                      //If this is the first time into the program
    var firstLoadAccuracyCount = 0              //Count to make sure our accuracy is good before tracking positions
    var isTrackingPosition = true               //Default to tracking the position only
    var isTrackingRoute = false                 //Show the entire route on the map
    
    //Called when the view loads, setup for the Location Manager and Map View and timer
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Bevel the buttons
        currentPositionButton.layer.cornerRadius = 4
        entireRouteButton.layer.cornerRadius = 4
        freeRoamButton.layer.cornerRadius = 4
        endRunButton.layer.cornerRadius = 4
        
        //Setup the location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        //Setup the map view
        self.mapView.delegate = self
        
        //Setup the Determine Location Wheel
        self.determineLocationWheel.startAnimating()
        self.determineLocationWheel.hidesWhenStopped = true
        
        //Setup the timer
        let aSelector : Selector = #selector(MapController.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        
        //To stop the timer:
        /*
         timer.invalidate()
         timer == nil
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Position, Route, Free Roam, and End Run Button Methods
    
    
    /// Will switch the map view to tracking the entire route in the map region
    /// - Parameter sender: The Entire Route UIButton
    @IBAction func trackEntireRouteButton(_ sender: UIButton) {
        //print("Entire Route")
        self.isTrackingRoute = true
        self.isTrackingPosition = false
    }
    
    
    /// Will switch the map view to tracking only the user in the map region
    /// - Parameter sender: The Current Position UIButton
    @IBAction func trackCurrentPositionButton(_ sender: UIButton) {
        //print("Tracking Position")
        self.isTrackingPosition = true
        self.isTrackingRoute = false
    }
    
    
    /// Free Roam Button pushed - Allows the user to move around the map manually
    /// - Parameter sender: The Free Roam UIButton
    @IBAction func trackFreeRoamButton(_ sender: Any) {
        //print("Free Roam")
        self.isTrackingRoute = false
        self.isTrackingPosition = false
    }
    
    
    /// End Run button will handle saving the route and sending the user to a new screen
    /// This should have a confirmation button - Maybe pause everything when displayed
    /// - Parameter sender: The End Run button
    @IBAction func endRunButtonPushed(_ sender: Any) {
        print("End Run button pushed")
        
        //Save the CO2 saved from the run
        Globals.incrementUserCO2(amountOfCO2ToAdd: self.totalCO2Saved)
    }
    
    
    //MARK: Map View Methods
    
    
    /// Prints new label information to the screen
    func updateLabels() {
        //Print out distance information
        var distanceInMiles = self.totalDistance * self.metersToMiles
        let printDistance = String(format: "%.2f mi", distanceInMiles)
        self.distanceTraveledOutputLabel.text = "\(printDistance)"
        
        //Print out CO2 savings
        self.totalCO2Saved = distanceInMiles * self.poundsCO2SavedPerMile
        let printCO2Saved = String(format: "%.2 f lbs", self.totalCO2Saved)
        self.co2SavedLabel.text = "\(printCO2Saved)"
        
        //Print out pace information
        if(distanceInMiles <= 0) {      //Prevent dividing by zero
            distanceInMiles = 0.01
        }
        var paceTime = 1.0 / (distanceInMiles / self.totalSeconds)
        //print("Pace Time: \(paceTime)")
        
        //Preventing an exception (UInt8 cannot hold anything larger than 256)
        if( paceTime >= 15360 ) {
            paceLabel.text = "Very Slow"
        }
        else {
            let minutes = UInt8(paceTime / 60.0)                     //calculate the minutes in elapsed time
            paceTime -= (TimeInterval(minutes) * 60)
            
            let seconds = UInt8(paceTime)                            //calculate the seconds in elapsed time
            
            //add the leading zero for minutes and seconds and store them as string constants
            let strMinutes = String(format: "%02d", minutes)
            let strSeconds = String(format: "%02d", seconds)
            
            //concatenate minuets, seconds and milliseconds as assign it to the UILabel
            paceLabel.text = "\(strMinutes):\(strSeconds) min/mi"
        }
    }
    
    
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
        
        //print(location!.horizontalAccuracy)
        if(location!.horizontalAccuracy > 30.0) {   //Don't save any points that are not accurate enough
            return
        }
        
        if(self.isFirstLoad) {                      //Don't animate first zoom into location
            self.firstLoadAccuracyCount += 1
            trackPosition(locationToZoom: location!, shouldAnimate: false)
            
            //Clear the Determining Location label and wheel, and show the user position
            self.determineLocationLabel.text = ""
            self.determineLocationWheel.stopAnimating()
            self.mapView.showsUserLocation = true
            
            if(self.firstLoadAccuracyCount > 3) {   //Wait until we've gotten a few points before tracking positions
                self.isFirstLoad = false
                self.locations.append(location!)                    //Save the first position
                startTime = NSDate.timeIntervalSinceReferenceDate   //Set the start time to here
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
        
        
        //If we have at least 2 points, start drawing the route and updating labels
        if(self.locations.count >= 2) {
            drawRoute()
            
            updateLabels()
            
        }
        
        //print("Total Distance \(totalDistance)")
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
    
    
    
    /// Updates the time label on the map screen
    func updateTime() {
        
        if(self.isFirstLoad == true) {      //Don't update the time until the location is determined
            return
        }
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        var elapsedTime: TimeInterval = currentTime - startTime     //Find the difference between current time and start time
        //print("Total time: \(elapsedTime)")
        self.totalSeconds = elapsedTime
        
        let minutes = UInt8(elapsedTime / 60.0)                     //calculate the minutes in elapsed time
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)                            //calculate the seconds in elapsed time
        elapsedTime -= TimeInterval(seconds)
        
        let fraction = UInt8(elapsedTime * 100)                     //find out the fraction of milliseconds to be displayed
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        displayTimeLabel.text = "\(strMinutes):\(strSeconds).\(strFraction)"
    }
    
    
    
    


}

