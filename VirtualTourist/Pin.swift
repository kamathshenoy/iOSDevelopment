//
//  Pin.swift
//  VirtualTourist
//
//  Created by Sheethal Shenoy on 6/25/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import CoreData


class Pin: NSManagedObject {
    
    struct Keys {
        static let lat = "latitude"
        static let lon = "longitude"
    }


// Insert code here to add functionality to your managed object subclass
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        latitude = (dictionary[Keys.lat] as? Double)!
        longitude = (dictionary[Keys.lon] as? Double)!
    }

}
