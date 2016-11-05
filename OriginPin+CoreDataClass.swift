//
//  OriginPin+CoreDataClass.swift
//  T Capstone
//
//  Created by modelf on 11/3/16.
//  Copyright © 2016 modelf. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import MapKit

public class OriginPin: NSManagedObject, MKAnnotation {
    
    
    var _coords: CLLocationCoordinate2D?
    public var coordinate: CLLocationCoordinate2D {
        
        set {
            willChangeValue(forKey: "coordinate")
            _coords = newValue
            
            // set the new values of the lat and long
            if let coord = _coords {
                originLatitude = coord.latitude
                originLongitude = coord.longitude
            }
            
            didChangeValue(forKey: "coordinate")
        }
        
        get {
            if _coords == nil {
                _coords = CLLocationCoordinate2DMake(originLatitude, originLongitude)
            }
            
            return _coords!
        }
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entity(forEntityName: "OriginPin", in: context){
            super.init(entity: entity, insertInto: context)
            
            self.originLatitude = latitude
            self.originLongitude = longitude
            
            
            coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        } else {
            fatalError("Unable to find Entity Name")
        }
        
    }

}
