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
import CoreData

class LocationSearchViewController: UIViewController, CLLocationManagerDelegate, APICall {
    
    var locationManager = CLLocationManager()
    var presentLocation: [CLLocationCoordinate2D]?
    
    var pin: Pin?
    var pins: [Pin]?
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func fetchAllPins() -> [Pin] {
        do {
            let fetchRequest: NSFetchRequest<Pin> = NSFetchRequest(entityName: "Pin")
            pins = try sharedContext.fetch(fetchRequest)
            return pins!
        } catch {
            print("error fetching pins")
        }
        return [Pin]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
            
        }
        
        addPin()
    }
    
    func addPin () {
        if let locationManager = locationManager.location?.coordinate {
            // bug where pin instantiated every time vc loads as initial
            
            pin = Pin(latitude: locationManager.latitude, longitude: locationManager.longitude, context: sharedContext)
            grabPlaces(pin!)
            grabQuotes(pin!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       

    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
//    
//    func segueAndDownload() {
//        var controller = 
//    }

    
    
}
