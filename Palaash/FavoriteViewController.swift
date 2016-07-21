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
    
  //  @IBOutlet weak var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // instructionLabel.text = "Tap on the recipe to change favorites."
        do {
           
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print("ERROR FETCHING DATA", error.localizedDescription)
        }
          fetchedResultsController.delegate = self
    }
    
    func showAlertMsg(msg:String)->Void {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
        return
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        //Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "FavoriteRecipes")
        
        //Add a sort descriptor
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        // Fetch only photos from the selected pin
        //let predicate = NSPredicate(format: "photoToPin == %@", self.)
        //fetchRequest.predicate = predicate
        
        //Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        //fetchedResultsController.
        //Return the fetched results controller
        print("fetched results", fetchedResultsController.sections)
        return fetchedResultsController
        
    }()
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // This invocation prepares the table to recieve a number of changes. It will store them up
        // until it receives endUpdates(), and then perform them all at once.
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        // Our project does not use sections. So we can ignore these invocations.
    }
    
    //
    // This is the most important method. It adds and removes rows in the table, in response to changes in the data.
    //
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
      
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    // When endUpdates() is invoked, the table makes the changes visible.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get cell type
        let cellReuseIdentifier = "FavoriteRecipe"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let recipes = self.fetchedResultsController.objectAtIndexPath(indexPath) as?  FavoriteRecipes
        let imgView: UIImageView = cell.imageView!
        if let recipes = recipes {
            imgView.image = RecipeUtil.sharedInstance().resizeImageWithAspect(UIImage(data: recipes.image!)!,  scaledToMaxWidth: 80, maxHeight: 80)
            cell.textLabel!.text = recipes.name
        }
        cell.textLabel!.font = UIFont(name:"System", size:10)
        return cell
    }
   
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            print("currentSection.numberOfObjects",currentSection.numberOfObjects)
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellReuseIdentifier = "FavoriteRecipe"
        _ = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let recipes = self.fetchedResultsController.objectAtIndexPath(indexPath) as?  FavoriteRecipes
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("RecipeDetailViewController") as! RecipeDetailViewController

        controller.isFavMode = true
        let recipeData = RecipeData(title: (recipes?.name)!,
                                    recipeID: Int((recipes?.id)!),
                                    image: UIImage(data: (recipes?.image)!)!,
                                    ingredients : (recipes?.ingredients)!,
                                    instructions: (recipes?.process)! )
        controller.recipe = recipeData
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let event = self.fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteRecipes
            sharedContext.deleteObject(event)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }


}

