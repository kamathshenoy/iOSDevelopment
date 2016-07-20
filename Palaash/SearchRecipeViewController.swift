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
    
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet weak var ingredient1: UITextField!
   
    @IBOutlet weak var cuisine: UITextField!
    @IBOutlet weak var typeOfRecipe: UITextField!
    
    @IBOutlet weak var vegtarianSwitch: UISwitch!
    @IBOutlet weak var veganSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLastSwitchValue()
        if(vegtarianSwitch.on){
            setSwitchMode(veganSwitch, mode: false)
        }
        if(veganSwitch.on){
            setSwitchMode(vegtarianSwitch, mode: false)
        }
        activityController.hidesWhenStopped = true
    }
    
    func setSwitchMode(swit: UISwitch!, mode:Bool){
        swit.setOn(mode, animated: true)
    }
    
    
    @IBAction func setVeganOption(sender: AnyObject) {
        if(veganSwitch.on){
            setSwitchMode(vegtarianSwitch, mode: false)
        }
        saveLastSwitchValue()
        
    }
    
    @IBAction func setVegetarianOption(sender: AnyObject) {
        if(vegtarianSwitch.on){
            setSwitchMode(veganSwitch, mode: false)
        }
        saveLastSwitchValue()
    }
    
    func saveLastSwitchValue(){
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Vegan")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Vegetarian")
        NSUserDefaults.standardUserDefaults().setObject(veganSwitch.on, forKey: "Vegan")
        NSUserDefaults.standardUserDefaults().setObject(vegtarianSwitch.on, forKey: "Vegetarian")
    }
    
    
    func getLastSwitchValue() {
        if let veggie = NSUserDefaults.standardUserDefaults().boolForKey("Vegetarian")  as? Bool{
            self.vegtarianSwitch.setOn(veggie, animated: false)
        }
        
        if let vegan = NSUserDefaults.standardUserDefaults().boolForKey("Vegan") as? Bool {
            veganSwitch.setOn(vegan, animated: true)
        }
        
    }
    
    @IBAction func searchRecipes(sender: AnyObject) {
        activityController.startAnimating()
        guard ingredient1.text != nil else {
            self.showAlertMsg(RecipeConstants.Messages.UserErorrMsg)
            return
        }
        print("is vegan switch", veganSwitch.on)
        print("is vegetarian switch", vegtarianSwitch.on)
        RecipeUtil.sharedInstance().searchRecipeForIngredients(ingredient1.text!, cuisine: cuisine.text!, typeOfRecipe: typeOfRecipe.text!, dietValue: veganSwitch.on ? "vegan" : "vegetarian" ) { (data, error) in
            
            if error != nil {
                self.activityController.stopAnimating()
                dispatch_async(dispatch_get_main_queue()){
                    self.showAlertMsg((error?.userInfo[NSLocalizedDescriptionKey])! as! String)
                    return
                }
            }else{
                self.activityController.stopAnimating()
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

