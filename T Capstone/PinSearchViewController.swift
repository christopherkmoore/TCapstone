//
//  PinSearchViewController.swift
//  T Capstone
//
//  Created by modelf on 10/4/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit
import AddressBookUI


class PinSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pin: Pin!
    
    var fetchedResultsQuotesController: NSFetchedResultsController<Quotes>!
    var fetchedResultsPlacesController: NSFetchedResultsController<Places>!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    @IBAction func dismissVC(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let fetchRequestQuotes: NSFetchRequest<Quotes> = Quotes.fetchRequest()
        fetchRequestQuotes.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
        fetchRequestQuotes.predicate = NSPredicate(format: "pin == %@", self.pin)
        
        let fetchRequestPlaces: NSFetchRequest<Places> = Places.fetchRequest()
        fetchRequestPlaces.predicate = NSPredicate(format: "pin == %@", self.pin)
        fetchRequestPlaces.sortDescriptors = []
        
        fetchedResultsQuotesController = NSFetchedResultsController(fetchRequest: fetchRequestQuotes, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsPlacesController = NSFetchedResultsController(fetchRequest: fetchRequestPlaces, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)

        
        do {
            try fetchedResultsQuotesController.performFetch()
        } catch let error as NSError {
            print("Unable to call fetchedResultsQuotesController, error = \(error.localizedDescription)")
        }
        
        do {
            try fetchedResultsPlacesController.performFetch()
        } catch let error as NSError {
            print("Unable to call fetchedResultsPlacesController, error = \(error.localizedDescription)")
        }

        fetchedResultsQuotesController.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = fetchedResultsQuotesController.fetchedObjects?.count
        
        if num == 0 {
            displayError(self, error: "error loading")
        }
        
        return num!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        


        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: CustomTableViewCell, indexPath: IndexPath) {
        let quote = fetchedResultsQuotesController.object(at: indexPath)
        let places = fetchedResultsPlacesController.fetchedObjects
        if let places = places {
            quote.outboundDestinationIDConvert(places)
        }
        
        let timeDate = DateFormatter()
        timeDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss +zzzz"
        timeDate.timeStyle = .long
        timeDate.dateStyle = .medium
        cell.flightDate.text = timeDate.string(from: quote.inboundDepartureDate! as Date)

        cell.destination.text = quote.outboundDestinationIDString
            
        cell.minPrice.text = "$\(quote.price)0"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let quote = fetchedResultsQuotesController.object(at: indexPath)
        
//        AirbnbClient.sharedInstance().browseAirbnbListing(quote, completionHandler: {(success, data, error) in
//            
//            if (success) {
//                print(data!)
//            }
//            
//        })
//    
    }
}



extension PinSearchViewController {
    
    func displayError (_ vc: UIViewController, error: String?) {
        let alertController = UIAlertController(title: "It's possible your aim is bad.", message: "If you didn't drop me in the ocean, reload the page.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {(paramAction: UIAlertAction!) in
            print(paramAction.title!)})
        
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
        
}
