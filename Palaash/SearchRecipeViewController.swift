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
    
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet weak var ingredient1: UITextField!
    @IBOutlet weak var cuisine: UITextField!
    @IBOutlet weak var typeOfRecipe: UITextField!
    @IBOutlet weak var vegtarianSwitch: UISwitch!
    @IBOutlet weak var veganSwitch: UISwitch!
    
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    var keyboardOnScreen = false
    
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
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: Selectors.KeyboardWillShow)
        subscribeToNotification(UIKeyboardWillHideNotification, selector: Selectors.KeyboardWillHide)
        subscribeToNotification(UIKeyboardDidShowNotification, selector: Selectors.KeyboardDidShow)
        subscribeToNotification(UIKeyboardDidHideNotification, selector: Selectors.KeyboardDidHide)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
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
    
    
    @IBAction func searchRecipes(sender: AnyObject) {
        activityController.startAnimating()
        guard ingredient1.text != nil else {
            self.showAlertMsg(RecipeConstants.Messages.UserErorrMsg)
            return
        }

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
                       
                        RecipeCollection.sharedInstance().recipeData = data!
                        self.showNextScene()
                    }
                }
            }
        }
    }
    
    func saveLastSwitchValue(){
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Vegan")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Vegetarian")
        NSUserDefaults.standardUserDefaults().setObject(veganSwitch.on, forKey: "Vegan")
        NSUserDefaults.standardUserDefaults().setObject(vegtarianSwitch.on, forKey: "Vegetarian")
    }
    
    
    func getLastSwitchValue() {
        if let veggie = NSUserDefaults.standardUserDefaults().objectForKey("Vegetarian") as? Bool  {
            self.vegtarianSwitch.setOn(veggie, animated: false)
        }
        
        if let vegan = NSUserDefaults.standardUserDefaults().objectForKey("Vegan") as? Bool {
            veganSwitch.setOn(vegan, animated: true)
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
    
    
    func setSwitchMode(swit: UISwitch!, mode:Bool){
        swit.setOn(mode, animated: true)
    }
}


extension SearchRecipeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(cuisine)
        resignIfFirstResponder(ingredient1)
        resignIfFirstResponder(typeOfRecipe)
    }
}

extension SearchRecipeViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

struct Selectors {
    static let KeyboardWillShow: Selector = #selector(SearchRecipeViewController.keyboardWillShow(_:))
    static let KeyboardWillHide: Selector = #selector(SearchRecipeViewController.keyboardWillHide(_:))
    static let KeyboardDidShow: Selector = #selector(SearchRecipeViewController.keyboardDidShow(_:))
    static let KeyboardDidHide: Selector = #selector(SearchRecipeViewController.keyboardDidHide(_:))
}

