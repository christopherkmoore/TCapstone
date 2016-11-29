//
//  AirbnbPhotos+CoreDataClass.swift
//  Go
//
//  Created by modelf on 11/28/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


public class AirbnbPhotos: NSManagedObject {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(content: String, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: "AirbnbPhotos", in: context)!
        super.init(entity: entity, insertInto: context)
        
        photo = content

    }
    
}
