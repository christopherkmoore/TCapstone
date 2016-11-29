//
//  AirbnbListing+CoreDataClass.swift
//  Go
//
//  Created by modelf on 11/22/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


public class AirbnbListing: NSManagedObject {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(content: [String: AnyObject], context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: "AirbnbListing", in: context)!
        super.init(entity: entity, insertInto: context)
        
        
        if let listing = content["listing"] as? [String: AnyObject] {
            bnbLatitude = listing["lat"] as! Double
            bnbLongitude = listing["lng"] as! Double
            beds = listing["beds"] as! Int16
            person_capacity = listing["person_capacity"] as! Int16
            bathrooms = listing["bathrooms"] as! Int16
            picture_count = listing["picture_count"] as! Int16
            id = listing["id"] as! Int32
            // if theres an error check to make sure the property value is type [String]

            
            
            
//            picture_urls = [listing["picture_urls"] as! NSString]
            
            
        }
        
        if let pricing_quote = content["pricing_quote"] as? [String: AnyObject] {
            if let price = pricing_quote["rate"] as? [String: AnyObject] {
                amount = price["amount"] as! Int16
            }
        }
    }
}

extension AirbnbListing {
    
}
