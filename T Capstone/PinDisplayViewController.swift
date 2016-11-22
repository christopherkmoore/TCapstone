//
//  PinDisplayViewController.swift
//  Go
//
//  Created by modelf on 11/16/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PinDisplayViewController: UIViewController {
    
    var quotes: Quotes!
    var places: [Places]!
    var carriers: [Carriers]!
    var pin: Pin?
    
    enum Status { case inProgress, complete }
    
    @IBOutlet weak var inboundOrigin: UILabel!
    @IBOutlet weak var inboundDestination: UILabel!
    
    @IBOutlet weak var outboundOrigin: UILabel!
    @IBOutlet weak var outboundDestination: UILabel!
    
    @IBOutlet weak var inboundCarrier: UILabel!
    @IBOutlet weak var outboundCarrier: UILabel!
    

    @IBOutlet weak var outboundDepartTime: UILabel!
    @IBOutlet weak var inboundDepartTime: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
   
    

    @IBAction func browseAirbnb(_ sender: Any) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AirbnbMapViewController") as! AirbnbMapViewController
        controller.quote = quotes
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("quotes: \(carriers)")
        
        loadInfo()
    }
    
    func loadInfo() {
        //price 
        priceLabel.text = "$\(quotes.price)0"
        
        // values stored as Ints, need to be converted to Strings
        quotes.outboundOriginIDConvert(places)
        quotes.outboundDestinationIDConvert(places)
        quotes.outboundCarrierIDConvert(carriers)
        quotes.inboundOriginIDConvert(places)
        quotes.inboundDestinationIDConvert(places)
        quotes.inboundCarrierIDConvert(carriers)
        
        //set labels for Flights
        inboundOrigin.text = quotes.inboundOriginIDString
        inboundDestination.text = quotes.inboundDestinationIDString
        outboundOrigin.text = quotes.outboundOriginIDString
        outboundDestination.text = quotes.outboundDestinationIDString
        
        //set labels for Carriers
        inboundCarrier.text = quotes.inboundCarrierIDString
        outboundCarrier.text = quotes.outboundCarrierIDString
        
        //set labels for dates
        let timeDate = DateFormatter()
        timeDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss +zzzz"
        timeDate.timeStyle = .long
        timeDate.dateStyle = .medium

        inboundDepartTime.text = timeDate.string(from: quotes.inboundDepartureDate! as Date)
        outboundDepartTime.text = timeDate.string(from: quotes.outboundDepartureDate! as Date)
        
        
        
        
    }
    
}
