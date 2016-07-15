//
//  FavoriteRecipes+CoreDataProperties.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/15/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FavoriteRecipes {

    @NSManaged var id: String?
    @NSManaged var image: NSData?
    @NSManaged var ingredients: String?
    @NSManaged var name: String?
    @NSManaged var process: String?

}
