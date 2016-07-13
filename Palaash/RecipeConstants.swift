//
//  RecipeConstants.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/10/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
struct RecipeConstants {
    
    
    struct SearchRecipe {
       // static let ServiceEndpoint = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/searchComplex"
        /*https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/searchComplex?includeIngredients=broccoli,rice%20&cuisine=Indian%20&query=rice&limitLicense=false&type=sides*/
        static let ApiScheme = "https"
        static let ApiHome = "spoonacular-recipe-food-nutrition-v1.p.mashape.com"
        static let ApiPath = "/recipes"
        static let Extension = "searchComplex"
        static let AnalyzedInstructions = "analyzedInstructions"
        
        /*https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/{id}/analyzedInstructions*/
    }
    
    struct MashapeQuery {
        static let Cuisine = "cuisine"
        static let includeIngreidents = "includeIngredients"
        static let limitLicense = "limitLicense"
        static let limitLicense_value = "false"
        static let type = "type"
        static let diet = "diet"
        static let query = "query"
        static let query_value = "burger"
        static let diet_value = "vegan"

    }
    
    struct APIHeaderKeys {
        static let X_Mashape_Key = "X-Mashape-Key"
        static let MashapeKey = "R7bZRcHMmAmshaZvvcWU8NbcRZuhp11W45Ljsnd9B5V7ozR2H5"
    }

    struct  Messages {
        static let NetworkErrorMsg = "Failure to connect to internet"
        static let Failure = "Unable to get any recipe. Please try again"
        static let InstructionFailure = "Unable to get detailed instructions"
        static let UserErorrMsg = "Add an ingredient and then click 'Search Recipe'"
    }
}


