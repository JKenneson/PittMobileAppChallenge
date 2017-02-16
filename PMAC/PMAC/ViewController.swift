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

    @IBOutlet weak var MapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.MapView.showsUserLocation = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Location Delegate Methods
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        var region = MKCoordinateRegion()
        
        
        //Implementing a smooth zoom in for fun with delays
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
            self.MapView.setRegion(region, animated: true)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
            region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
            self.MapView.setRegion(region, animated: true)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(9), execute: {
            region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8))
            self.MapView.setRegion(region, animated: true)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(12), execute: {
            region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4))
            self.MapView.setRegion(region, animated: true)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(15), execute: {
            region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            self.MapView.setRegion(region, animated: true)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(18), execute: {
            region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.MapView.setRegion(region, animated: true)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(21), execute: {
            region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.MapView.setRegion(region, animated: true)
        })
        
        
        
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription)
    }
    
    
    
    


}

