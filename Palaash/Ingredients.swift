//
//  Ingredients.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/6/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import CoreData


class Ingredients: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    struct Keys {
        static let Ingredient1 = "ingredient1"
        static let Ingredient2 = "ingredient2"
     }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context : NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // Recipe object init with support for our managedObjectContext
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Ingredients", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        ingredient1 = dictionary[Keys.Ingredient1] as? String
        ingredient2 = dictionary[Keys.Ingredient2] as? String
      }
    

}
