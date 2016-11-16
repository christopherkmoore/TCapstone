//
//  Carriers+CoreDataProperties.swift
//  Go
//
//  Created by modelf on 11/13/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


extension Carriers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Carriers> {
        return NSFetchRequest<Carriers>(entityName: "Carriers");
    }

    @NSManaged public var carrierID: Int32
    @NSManaged public var name: String?
    @NSManaged public var quotes: NSSet?

}

// MARK: Generated accessors for quotes
extension Carriers {

    @objc(addQuotesObject:)
    @NSManaged public func addToQuotes(_ value: Quotes)

    @objc(removeQuotesObject:)
    @NSManaged public func removeFromQuotes(_ value: Quotes)

    @objc(addQuotes:)
    @NSManaged public func addToQuotes(_ values: NSSet)

    @objc(removeQuotes:)
    @NSManaged public func removeFromQuotes(_ values: NSSet)

}
