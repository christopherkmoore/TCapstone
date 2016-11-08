//
//  Places+CoreDataClass.swift
//  T Capstone
//
//  Created by modelf on 10/4/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import CoreData


public class Places: NSManagedObject {

    
    override init (entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    init (content: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Places", in: context)!
        super.init(entity: entity, insertInto: context)
        

        placeID = content["PlaceId"] as! Int32
        name = content["Name"] as? String
        cityName = content["CityName"] as? String
        countryName = content["CountryName"] as? String
        
        
        
//        print("saving placeID of \(placeID) to name \(name) with optional values city name = \(cityName) and country name = \(countryName)")

    }
    
}
