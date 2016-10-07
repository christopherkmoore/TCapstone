//
//  Places+CoreDataProperties.swift
//  T Capstone
//
//  Created by modelf on 10/6/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData
import 

extension Places {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Places> {
        return NSFetchRequest<Places>(entityName: "Places");
    }

    @NSManaged public var cityName: String?
    @NSManaged public var countryName: String?
    @NSManaged public var name: String?
    @NSManaged public var placeID: Int32
    @NSManaged public var quote: Quotes?
    @NSManaged public var pins: Pin?

}
