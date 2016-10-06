//
//  Quotes+CoreDataProperties.swift
//  T Capstone
//
//  Created by modelf on 10/5/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData
import 

extension Quotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quotes> {
        return NSFetchRequest<Quotes>(entityName: "Quotes");
    }

    @NSManaged public var carrierID: Int32
    @NSManaged public var departureDate: NSDate?
    @NSManaged public var destinationID: Int32
    @NSManaged public var isDirect: Bool
    @NSManaged public var minPrice: Double
    @NSManaged public var originID: Int32
    @NSManaged public var quoteID: Int32
    @NSManaged public var stringName: String?
    @NSManaged public var pin: Pin?
    @NSManaged public var place: Places?

}
