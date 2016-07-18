//
//  SearchRecipeViewController.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/6/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class SearchRecipeViewController: UIViewController  {
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
   // @IBOutlet weak var ingredient2: UITextField!
    @IBOutlet weak var ingredient1: UITextField!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var cuisine: UITextField!
    @IBOutlet weak var typeOfRecipe: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionLabel.text = "Here are some options for type of recipes - main course, side dish, dessert, appetizer, salad, bread, breakfast, soup, beverage, sauce, or drink. \n\n We search for vegan recipes only. Go Green!"
    }
    
    
    @IBAction func searchRecipes(sender: AnyObject) {
        guard ingredient1.text != nil else {
            self.showAlertMsg(RecipeConstants.Messages.UserErorrMsg)
            return
        }
        
        RecipeUtil.sharedInstance().searchRecipeForIngredients(ingredient1.text!, cuisine: cuisine.text!, typeOfRecipe: typeOfRecipe.text!) { (data, error) in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.showAlertMsg((error?.userInfo[NSLocalizedDescriptionKey])! as! String)
                    return
                }
            }else{
                RecipeUtil.sharedInstance().getImagesForRecipes(data) { (data, error) in
                    if error != nil {
                        dispatch_async(dispatch_get_main_queue()){
                            self.showAlertMsg((error?.userInfo[NSLocalizedDescriptionKey])! as! String)
                            return
                        }
                    }else{
                        print("the count ",data!.count)
                        RecipeCollection.sharedInstance().recipeData = data!
                        self.showNextScene()
                    }
                }
                
            }

        }
        
    }
    
    
    private func showNextScene() -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ListRecipeViewController") 
        
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    
    func showAlertMsg(msg:String)->Void {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
        return
    }

}

