//
//  MapViewController.swift
//  T Capstone
//
//  Created by modelf on 10/4/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
//    var editButtonTapped = true
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    var newPin: Pin?
    var pins = [Pin]()
    var selectedPinToPass : Pin? = nil
    
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
    
    func loadMapPins() {
                
        mapView.removeAnnotations(pins)
        
        if mapView.annotations.count == 0 {
            if pins.count > 0 {
                mapView.addAnnotations(pins)
            }
        }
    }
    
    //MARK loading places
    
    func grabPlaces(_ pin: Pin ) {

        SkywaysClient.sharedInstance().browseCacheQuotes(pin) {(success, quotes, places, error) in
                
            print(success)
                
            if (success) {
                if let data = places {
                    DispatchQueue.main.async { [unowned self] in
                        self.pins.append(pin)
                        self.mapView.addAnnotation(pin)
                        
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
                ErrorHandling.displayError(self, error: error)
                }
        }
    }
    

    
    func grabQuotes (_ pin: Pin ) {
        if pin.quotes?.count == 0 {
            
            SkywaysClient.sharedInstance().browseCacheQuotes(pin) {(success, quotes, places, error) in

                if (success) {
                    if let data = quotes {
                        DispatchQueue.main.async {[unowned self] in
                            
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
                    ErrorHandling.displayError(self, error: error)
                }
            }
        }
    }
    
    
    //Mark Loading Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteView.center.x -= view.frame.width
        pins = fetchAllPins()
        
        mapView.delegate = self
        deleteView.isHidden = false
        
        editButton.title = "Edit"
        print(deleteView.center.x)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 0.7
        mapView.addGestureRecognizer(longPressRecognizer)
        
        if mapView.annotations.count == 0 {
            loadMapPins()
        }
        
    }
    
    
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
            newPin!.coordinate = touchMapCoordinates

            grabPlaces(newPin!)
            grabQuotes(newPin!)
            CoreDataStackManager.sharedInstance().saveContext()
            break
        default:
            return
        }
        
    }
    
    //MARK Delete Pins
    
    @IBAction func editPressed(_ sender: AnyObject) {
        
        if editButton.title == "Edit" {
            UIView.animate(withDuration: 0.7, animations: {
                self.deleteView.center.x += self.view.frame.width
//                self.mapView.frame.origin.y += self.deleteView.frame.height
                
            })
            // hide tab bar, remember to animate the drop later.
//            self.tabBarController!.tabBar.isHidden = false
            editButton.title = "Done"
            CoreDataStackManager.sharedInstance().saveContext()
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                self.deleteView.center.x -= self.view.frame.width
//                self.mapView.frame.origin.y -= self.deleteView.frame.height
            })
//            self.tabBarController!.tabBar.isHidden = true
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
                self.navigationController?.pushViewController(controller, animated: true)
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
