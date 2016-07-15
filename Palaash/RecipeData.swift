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
        static let recipeID = "id"
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
        
        title = dictionary[Keys.title] as! String
        recipeID = dictionary[Keys.recipeID] as! Int
        imageURL = dictionary[Keys.image] as! String
        self.image = image
        
    }

    
  
}