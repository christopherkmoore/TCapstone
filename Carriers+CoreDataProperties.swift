//
//  Carriers+CoreDataProperties.swift
//  Go
//
//  Created by modelf on 11/29/16.
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

}
