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
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    var recipeData = RecipeCollection.sharedInstance().recipeData
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func dismissVC(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("recipedata", recipeData.count)
    }
    
    
    func showAlertMsg(msg:String)->Void {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
        return
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get cell type
        let cellReuseIdentifier = "Recipe"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let recipe = recipeData[indexPath.row]
        let imgView: UIImageView = cell.imageView!
        imgView.image = recipe.image
        print("cell.frame.size.width",cell.frame.size.width)
        imgView.frame =  CGRectMake(0, 0, cell.frame.size.width, 80);
        cell.contentView.addSubview(imgView)
        

        cell.textLabel!.text = recipe.title
        print("recipe.title", recipe.title)
        return cell
    }
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeData.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellReuseIdentifier = "Recipe"
        _ = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let recipe = recipeData[indexPath.row] as!  RecipeData
        print("recipe id", recipe.recipeID)
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("RecipeDetailViewController") as? RecipeDetailViewController
            
            
        RecipeUtil.sharedInstance().getInstructions((recipe.recipeID)){ (ingredients,instructions, error) in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()){
                        self.showAlertMsg((error?.userInfo[NSLocalizedDescriptionKey])! as! String)
                        return
                    }
                }else{
                    print("recieved instructins")
                    dispatch_async(dispatch_get_main_queue()){
                        controller?.imageView.image = recipe.image
                        print("+++++++++++++++++++++")
                        print(ingredients)
                        print(instructions)
                        controller?.instructions = instructions
                        controller?.ingredients = ingredients
                        self.presentViewController(controller!, animated: true, completion: nil)
                    }
                }
        }
    }
}
