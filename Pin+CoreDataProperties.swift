//
//  Pin+CoreDataProperties.swift
//  Go
//
//  Created by modelf on 11/29/16.
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

}
