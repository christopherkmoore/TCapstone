//
//  AirbnbPhotoURL+CoreDataProperties.swift
//  Go
//
//  Created by modelf on 11/25/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


extension AirbnbPhotoURL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirbnbPhotoURL> {
        return NSFetchRequest<AirbnbPhotoURL>(entityName: "AirbnbPhotoURL");
    }

    @NSManaged public var url: String?
    @NSManaged public var listing: AirbnbListing?

}
