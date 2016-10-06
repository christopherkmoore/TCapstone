//
//  Places+CoreDataProperties.swift
//  T Capstone
//
//  Created by modelf on 10/4/16.
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
    @NSManaged public var quotes: NSSet?

}

// MARK: Generated accessors for quotes
extension Places {

    @objc(addQuotesObject:)
    @NSManaged public func addToQuotes(_ value: Quotes)

    @objc(removeQuotesObject:)
    @NSManaged public func removeFromQuotes(_ value: Quotes)

    @objc(addQuotes:)
    @NSManaged public func addToQuotes(_ values: NSSet)

    @objc(removeQuotes:)
    @NSManaged public func removeFromQuotes(_ values: NSSet)

}
