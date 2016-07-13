//
//  FavoriteViewController.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/6/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class FavoriteViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate  {
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    @IBOutlet var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        //Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "FavoriteRecipes")
        
        //Add a sort descriptor
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Fetch only photos from the selected pin
        //let predicate = NSPredicate(format: "photoToPin == %@", self.)
        //fetchRequest.predicate = predicate
        
        //Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        //Return the fetched results controller
        return fetchedResultsController
        
    }()

    
    
}


extension FavoriteViewController {
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get cell type
        let cellReuseIdentifier = "FavoriteRecipe"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let recipes = self.fetchedResultsController.objectAtIndexPath(indexPath) as?  FavoriteRecipes
        _ = recipes!.image
        cell.textLabel!.text = recipes!.name
        return cell
    }
    
     @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            print("currentSection.numberOfObjects",currentSection.numberOfObjects)
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellReuseIdentifier = "FavoriteRecipe"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let recipes = self.fetchedResultsController.objectAtIndexPath(indexPath) as?  FavoriteRecipes
    }
    
}

