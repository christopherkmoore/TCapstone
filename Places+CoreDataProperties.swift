//
//  Places+CoreDataProperties.swift
//  T Capstone
//
//  Created by modelf on 11/7/16.
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
    @NSManaged public var quote: NSSet?

}

// MARK: Generated accessors for quote
extension Places {

    @objc(addQuoteObject:)
    @NSManaged public func addToQuote(_ value: Quotes)

    @objc(removeQuoteObject:)
    @NSManaged public func removeFromQuote(_ value: Quotes)

    @objc(addQuote:)
    @NSManaged public func addToQuote(_ values: NSSet)

    @objc(removeQuote:)
    @NSManaged public func removeFromQuote(_ values: NSSet)

}
