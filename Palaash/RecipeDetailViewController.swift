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
    @IBOutlet weak var makeFav: UIBarButtonItem!
    var isFavMode = false
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
   
    var instructions:[String] = []
    var ingredients:[String] = []
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func newFav(sender: AnyObject) {
        if(!isFavMode){
            makeFav.image = UIImage(contentsOfFile: "Hearts-48.png")
            isFavMode = true
        }else{
            makeFav.image = UIImage(contentsOfFile: "Hearts-50.png")
            isFavMode = false
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text =   "work in progress"
        
    }
}
