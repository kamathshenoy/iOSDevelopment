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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var makeFav: UIBarButtonItem!
    @IBOutlet weak var instructionsTextView: UITextView!
    var isFavMode = false
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    var recipe = RecipeData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        instructionsTextView.text = "List of ingredients need for the recipe:\n"
        instructionsTextView.text.appendContentsOf(recipe.ingredients)
        instructionsTextView.text.appendContentsOf("\n\nHow to make it: \n")
        instructionsTextView.text.appendContentsOf(recipe.instructions)
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            
            print("ERROR FETCHING DATA- RecipeDetailViewController", error.localizedDescription)
        }
        fetchedResultsController.delegate = self
        for fav in fetchedResultsController.fetchedObjects as! [FavoriteRecipes] {
            if(fav.id! == recipe.recipeID){
                print(" This is already a favorite")
                isFavMode = true
            }
        }
        setImages(isFavMode)
    }
    
    
    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func newFav(sender: AnyObject) {
  
        if(!isFavMode){
            makeFav.image = UIImage(named: "Hearts-48.png")
            isFavMode = true
            let imageData : NSData = UIImagePNGRepresentation(recipe.image)!
            let recipedata = [FavoriteRecipes.Keys.ID : recipe.recipeID,
                              FavoriteRecipes.Keys.Image : imageData ,
                              FavoriteRecipes.Keys.Ingredients : recipe.ingredients,
                              FavoriteRecipes.Keys.Process : recipe.instructions,
                              FavoriteRecipes.Keys.Name : recipe.title]
            _ = FavoriteRecipes(dictionary: recipedata, context: self.sharedContext)
        
            
        }else{
            
            for fav in fetchedResultsController.fetchedObjects as! [FavoriteRecipes] {
                print("deleting photos")
                if(fav.id! == recipe.recipeID){
                    sharedContext.deleteObject(fav)
                }
            }
            makeFav.image = UIImage(named: "Hearts-50.png")
            isFavMode = false
            
        }
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        //Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "FavoriteRecipes")
        
        //Add a sort descriptor
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        //Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
  
        return fetchedResultsController
        
    }()
    
    
    func setImages(isFavRecipe:Bool){
        makeFav.image = isFavRecipe ? UIImage(named: "Hearts-48.png") : UIImage(named: "Hearts-50.png")
        imageView.image = recipe.image
    }
    
}
