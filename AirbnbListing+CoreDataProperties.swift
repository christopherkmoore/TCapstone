//
//  AirbnbListing+CoreDataProperties.swift
//  Go
//
//  Created by modelf on 11/28/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


extension AirbnbListing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirbnbListing> {
        return NSFetchRequest<AirbnbListing>(entityName: "AirbnbListing");
    }

    @NSManaged public var amount: Int16
    @NSManaged public var bathrooms: Int16
    @NSManaged public var beds: Int16
    @NSManaged public var bnbLatitude: Double
    @NSManaged public var bnbLongitude: Double
    @NSManaged public var id: Int32
    @NSManaged public var person_capacity: Int16
    @NSManaged public var picture_count: Int16
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension AirbnbListing {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: AirbnbPhotos)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: AirbnbPhotos)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
