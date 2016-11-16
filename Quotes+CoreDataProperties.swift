//
//  Quotes+CoreDataProperties.swift
//  Go
//
//  Created by modelf on 11/16/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


extension Quotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quotes> {
        return NSFetchRequest<Quotes>(entityName: "Quotes");
    }

    @NSManaged public var inboundCarrierID: Int32
    @NSManaged public var inboundCarrierIDString: String?
    @NSManaged public var inboundDepartureDate: NSDate?
    @NSManaged public var inboundDestinationID: Int32
    @NSManaged public var inboundDestinationIDString: String?
    @NSManaged public var inboundOriginID: Int32
    @NSManaged public var inboundOriginIDString: String?
    @NSManaged public var isDirect: Bool
    @NSManaged public var outboundCarrierID: Int32
    @NSManaged public var outboundCarrierIDString: String?
    @NSManaged public var outboundDepartureDate: NSDate?
    @NSManaged public var outboundDestinationID: Int32
    @NSManaged public var outboundDestinationIDString: String?
    @NSManaged public var outboundOriginID: Int32
    @NSManaged public var outboundOriginIDString: String?
    @NSManaged public var price: Double
    @NSManaged public var quoteID: Int32
    @NSManaged public var pin: Pin?
    @NSManaged public var place: NSSet?
    @NSManaged public var carrier: Carriers?

}

// MARK: Generated accessors for place
extension Quotes {

    @objc(addPlaceObject:)
    @NSManaged public func addToPlace(_ value: Places)

    @objc(removePlaceObject:)
    @NSManaged public func removeFromPlace(_ value: Places)

    @objc(addPlace:)
    @NSManaged public func addToPlace(_ values: NSSet)

    @objc(removePlace:)
    @NSManaged public func removeFromPlace(_ values: NSSet)

}
