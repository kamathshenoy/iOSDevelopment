//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Sheethal Shenoy on 6/27/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var currentPage: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var totalPages: NSNumber?
    @NSManaged var pintoPhoto: NSSet?

}
