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
        static let recipeID: String = "id"
        static let imageURL = "imageURL"
        static let title = "title"
        static let image = "image"
    }
    
    
    var recipeID: Int 
   // var imageURL: String = ""
    var title: String = ""
    var image : UIImage
    var instructions : String = ""
    var ingredients : String = ""
    
    init(){
        title = ""
        recipeID = 0
        //imageURL = ""
        ingredients = ""
        instructions = ""
        self.image = UIImage(named: "noImage")!
    }
    
    init(title: String, recipeID: Int, image: UIImage, ingredients:String, instructions: String) {
        
        self.title = title
        self.recipeID = recipeID
       // imageURL = dictionary[Keys.image] as! String
        self.ingredients = ingredients
        self.instructions = instructions
        self.image = image
        
        
    }

    
  
}