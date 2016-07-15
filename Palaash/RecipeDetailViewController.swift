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
   // var isFavRecipe = false
    var recipe = RecipeData()
 
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var makeFav: UIBarButtonItem!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var isFavRecipe = false
        instructionsTextView.text = "Ingredients and Instructions\n\n"
        instructionsTextView.text.appendContentsOf(ingredients)
        instructionsTextView.text.appendContentsOf("\n\n")
        instructionsTextView.text.appendContentsOf(instructions)
        do {
            print("RecipeDetailViewController ..2")
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("ERROR FETCHING DATA- RecipeDetailViewController", error.localizedDescription)
        }
        fetchedResultsController.delegate = self

        if let favoriteRecipes = fetchedResultsController.fetchedObjects as? [FavoriteRecipes]{
            print("got the favs")
            for fav in favoriteRecipes {
                if(fav.id! == recipe.recipeID){
                    isFavRecipe = true
                    print("this is aleady a fav recipe")
                    isFavMode = true
                }else{
                    print("this is not a fav recipe")
                    isFavMode = false
                }
            }
        }else{
            print("No favs")
        }
        makeFav.image = isFavRecipe ? UIImage(named: "Hearts-48.png") : UIImage(named: "Hearts-50.png")
        
        imageView.image = recipe.image
       
    }
    
    @IBAction func newFav(sender: AnyObject) {
        if(!isFavMode){
            makeFav.image = UIImage(named: "Hearts-48.png")
            isFavMode = true
            let imageData : NSData = UIImagePNGRepresentation(recipe.image)!
            let recipedata = [FavoriteRecipes.Keys.ID : recipe.recipeID,
                              FavoriteRecipes.Keys.Image : imageData ,
                              FavoriteRecipes.Keys.Ingredients : ingredients,
                              FavoriteRecipes.Keys.Process : instructions,
                              FavoriteRecipes.Keys.Name : recipe.title]
            _ = FavoriteRecipes(dictionary: recipedata, context: self.sharedContext)
            
            print("MADE FAV")
            
        }else{
            // sharedContext.deleteObject(recipe.recipeID)
            for fav in fetchedResultsController.fetchedObjects as! [FavoriteRecipes] {
                print("deleting photos")
                if(fav.id! == recipe.recipeID){
                    sharedContext.deleteObject(fav)
                }
            }
            makeFav.image = UIImage(named: "Hearts-50.png")
            isFavMode = false
            print("MADE NONFAV")
            
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
        
        //Return the fetched results controller
        print("fetched results", fetchedResultsController.sections)
        return fetchedResultsController
        
    }()
    
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
