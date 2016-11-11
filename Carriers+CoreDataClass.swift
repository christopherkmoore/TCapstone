//
//  Carriers+CoreDataClass.swift
//  Go
//
//  Created by modelf on 11/11/16.
//  Copyright © 2016 modelf. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

public class Carriers: NSManagedObject {

    override init (entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init (content: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Carriers", in: context)!
        super.init(entity: entity, insertInto: context)
        
        
        carrierID = content["CarrierId"] as! Int32
        name = content["Name"] as? String
    }
    
}
