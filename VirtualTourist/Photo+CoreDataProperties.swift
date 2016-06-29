//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Sheethal Shenoy on 6/28/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var url_m: String?
    @NSManaged var image: NSData?
    @NSManaged var photoToPin: Pin?

}
