//
//  AirbnbListing+CoreDataProperties.swift
//  Go
//
//  Created by modelf on 11/23/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


extension AirbnbListing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirbnbListing> {
        return NSFetchRequest<AirbnbListing>(entityName: "AirbnbListing");
    }

    @NSManaged public var bnbLatitude: Double
    @NSManaged public var bnbLongitude: Double
    @NSManaged public var person_capacity: Int16
    @NSManaged public var beds: Int16
    @NSManaged public var bathrooms: Int16
    @NSManaged public var amount: Int16

}
