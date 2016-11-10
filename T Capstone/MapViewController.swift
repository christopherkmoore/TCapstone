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
    
    
    @IBOutlet weak var switchForPin: UISwitch!
    @IBOutlet weak var switchTitle: UINavigationItem!
//    var editButtonTapped = true
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    var newPin: Pin?
    var pins = [Pin]() 
    var selectedPinToPass : Pin? = nil
    var originPin = [OriginPin]()
    var newOriginPin: OriginPin?
    
    var locationManager = CLLocationManager()

    //MARK Loading Pins
    
    func fetchAllPins() -> [Pin] {
        do {
            let fetchRequest: NSFetchRequest<Pin> = NSFetchRequest(entityName: "Pin")
            pins = try sharedContext.fetch(fetchRequest)
            return pins
        } catch {
            print("error fetching pins")
        }
        return [Pin]()
    }
    
    func fetchOriginPin() -> [OriginPin] {
        do {
            let fetchRequest: NSFetchRequest<OriginPin> = NSFetchRequest(entityName: "OriginPin")
            originPin = try sharedContext.fetch(fetchRequest)
            return originPin
        } catch {
            print("error fetching origin pin")
        }
        return [OriginPin]()
    }
    
    //Mark deletetion
    func deleteOriginPin() {
        
        if !(originPin.isEmpty) {
            DispatchQueue.main.async {
                self.mapView.removeAnnotation(self.originPin[0])
                self.originPin.removeFirst()
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }
    }
    
    func loadMapPins() {
        
//        DispatchQueue.main.async {
            deleteOriginPin()

            mapView.removeAnnotations(pins)
            
            if mapView.annotations.count == 0 {
                if pins.count > 0 {
                   mapView.addAnnotations(pins)
                }
            }
//        }
    }
    
    //Mark Loading Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        pins = fetchAllPins()
        
        if pins.count != 0 {
            loadMapPins()
        }
        deleteView.isHidden = false
        
        editButton.title = "Edit"
        
        self.locationManager.requestWhenInUseAuthorization()

        print("delete view center.x during ViewDidLoad: \(deleteView.center.x)")

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 0.7
        mapView.addGestureRecognizer(longPressRecognizer)
        

    }

    
    //MARK create pins with longPress
    
    @IBAction func changeTitle (_ sender: UISwitch) {
        if sender.isOn == true {
            switchTitle.title = "Flying From"
            deleteOriginPin()
            SkywaysClient.ParameterValues.originPlace = "anywhere/"
        } else {
            switchTitle.title = "Flying To"
        }
    }
    
    @IBAction func editPressed(_ sender: AnyObject) {
        
        if editButton.title == "Done" {
            UIView.animate(withDuration: 0.7, animations: {
                self.mapView.frame.origin.y += self.deleteView.frame.height
                //                self.mapView.frame.origin.y += self.deleteView.frame.height
                
            })
            // hide tab bar, remember to animate the drop later.
            //            self.tabBarController!.tabBar.isHidden = false
            print("center.x durinv Edit true Animation: \(deleteView.center.x)")
            editButton.title = "Edit"
            CoreDataStackManager.sharedInstance().saveContext()
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                self.mapView.frame.origin.y -= self.deleteView.frame.height
                //                self.mapView.frame.origin.y -= self.deleteView.frame.height
            })
            //            self.tabBarController!.tabBar.isHidden = true
            print("center.x during Done true Animation: \(deleteView.center.x)")
            editButton.title = "Done"
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        
        
        if gestureRecognizer.state != .began { return }
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinates = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        let newMapPoint = MKPointAnnotation()        
        newMapPoint.coordinate = CLLocationCoordinate2DMake(touchMapCoordinates.latitude, touchMapCoordinates.longitude)
        
        
        switch gestureRecognizer.state {
        case .began:
            
            if switchForPin.isOn == true {
                
                if originPin.count == 0 {
                    newOriginPin = OriginPin(latitude: touchMapCoordinates.latitude, longitude: touchMapCoordinates.longitude, context: self.sharedContext)
                    SkywaysClient.ParameterValues.originPlace = "\(touchMapCoordinates.latitude),\(touchMapCoordinates.longitude)-latlong/"
                    originPin.append(newOriginPin!)
                    mapView.addAnnotation(newOriginPin!)
                    CoreDataStackManager.sharedInstance().saveContext()
                    print("new pin created in nested if")
                }
                else {
                    
                    newOriginPin = OriginPin(latitude: touchMapCoordinates.latitude, longitude: touchMapCoordinates.longitude, context: self.sharedContext)
                    SkywaysClient.ParameterValues.originPlace = "\(touchMapCoordinates.latitude),\(touchMapCoordinates.longitude)-latlong/"
                    originPin.append(newOriginPin!)
                  
                    mapView.addAnnotation(newOriginPin!)
                    CoreDataStackManager.sharedInstance().saveContext()
                    print("new pin created in nested else")
                    
                    deleteOriginPin()
                }
            }
            if switchForPin.isOn == false {
                newPin = Pin(latitude: touchMapCoordinates.latitude, longitude: touchMapCoordinates.longitude, context: self.sharedContext)
                if originPin.count == 0 {
                    SkywaysClient.ParameterValues.originPlace = "\(touchMapCoordinates.latitude),\(touchMapCoordinates.longitude)-latlong/"
                    SkywaysClient.ParameterValues.destinationPlace = "anywhere/"

                } else {
                    SkywaysClient.ParameterValues.destinationPlace = "\(touchMapCoordinates.latitude),\(touchMapCoordinates.longitude)-latlong/"
                }
                pins.append(newPin!)
                mapView.addAnnotation(newPin!)
                grabPlaces(newPin!)
                grabQuotes(newPin!)
                CoreDataStackManager.sharedInstance().saveContext()
                print("new pin created in last if statement")
            }

            break
        default:
            return
        }
        
    }
}

//delegate functions for MapKit
extension MapViewController {

    //MARK MapView delegate functions
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is Pin) {
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "red") as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "red")
                pinView?.animatesDrop = true
                pinView?.pinTintColor = .red
                
                print("delegate method firing for red pin")
                return pinView
            } else {
                pinView?.annotation = annotation
                return pinView
            }
        }
        
        
        if (annotation is OriginPin) {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "blue") as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "blue")
                annotationView?.animatesDrop = true
                annotationView?.pinTintColor = .blue

            
                print("delegate method firing for blue pin")
                return annotationView
            } else {
                annotationView?.annotation = annotation
                return annotationView
            }
        }

        return nil
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
}
// delegates functions for CLLocationManager
extension MapViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }
    
    // when user clicks agree, use CLLocation manager to get a pin and append to map.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // if there are no pins, let's drop one and make it the first.
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if originPin.count == 0 {
                if let locationManager = self.locationManager.location {
                    
                    
                    newOriginPin = OriginPin(latitude: locationManager.coordinate.latitude, longitude: locationManager.coordinate.longitude, context: self.sharedContext)
                    originPin.append(newOriginPin!)
                    CoreDataStackManager.sharedInstance().saveContext()
                    
                    SkywaysClient.ParameterValues.originPlace = "\(locationManager.coordinate.latitude),\(locationManager.coordinate.longitude)-latlong/"
                    mapView.addAnnotation(newOriginPin!)
                }
            }
        
        }
        if CLLocationManager.authorizationStatus() == .denied {
            switchTitle.title = "Flying From"
            switchForPin.isOn = true
        } else {
            switchTitle.title = "Flying To"
            switchForPin.isOn = false
        }
        
    }
    
}



protocol APICall {
    
    var sharedContext: NSManagedObjectContext { get }
    
    func grabQuotes(_ pin: Pin)
    func grabPlaces(_ pin: Pin)
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
                            
                            places.pin = pin
                            
                            return places
                        }
                        CoreDataStackManager.sharedInstance().saveContext()
                        
                    }
                }
            } else {
                self.sharedContext.delete(pin)
                CoreDataStackManager.sharedInstance().saveContext()
                self.displayNetworkError(self as! UIViewController, error: error)
            }
            
            if places == nil {
                self.displayNoQuotesError(self as! UIViewController, error: error)
//                self.mapView.removeAnnotation(pin)
                self.sharedContext.delete(pin)
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }
    }
    
    
    
    func grabQuotes (_ pin: Pin ) {
        if pin.quotes?.count == 0 {
            
            SkywaysClient.sharedInstance().browseCacheQuotes(pin) {(success, quotes, places, error) in
                
                print("success = \(success)")
                print("quotes = \(quotes)")
                print("places = \(places)")
                print("error \(error)")
                    
                    
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
                    self.displayNetworkError(self as! UIViewController, error: error)
                }
                
                if quotes == nil {
                    self.displayNoQuotesError(self as! UIViewController, error: error)
//                    self.mapView.removeAnnotation(pin)
                    self.sharedContext.delete(pin)
                    CoreDataStackManager.sharedInstance().saveContext()
                }
                
            }
        }
    }
    
    func displayNetworkError (_ vc: UIViewController, error: String?) {
        if let error = error {
            let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {(paramAction: UIAlertAction!) in
                print(paramAction.title!)})
            
            alertController.addAction(action)
            vc.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func displayNoQuotesError (_ vc: UIViewController, error: String?) {
        let alertController = UIAlertController(title: "It's possible your aim is bad.", message: "Aim for an airport, not the ocean.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {(paramAction: UIAlertAction!) in
            print(paramAction.title!)})
        
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
}





