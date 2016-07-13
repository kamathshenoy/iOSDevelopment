//
//  RecipeCollection.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/12/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation


class RecipeCollection:  NSObject {
    var recipeData: [RecipeData] = []
    
    
    func setRecipeData(recipeData: [RecipeData]) -> Void {
        self.recipeData = recipeData
    }

    class func sharedInstance() -> RecipeCollection {
        struct Singleton {
            static var sharedInstance = RecipeCollection()
        }
        return Singleton.sharedInstance
    }
}
    