//
//  AirbnbPhotos+CoreDataProperties.swift
//  Go
//
//  Created by modelf on 11/28/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


extension AirbnbPhotos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirbnbPhotos> {
        return NSFetchRequest<AirbnbPhotos>(entityName: "AirbnbPhotos");
    }

    @NSManaged public var photo: String?
    @NSManaged public var airbnbListing: AirbnbListing?

}
