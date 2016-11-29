//
//  Places+CoreDataProperties.swift
//  Go
//
//  Created by modelf on 11/29/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


extension Places {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Places> {
        return NSFetchRequest<Places>(entityName: "Places");
    }

    @NSManaged public var cityName: String?
    @NSManaged public var countryName: String?
    @NSManaged public var name: String?
    @NSManaged public var placeID: Int32
    @NSManaged public var pin: Pin?

}
