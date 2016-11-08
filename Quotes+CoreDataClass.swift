//
//  Quotes+CoreDataClass.swift
//  T Capstone
//
//  Created by modelf on 10/4/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


public class Quotes: NSManagedObject {
    
    override init (entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    init (content: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Quotes", in: context)!
        super.init(entity: entity, insertInto: context)
        
        
        
        if let outboundLeg = content["OutboundLeg"] as? [String: AnyObject] {
            outboundDestinationID = outboundLeg["DestinationId"] as! Int32
            outboundOriginID = outboundLeg["OriginId"] as! Int32
            if let newCarrier = outboundLeg["CarrierIds"] as? [Int32] {
                if newCarrier.count > 0 {
                    outboundCarrierID = newCarrier.first!
                }
            }
            if let stringForDate = outboundLeg["DepartureDate"] as? String {
                let dateFor = DateFormatter()
                dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                outboundDepartureDate = dateFor.date(from: stringForDate)! as NSDate?
            }
        }
        
        if let inboundLeg = content["InboundLeg"] as? [String: AnyObject] {
            inboundDestinationID = inboundLeg["DestinationId"] as? String
            inboundOriginID = inboundLeg["OriginId"] as? String
            if let newCarrier = inboundLeg["CarrierIds"] as? [String] {
                if newCarrier.count > 0 {
                    inboundCarrierID = newCarrier.first!
                    // is there a case that could cause a crash above?
                }
            }
            if let stringForDate = inboundLeg["DepartureDate"] as? String {
                let dateFor = DateFormatter()
                dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                inboundDepartureDate = dateFor.date(from: stringForDate)! as NSDate?
            }
        }
        

        // need to create conversions
        
        
        price = content["MinPrice"] as! Double
        quoteID = Int32(content["QuoteId"] as! Int)
        isDirect = content["Direct"] as! Bool
        
//        print("Creating Quotes Entity \(quoteID), with price of $\(minPrice) value direct = \(isDirect), value originID = \(originID), value destinationID = \(destinationID), value departureDate = \(departureDate), value carrierID = \(carrierID), string name is \(stringName)")
        
    }
    
    
}


