//
//  Pin+CoreDataProperties.swift
//  T Capstone
//
//  Created by modelf on 10/4/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData
import 

extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var quote: NSSet?

}

// MARK: Generated accessors for quote
extension Pin {

    @objc(addQuoteObject:)
    @NSManaged public func addToQuote(_ value: Quotes)

    @objc(removeQuoteObject:)
    @NSManaged public func removeFromQuote(_ value: Quotes)

    @objc(addQuote:)
    @NSManaged public func addToQuote(_ values: NSSet)

    @objc(removeQuote:)
    @NSManaged public func removeFromQuote(_ values: NSSet)

}
