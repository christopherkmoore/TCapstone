//
//  OriginPin+CoreDataProperties.swift
//  T Capstone
//
//  Created by modelf on 11/4/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


extension OriginPin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OriginPin> {
        return NSFetchRequest<OriginPin>(entityName: "OriginPin");
    }

    @NSManaged public var originLatitude: Double
    @NSManaged public var originLongitude: Double

}
