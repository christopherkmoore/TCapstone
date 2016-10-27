//
//  LocationSearchViewController.swift
//  T Capstone
//
//  Created by modelf on 10/27/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationSearchViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var presentLocation: [CLLocationCoordinate2D]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationManager = manager.location?.coordinate {
            print(locationManager)
        }
    }
    

    
    
}
