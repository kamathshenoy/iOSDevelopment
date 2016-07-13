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
    var recipeID: Int 
    var imageURL: String = ""
    var title: String = ""
    var image : UIImage
   
    
    init(dictionary: [String:AnyObject], image: UIImage) {
        
        title = dictionary["title"] as! String
        recipeID = dictionary["id"] as! Int
        imageURL = dictionary["image"] as! String
        self.image = image
        
    }

    
  
}