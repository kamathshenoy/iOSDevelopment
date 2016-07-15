//
//  FavoriteRecipes.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/6/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import CoreData


class FavoriteRecipes: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    struct Keys {
        static let Ingredients = "ingredients"
        static let Process = "process"
        static let ID = "id"
        static let Name = "name"
        static let Image = "image"
        
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context : NSManagedObjectContext?) {
        print("saving a favorite recipe..1")

        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // Recipe object init with support for our managedObjectContext
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        print("saving a favorite recipe..2")
        let entity = NSEntityDescription.entityForName("FavoriteRecipes", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        process = dictionary[Keys.Process] as? String
        ingredients = dictionary[Keys.Ingredients] as? String
        id = dictionary[Keys.ID] as? NSNumber
        name = dictionary[Keys.Name] as? String
        image = dictionary[Keys.Image] as? NSData
    }


}
