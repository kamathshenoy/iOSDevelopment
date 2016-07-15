//
//  RecipeData.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/6/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import UIKit

struct RecipeData {
    
    struct Keys {
        static let recipeID = "recipeID"
        static let imageURL = "imageURL"
        static let title = "title"
        static let image = "image"
    }
    
    
    var recipeID: Int 
    var imageURL: String = ""
    var title: String = ""
    var image : UIImage
   
    init(){
        title = ""
        recipeID = 0
        imageURL = ""
        self.image = UIImage(named: "noImage")!
    }
    
    init(dictionary: [String:AnyObject], image: UIImage) {
        
        title = dictionary["title"] as! String
        recipeID = dictionary["id"] as! Int
        imageURL = dictionary["image"] as! String
        self.image = image
        
    }

    
  
}