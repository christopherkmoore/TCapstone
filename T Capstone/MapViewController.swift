//
//  MapViewController.swift
//  T Capstone
//
//  Created by modelf on 10/4/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate, APICall {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    @IBOutlet weak var switchTitle: UINavigationItem!
//    var editButtonTapped = true
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    var newPin: Pin?
    var pins = [Pin]() 
    var selectedPinToPass : Pin? = nil
    
    var locationManager = CLLocationManager()

    //MARK Loading Pins
    
    func fetchAllPins() -> [Pin] {
        do {
            let fetchRequest: NSFetchRequest<Pin> = NSFetchRequest(entityName: "Pin")
            pins = try sharedContext.fetch(fetchRequest)
            for item in pins {
                SkywaysClient.ParameterValues.destinationPlace = "\(item.latitude),\(item.longitude)-latlong/"

            }
            return pins
        } catch {
            print("error fetching pins")
        }
        return [Pin]()
    }
    
    func loadMapPins() {
                
        mapView.removeAnnotations(pins)
        
        if mapView.annotations.count == 0 {
            if pins.count > 0 {
                mapView.addAnnotations(pins)
            }
        }
    }
    
    //Mark Loading Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pins = fetchAllPins()

        mapView.delegate = self
        editButton.title = "Edit"
        deleteView.center.x -= view.frame.width
        
        self.locationManager.requestWhenInUseAuthorization()
        

//        if deleteView.center.x > 0 {
//        }
        print("center.x durinv ViewDidLoad: \(deleteView.center.x)")
        for item in pins {
            print(item)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 0.7
        mapView.addGestureRecognizer(longPressRecognizer)
        
        if pins.count != 0 {
            loadMapPins()
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        // Make sure titles and view positions are set.
//        
//        editButton.title = "Edit"
//        if deleteView.center.x > 0 {
//            deleteView.center.x -= view.frame.width
//        }
//        print("center.x durinv viewDidAppear: \(deleteView.center.x)")
//
//    }

//    override func viewWillDisappear(_ animated: Bool) {
//        
//        /* this code seems redundant but without it, the view glitches when you switch back to the screen in viewDidAppear, so it's important to at least take the view off screen so it doesn't seem glitch */
//        
//        if editButton.title == "Done" {
//            deleteView.center.x -= view.frame.width
//            print("center.x durinv viewWillDissapear: \(deleteView.center.x)")
//
//        }
//    }
    
    //MARK create pins with longPress
    
    func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        
        
        if gestureRecognizer.state != .began { return }
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinates = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        let newMapPoint = MKPointAnnotation()
        newMapPoint.coordinate = CLLocationCoordinate2DMake(touchMapCoordinates.latitude, touchMapCoordinates.longitude)
        
        switch gestureRecognizer.state {
        case .began:
            
            newPin = Pin(latitude: touchMapCoordinates.latitude, longitude: touchMapCoordinates.longitude, context: self.sharedContext)
            SkywaysClient.ParameterValues.originPlace = "\(touchMapCoordinates.latitude),\(touchMapCoordinates.longitude)-latlong/"
            newPin!.coordinate = touchMapCoordinates

            grabPlaces(newPin!)
            grabQuotes(newPin!)
            
            pins.append(newPin!)
            mapView.addAnnotation(newPin!)
            
            CoreDataStackManager.sharedInstance().saveContext()
            break
        default:
            return
        }
        
    }
    
//    @IBAction func changeSwitch(_ sender: UISwitch) {
//        if !(sender.isOn) {
//            switchTitle.title! = "Flying To"
//            SkywaysClient.ParameterValues.originPlace = "anywhere/"
//            if let newPin = newPin {
//                SkywaysClient.ParameterValues.destinationPlace = "\(newPin.latitude),\(newPin.longitude)-latlong/"
//            }
//        } else {
//            switchTitle.title! = "Flying From"
//            SkywaysClient.ParameterValues.destinationPlace = "anywhere/"
//            if let newPin = newPin {
//                SkywaysClient.ParameterValues.originPlace = "\(newPin.latitude),\(newPin.longitude)-latlong/"
//            }
//
//        }
//    }

    //MARK Delete Pins
    
    @IBAction func editPressed(_ sender: AnyObject) {
        
        if editButton.title == "Edit" {
            UIView.animate(withDuration: 0.7, animations: {
                self.deleteView.center.x += self.view.frame.width
//                self.mapView.frame.origin.y += self.deleteView.frame.height
                
            })
            // hide tab bar, remember to animate the drop later.
//            self.tabBarController!.tabBar.isHidden = false
            print("center.x durinv Edit true Animation: \(deleteView.center.x)")
            editButton.title = "Done"
            CoreDataStackManager.sharedInstance().saveContext()
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                self.deleteView.center.x -= self.view.frame.width
//                self.mapView.frame.origin.y -= self.deleteView.frame.height
            })
//            self.tabBarController!.tabBar.isHidden = true
            print("center.x during Done true Animation: \(deleteView.center.x)")
            editButton.title = "Edit"
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    //MARK create MapView
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as?MKPinAnnotationView
        if (pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.animatesDrop = true
            
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        guard let selectedAnnotation = view.annotation else {return}

        func findSelectedPin() -> Pin? {
           
            for pin in pins {
                if pin.latitude == selectedAnnotation.coordinate.latitude && pin.longitude == selectedAnnotation.coordinate.longitude {
                    
                    selectedPinToPass = pin
                    return selectedPinToPass!
                }
            }
            return nil
        }

        
        if editButton.title == "Edit" {
            if let value = findSelectedPin() {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "PinSearchViewController") as! PinSearchViewController
                controller.pin = value
                present(controller, animated: true, completion: nil)
            }
        } else {
            if let value = findSelectedPin() {
                sharedContext.delete(value)
                CoreDataStackManager.sharedInstance().saveContext()
            }
            self.mapView.removeAnnotation(selectedAnnotation)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }
    
    // when user clicks agree, use CLLocation manager to get a pin and append to map.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // if there are no pins, let's drop one and make it the first.
        if pins.count == 0 {
            if let locationManager = self.locationManager.location {
                self.pins.append(Pin(latitude: locationManager.coordinate.latitude, longitude: locationManager.coordinate.longitude, context: self.sharedContext))
                CoreDataStackManager.sharedInstance().saveContext()
                SkywaysClient.ParameterValues.destinationPlace = "\(locationManager.coordinate.latitude),\(locationManager.coordinate.longitude)-latlong/"
                self.loadMapPins()
                
            }
        }
    }
    
}



protocol APICall {
    
    var sharedContext: NSManagedObjectContext { get }
    
    func grabQuotes(_ pin: Pin)
    func grabPlaces(_ pin: Pin)
    func displayError (_ vc: UIViewController, error: String?)
//    func deleteSamePin( _ pin: Pin)
}

extension APICall {
    
    //MARK loading places
    
    func grabPlaces(_ pin: Pin ) {
        
        SkywaysClient.sharedInstance().browseCacheQuotes(pin) {(success, quotes, places, error) in
            
            print(success)
            
            if (success) {
                if let data = places {
                    DispatchQueue.main.async {
                        
                        let mappedArray = data.map() {(item: [String:AnyObject]) -> Places in
                            
                            let places = Places(content: item, context: self.sharedContext)
                            
                            
                            return places
                        }
                        CoreDataStackManager.sharedInstance().saveContext()
                        
                    }
                }
            } else {
                self.sharedContext.delete(pin)
                CoreDataStackManager.sharedInstance().saveContext()
                self.displayError(self as! UIViewController, error: error)
            }
        }
    }
    
    
    
    func grabQuotes (_ pin: Pin ) {
        if pin.quotes?.count == 0 {
            
            SkywaysClient.sharedInstance().browseCacheQuotes(pin) {(success, quotes, places, error) in
                
                if (success) {
                    if let data = quotes {
                        DispatchQueue.main.async {
                            
                            let mappedArrayQuotes = data.map() {(item: [String:AnyObject]) -> Quotes in
                                
                                let quotes = Quotes(content: item, context: self.sharedContext)
                                
                                quotes.pin = pin
                                
                                return quotes
                            }
                            CoreDataStackManager.sharedInstance().saveContext()
                        }
                    }
                }
                else {
                    self.sharedContext.delete(pin)
                    CoreDataStackManager.sharedInstance().saveContext()
                    self.displayError(self as! UIViewController, error: error)
                }
            }
        }
    }
    
    func displayError (_ vc: UIViewController, error: String?) {
        if let error = error {
            let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {(paramAction: UIAlertAction!) in
                print(paramAction.title!)})
            
            alertController.addAction(action)
            vc.present(alertController, animated: true, completion: nil)
        }
        
    }
    
//    func deleteSamePin(_ pin: Pin) {
//        pin
//    }

    

}





