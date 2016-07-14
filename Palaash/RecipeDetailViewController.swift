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
    var instructions:[String] = []
    var ingredients:[String] = []
    var isFavRecipe = false
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var makeFav: UIBarButtonItem!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBAction func newFav(sender: AnyObject) {
        print("mode",isFavMode)
        print("isfav recipe",isFavRecipe)

        if(!isFavMode){
            makeFav.image = UIImage(named: "Hearts-48.png")
            isFavMode = true
        }else{
            makeFav.image = UIImage(named: "Hearts-50.png")
            isFavMode = false
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("THE IMAGE",imageView.image)
        instructionsTextView.text = "Ingredients and Instructions\n\n"
        instructionsTextView.text.appendContentsOf(ingredients.joinWithSeparator(", "))
        instructionsTextView.text.appendContentsOf("\n\n")
        instructionsTextView.text.appendContentsOf(instructions.joinWithSeparator("\n"))
       
        
        makeFav.image = isFavRecipe ? UIImage(named: "Hearts-48.png") : UIImage(named: "Hearts-50.png")
        print("THE IMAGE FAV",makeFav.image)
       
    }
}
