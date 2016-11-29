//
//  AirbnbMapViewController.swift
//  T Capstone
//
//  Created by modelf on 10/13/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class AirbnbMapViewController: UIViewController, DisplayError {
    
    var quote: Quotes!
    var listings = [AirbnbListing]()
    var currentListing: AirbnbListing?
    var urls = [String]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        zoomToQuoteArea(quote)

    }
    
    //find a place to put the fetch. it will probably become more laden when i fill out the listing class
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if mapView.annotations.count == 0 {
            fetchListings{(listings) in
                self.createPinsFromListings(listings)
            }
        }

    }
    
    func zoomToQuoteArea(_ quote: Quotes) {
        // This code is problematic. causes a bug without an origin because the pin lat/lng isn't neccessarily == the quote lat/lng
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake((quote.pin?.latitude)!, (quote.pin?.longitude)!), span: MKCoordinateSpanMake(0.50, 0.50)), animated: true)
    
    }
    
    func fetchListings(completionHandler handler: @escaping (_ listing: [AirbnbListing]) -> Void) {
    
        AirbnbClient.sharedInstance().browseAirbnbListing(quote) {(success, data, error) in
            if success {
                DispatchQueue.global(qos: .background).async { () -> Void in
                    if let safeBnbListings = data {
                        let _ = safeBnbListings.map() {(item: [String: AnyObject]) -> [AirbnbListing] in
                            let bnbListings = AirbnbListing(content: item, context: self.sharedContext)
                            let pictures = item["listing"]?["picture_urls"] as! [String]
                            for picture in pictures {
                                let photoToAdd = AirbnbPhotos(content: picture, context: self.sharedContext)
                                bnbListings.addToPhotos(photoToAdd)
                            }
                            self.listings.append(bnbListings)
                            return self.listings
                        }
                        DispatchQueue.main.async( execute: { () -> Void in
                            handler(self.listings)
                        })
                    }
                    
                }
            }
            // success fails, create alert
            if !(success) {
                self.displayNetworkError(self, error: error)
            }
            if data == nil {
                self.displayDataNilError(self, error: "No available AirBnb listings for this area")
            }
        }
    }
    
    func createPinsFromListings(_ bnbListing: [AirbnbListing]) {
        for item in bnbListing {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(item.bnbLatitude, item.bnbLongitude)
            annotation.title = "💰: \(item.amount) 🐸 : \(item.person_capacity) 🛌 : \(item.beds) 🚽 : \(item.bathrooms) "
            mapView.addAnnotation(annotation)
        }
    }
    
    
}
// MARK: Delegate methods for MapView
extension AirbnbMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "bnbListing") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "bnbListing")
            annotationView?.animatesDrop = true
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            print("delegate creating new pin")
            return annotationView
        } else {
            annotationView?.annotation = annotation
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let selectedAnnotation = view.annotation else {return}

        
        func findSelectedListing() -> AirbnbListing? {
            
            for house in listings {
                if house.bnbLatitude == selectedAnnotation.coordinate.latitude && house.bnbLongitude == selectedAnnotation.coordinate.longitude {
                    
                    currentListing = house
                    return currentListing
                }
            }
            return nil
        }
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AirbnbPicturesViewController") as! AirbnbPicturesViewController
        controller.currentListing = findSelectedListing()
        present(controller, animated: true, completion: nil)
        
    }
}
