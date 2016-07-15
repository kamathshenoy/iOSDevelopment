//
//  RecipeDetailViewController.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/6/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class RecipeDetailViewController: UIViewController, NSFetchedResultsControllerDelegate  {
    
    var isFavMode = false
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    var instructions:String = ""
    var ingredients:String = ""
    var isFavRecipe = false
    var recipe = RecipeData()
   // var image : UIImage!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var makeFav: UIBarButtonItem!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBAction func newFav(sender: AnyObject) {
        if(!isFavMode){
            makeFav.image = UIImage(named: "Hearts-48.png")
            isFavMode = true
            
            for fav in fetchedResultsController.fetchedObjects as! FavoriteRecipes {
                print("deleting photos")
                if(fav.Id == recipe.recipeID){
                    sharedContext.deleteObject(fav)
                }
            }
            print("MADE FAv")

        }else{
            makeFav.image = UIImage(named: "Hearts-50.png")
            isFavMode = false
            let recipedata = [FavoriteRecipes.Keys.ID : recipe.recipeID,
                              FavoriteRecipes.Keys.Image : recipe.image,
                              FavoriteRecipes.Keys.Ingredients : ingredients,
                              FavoriteRecipes.Keys.Process : instructions,
                              FavoriteRecipes.Keys.Name : recipe.title]
            _ = FavoriteRecipes(dictionary: recipedata, context: self.sharedContext)
            print("MADE NONFAV")
            
        }
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        //Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "FavoriteRecipes")
        
        //Add a sort descriptor
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "ID", ascending: true)]
        
        // Fetch only photos from the selected pin
      /*  let predicate = NSPredicate(format: "ID == %@", self.recipe.recipeID)
        fetchRequest.predicate = predicate*/
        
        //Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        //Return the fetched results controller
        return fetchedResultsController
        
    }()

       
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("THE IMAGE",imageView.image)
        instructionsTextView.text = "Ingredients and Instructions\n\n"
        instructionsTextView.text.appendContentsOf(ingredients)
        instructionsTextView.text.appendContentsOf("\n\n")
        instructionsTextView.text.appendContentsOf(instructions)
       
        
        makeFav.image = isFavRecipe ? UIImage(named: "Hearts-48.png") : UIImage(named: "Hearts-50.png")
        
        imageView.image = recipe.image
       
    }
}
