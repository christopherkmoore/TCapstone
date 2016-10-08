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


class PinSearchViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pin: Pin!
    
    var fetchedResultsQuotesController: NSFetchedResultsController<Quotes>!
    var fetchedResultsPlacesController: NSFetchedResultsController<Places>!
    
    
//    var insertedIndexPaths : [IndexPath]!
//    var deletedIndexPaths : [IndexPath]!
//    var updatedIndexPaths : [IndexPath]!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // GOING TO NEED TO SEE IF THIS IS THE BEST WAY. LET USE AS DEFAULT FETCH
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        activityIndicator.isHidden = false
//        activityIndicator.startAnimating()
//        convertPlaces()
//        activityIndicator.isHidden = true
//        activityIndicator.stopAnimating()
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequestQuotes: NSFetchRequest<Quotes> = Quotes.fetchRequest()
        fetchRequestQuotes.sortDescriptors = [NSSortDescriptor(key: "minPrice", ascending: true)]
        fetchRequestQuotes.predicate = NSPredicate(format: "pin == %@", self.pin)
        let fetchRequestPlaces: NSFetchRequest<Places> = Places.fetchRequest()
        fetchRequestPlaces.sortDescriptors = []
        fetchRequestPlaces.predicate = NSPredicate(format: "pin == %@", self.pin)
        
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

        convertPlaces()
        tableView.dataSource = self
        
    }

    
    func convertPlaces () {
        let quotes = fetchedResultsQuotesController.fetchedObjects
        let places = fetchedResultsPlacesController.fetchedObjects
        
        
        for item in places! {
            for quote in quotes! {
                if item.placeID == quote.destinationID {
                    if let cityName = item.cityName {
                        if let countryName = item.countryName {
                            quote.stringName = "\(cityName), \(countryName)"
                        }
                    }
                }
            }
        }
    }
    
    
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

        
        let timeDate = DateFormatter()
        timeDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss +zzzz"
        timeDate.timeStyle = .long
        timeDate.dateStyle = .medium
        cell.flightDate.text = timeDate.string(from: quote.departureDate! as Date)

        if let destinationName = quote.stringName {
            cell.destination.text = "\(destinationName)"
        }
        
        cell.minPrice.text = "$\(quote.minPrice)0"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //future updates
        
        let quote = fetchedResultsQuotesController.object(at: indexPath)
        
    }
    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .automatic)
//        case .update:
//            let cell = tableView.cellForRow(at: indexPath!) as! CustomTableViewCell
//            configureCell(cell: cell, indexPath: indexPath!)
//        case .move:
//            tableView.deleteRows(at: [indexPath!], with: .automatic)
//            tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        insertedIndexPaths = [IndexPath]()
//        deletedIndexPaths = [IndexPath]()
//        updatedIndexPaths = [IndexPath]()
//    }
//    
//    func controller ( _ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        
//        switch type {
//        case .insert:
//            insertedIndexPaths.append(newIndexPath!)
//            break
//        case .delete:
//            deletedIndexPaths.append(indexPath!)
//            //add code to delete coredata object
//            
//        case .update:
//            updatedIndexPaths.append(indexPath!)
//            
//        default:
//            break
//            
//            
//        }
//    }
}
