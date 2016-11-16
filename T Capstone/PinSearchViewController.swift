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


class PinSearchViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pin: Pin!
    
    var fetchedResultsQuotesController: NSFetchedResultsController<Quotes>!
    var fetchedResultsPlacesController: NSFetchedResultsController<Places>!
    var fetchedResultsCarriersController: NSFetchedResultsController<Carriers>!
    
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
        
        let fetchRequestCarriers: NSFetchRequest<Carriers> = Carriers.fetchRequest()
        fetchRequestCarriers.sortDescriptors = []
        
        fetchedResultsQuotesController = NSFetchedResultsController(fetchRequest: fetchRequestQuotes, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsPlacesController = NSFetchedResultsController(fetchRequest: fetchRequestPlaces, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsCarriersController = NSFetchedResultsController(fetchRequest: fetchRequestCarriers, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)

        
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
        
        do {
            try fetchedResultsCarriersController.performFetch()
        } catch let error as NSError {
            print("Carriers fetch failed with error: \(error.localizedDescription)")
        }

        fetchedResultsQuotesController.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    

}

extension PinSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK TableViews
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = fetchedResultsQuotesController.fetchedObjects?.count
        
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
            cell.setNeedsLayout()
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
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PinDisplayViewController") as! PinDisplayViewController
        controller.quotes = quote
        controller.pin = pin
        controller.places = fetchedResultsPlacesController.fetchedObjects
        controller.carriers = fetchedResultsCarriersController.fetchedObjects
        
        present(controller, animated: true, completion: nil)
        
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

