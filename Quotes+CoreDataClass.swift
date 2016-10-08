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
        
        
        //        print(content)
        
        if let outboundLeg = content["OutboundLeg"] as? [String: AnyObject] {
            destinationID = Int32(outboundLeg["DestinationId"] as! Int)
            originID = Int32(outboundLeg["OriginId"] as! Int)
            if let newCarrier = outboundLeg["CarrierIds"] as? [Int32] {
                if newCarrier.count > 0 {
                    self.carrierID = newCarrier.first!
                    // is there a case that could cause a crash above?
                }
            }
            if let stringForDate = outboundLeg["DepartureDate"] as? String {
                let dateFor = DateFormatter()
                dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                self.departureDate = dateFor.date(from: stringForDate)! as NSDate?
            }
        }
        
        
        
        minPrice = content["MinPrice"] as! Double
        quoteID = Int32(content["QuoteId"] as! Int)
        
        let direct = content["Direct"] as! Int
        if direct == 0 {
            isDirect = false
        } else {
            isDirect = true
        }
            
//        print("Creating Quotes Entity \(quoteID), with price of $\(minPrice) value direct = \(isDirect), value originID = \(originID), value destinationID = \(destinationID), value departureDate = \(departureDate), value carrierID = \(carrierID), string name is \(stringName)")
        
    }
    
    
}
