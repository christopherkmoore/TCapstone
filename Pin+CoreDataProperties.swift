//
//  Pin+CoreDataProperties.swift
//  T Capstone
//
//  Created by modelf on 11/1/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var isOrigin: Bool
    @NSManaged public var quotes: NSSet?

}

// MARK: Generated accessors for quotes
extension Pin {

    @objc(addQuotesObject:)
    @NSManaged public func addToQuotes(_ value: Quotes)

    @objc(removeQuotesObject:)
    @NSManaged public func removeFromQuotes(_ value: Quotes)

    @objc(addQuotes:)
    @NSManaged public func addToQuotes(_ values: NSSet)

    @objc(removeQuotes:)
    @NSManaged public func removeFromQuotes(_ values: NSSet)

}
