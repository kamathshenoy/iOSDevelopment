//
//  Photo.swift
//  VirtualTourist
//
//  Created by Sheethal Shenoy on 6/25/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import CoreData


class Photo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    struct Keys {
        
        static let URL = "url_m"
        static let ID = "id"
        static let Title = "title"
        static let Image = "image"
    }
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context : NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // Photo object init with support for our managedObjectContext
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        url_m = dictionary[Keys.URL] as? String
        id = dictionary[Keys.ID] as? String
        title = dictionary[Keys.Title] as? String
        image = dictionary[Keys.Image] as? NSData
    }

}
