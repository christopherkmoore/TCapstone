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
        fetchRequestQuotes.sortDescriptors = [NSSortDescriptor(key: "minPrice", ascending: true)]
        fetchRequestQuotes.predicate = NSPredicate(format: "pin == %@", self.pin)
        
        let fetchRequestPlaces: NSFetchRequest<Places> = Places.fetchRequest()
        fetchRequestPlaces.sortDescriptors = []
//        fetchRequestPlaces.predicate = NSPredicate(format: "pin == %@", self.pin)
        
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
        tableView.delegate = self
        
    }

    
    func convertPlaces () {
        let quotes = fetchedResultsQuotesController.fetchedObjects
        let places = fetchedResultsPlacesController.fetchedObjects
        
        //This can probably be replaced with one of the higher level functions map filter reduce
        
        
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
        
        let quote = fetchedResultsQuotesController.object(at: indexPath)
        
        AirbnbClient.sharedInstance().browseAirbnbListing(quote, completionHandler: {(success, data, error) in
            
            if (success) {
                print(data!)
            }
            
        })
    
    }
}
