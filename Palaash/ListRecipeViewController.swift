//
//  ListRecipeViewController.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/6/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class ListRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate  {
   
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    var recipeData = RecipeCollection.sharedInstance().recipeData

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get cell type
        let cellReuseIdentifier = "Recipe"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let recipe = recipeData[indexPath.row]
        let imgView: UIImageView = cell.imageView!
        imgView.image = RecipeUtil.sharedInstance().resizeImageWithAspect(recipe.image,  scaledToMaxWidth: 80, maxHeight: 80)
        cell.textLabel!.text = recipe.title
        cell.textLabel!.font = UIFont(name:"System", size:10)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeData.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellReuseIdentifier = "Recipe"
        _ = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let recipe = recipeData[indexPath.row] 
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("RecipeDetailViewController") as! RecipeDetailViewController
        controller.recipe = recipe
        controller.isFavMode = false
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func dismissVC(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func showAlertMsg(msg:String)->Void {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
        return
    }
}
