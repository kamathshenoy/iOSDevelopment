//
//  RecipeUtil.swift
//  Palaash
//
//  Created by Sheethal Shenoy on 7/10/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import UIKit
class RecipeUtil: NSObject {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    func parseURLFromParameters(parameters: [String:AnyObject],  withPathExtension: [String]? = nil) -> NSURL {
        let components = NSURLComponents()
        components.scheme = RecipeConstants.SearchRecipe.ApiScheme
        components.host = RecipeConstants.SearchRecipe.ApiHome
        var path = RecipeConstants.SearchRecipe.ApiPath //+ (withPathExtension ?? "")
        for (extn) in withPathExtension! {
            path = path + "/"+extn ?? ""
        }
        components.path = path
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            if ((value as? String) != nil) {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.URL!
    }
    
    
    func searchRecipeForIngredients(ingredients:String, cuisine:String, typeOfRecipe:String, dietValue: String, completionHandlerForSearch: (result: [[String:String]], error: NSError?) -> Void){
        
        var tor = typeOfRecipe
        if(typeOfRecipe.containsString("main") || typeOfRecipe.isEmpty){
            tor = "main dish"
        }else if(typeOfRecipe.containsString("side") ){
            tor = "side dish"
        }
        let methodParameters = [
            RecipeConstants.MashapeQuery.Cuisine : cuisine,
            RecipeConstants.MashapeQuery.includeIngreidents : ingredients,
           // RecipeConstants.MashapeQuery.query : RecipeConstants.MashapeQuery.query_value,
            RecipeConstants.MashapeQuery.limitLicense : RecipeConstants.MashapeQuery.limitLicense_value,
            RecipeConstants.MashapeQuery.type : tor,
            RecipeConstants.MashapeQuery.diet :  dietValue
        ];
        
        let request = NSMutableURLRequest(URL:parseURLFromParameters(methodParameters , withPathExtension: [RecipeConstants.SearchRecipe.Extension]))
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(RecipeConstants.APIHeaderKeys.MashapeKey, forHTTPHeaderField: RecipeConstants.APIHeaderKeys.X_Mashape_Key)
      
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                print("NO INTERNET CONNECTION")
                let info = [NSLocalizedDescriptionKey : RecipeConstants.Messages.NetworkErrorMsg]
                completionHandlerForSearch(result: [[String:String]](), error: NSError(domain: "completionHandlerForSearch",  code: 1, userInfo: info))
                return
            }
            
            let info = [NSLocalizedDescriptionKey : RecipeConstants.Messages.Failure]
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode == 200 && statusCode <= 299 else {
                completionHandlerForSearch(result: [[String:String]](), error: NSError(domain: "completionHandlerForSearch", code: 1, userInfo: info))
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)

            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let totalResults = parsedResult["totalResults"] as? Int else {
                print(" Could not get the totalReults \(parsedResult)")
                completionHandlerForSearch(result: [[String:String]](), error: NSError(domain: "completionHandlerForSearch", code: 1, userInfo: info))
                return
            }
           
            if(totalResults == 0){
                completionHandlerForSearch(result: [[String:String]](), error: NSError(domain: "completionHandlerForSearch", code: 1, userInfo: info))
                return
            }
            
          /*  guard let offset = parsedResult["offset"] as? Int else {
                print(" Could not get the totalReults \(parsedResult)")
                completionHandlerForSearch(result: nil, error: NSError(domain: "completionHandlerForSearch", code: 1, userInfo: info))
                return
            }*/
            
            guard let sessionResult = parsedResult["results"] as? [[String:AnyObject]] else {
                print(" See error code and message \(parsedResult)")
                completionHandlerForSearch(result: [[String:String]](), error: NSError(domain: "completionHandlerForSearch", code: 1, userInfo: info))
                return
            }
            
            var myNewDictArray = [[String:String]]()
            var countOfResultsProcessedFetchDetails = 0
            for result in sessionResult {
            //get the detailed instructions and ingredients list for each recipe
                
                self.getInstructions(result["id"] as! Int){ (ingredients,instructions, error) in
                    countOfResultsProcessedFetchDetails += 1
                    if error != nil {
                        print("Detailed instructions can't be retrieved. Ignore the recipe", result["id"]!)
                        if(totalResults == countOfResultsProcessedFetchDetails){
                            completionHandlerForSearch(result:myNewDictArray, error: nil)
                        }
                    }else{
                        print("Recieved instructions", result["id"]!)
                        myNewDictArray.append( [TempKeys.goodRecipe : String(result["id"]!),
                            TempKeys.goodRecipesIngredients : ingredients,
                            TempKeys.goodRecipesInstructions : instructions,
                            TempKeys.image : result["image"] as! String,
                            TempKeys.title : result["title"] as! String])
                        if(totalResults == countOfResultsProcessedFetchDetails){
                            completionHandlerForSearch(result:myNewDictArray, error: nil)
                        }
                    }
                }
            }
        }
        task.resume()
    }
   
    
    func getImagesForRecipes(myNewDictArray : [[String:String]], completionHandlerForSearchRecipes: (result: [RecipeData]?, error: NSError?) -> Void){
        
        var rdata = [RecipeData]()
        var countOfResultsProcessedFetchImage = 0
        for aGoodRecipe in myNewDictArray {
            let recipeID:Int = Int(aGoodRecipe[TempKeys.goodRecipe]!)!
            _ =  RecipeUtil.sharedInstance().getImage((aGoodRecipe[TempKeys.image]!  as String)) { (data, error) in
                countOfResultsProcessedFetchImage += 1
                if error != nil {
                    print("Error downloading image for the recipe .ignore the recipe", recipeID)
                    if(myNewDictArray.count == countOfResultsProcessedFetchImage){
                        completionHandlerForSearchRecipes(result:rdata, error: nil)
                    }
                } else {
                    if let data = data {
                        let recipeData = RecipeData(title: aGoodRecipe[TempKeys.title]!,
                                                    recipeID: recipeID,
                                                    image:data,
                                                    ingredients: aGoodRecipe[TempKeys.goodRecipesIngredients]!,
                                                    instructions: aGoodRecipe[TempKeys.goodRecipesInstructions]!)
                        
                        print("Downloaded the image..adding to the recipe data", aGoodRecipe[TempKeys.goodRecipe]!)
                        rdata.append(recipeData)
                        if(myNewDictArray.count  == countOfResultsProcessedFetchImage){
                            completionHandlerForSearchRecipes(result:rdata, error: nil)
                        }
                    }
                }//end of else
            }//end of getImage
            
        }//end of for loop
        
    }
 
    
    func getInstructions(id: Int, completionHandlerForInstructions: (ingredients: String, steps: String, error: NSError?) -> Void){
       
        let request2 = NSMutableURLRequest(URL:parseURLFromParameters([String: AnyObject]() , withPathExtension: [String(id), RecipeConstants.SearchRecipe.AnalyzedInstructions]))
        request2.HTTPMethod = "GET"
        request2.addValue("application/json", forHTTPHeaderField: "Accept")
        request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request2.addValue(RecipeConstants.APIHeaderKeys.MashapeKey, forHTTPHeaderField: RecipeConstants.APIHeaderKeys.X_Mashape_Key)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request2) { data, response, error in
            
            if error != nil { // Handle error…
                print("NO INTERNET CONNECTION")
                let info = [NSLocalizedDescriptionKey : RecipeConstants.Messages.NetworkErrorMsg]
                completionHandlerForInstructions(ingredients : "", steps: "", error: NSError(domain: "completionHandlerForInstructions",  code: 1, userInfo: info))
                return
            }
           
            let info = [NSLocalizedDescriptionKey : RecipeConstants.Messages.InstructionFailure]
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode == 200 && statusCode <= 299 else {
                completionHandlerForInstructions(ingredients : "", steps: "", error: NSError(domain: "completionHandlerForInstructions",  code: 1, userInfo: info))
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)

            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                completionHandlerForInstructions(ingredients : "", steps: "", error: NSError(domain: "completionHandlerForInstructions",  code: 1, userInfo: info))
                return
            }
          
            var firstElement : AnyObject!
            
                if  (parsedResult?.count ?? 0) > 0 {
                    firstElement = parsedResult[0]
                    
                }else{
                  
                    completionHandlerForInstructions(ingredients : "", steps: "", error: NSError(domain: "completionHandlerForInstructions",  code: 1, userInfo: info))
                    return
                }
           

            
            guard let results = firstElement else{
                completionHandlerForInstructions(ingredients : "", steps: "", error: NSError(domain: "completionHandlerForInstructions",  code: 1, userInfo: info))
                return
            }
                
            guard let sessionResult = results["steps"] as? [[String:AnyObject]] else {
                print(" See error code and message \(parsedResult)")
                completionHandlerForInstructions(ingredients : "", steps: "", error: NSError(domain: "completionHandlerForInstructions",  code: 1, userInfo: info))
                return
            }
            let numberOfSteps = sessionResult.count
            var count:Int = 0
            var ingredients :String = ""
            var instruction :String = ""
            for result in sessionResult {
                count += 1
                var s = "\n"
                s.appendContentsOf(String(result["number"] as! Int))
                s.appendContentsOf(".")
                s.appendContentsOf((result["step"] as? String)!)
                instruction.appendContentsOf(s)
                let ings = result["ingredients"] as? [AnyObject]
                for i in ings! {
                    ingredients.appendContentsOf((i["name"] as? String)!)
                    ingredients.appendContentsOf(",")
                }
                if(count == numberOfSteps){
                    completionHandlerForInstructions(ingredients: ingredients, steps: instruction, error: nil )
                }
                    
            }
        }
        task.resume()
    }
    
    
    func getImage(recipeImageURL:String, completionHandlerForSearchImage: (result: UIImage?, error: NSError?) -> Void){
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: recipeImageURL)
        let info = [NSLocalizedDescriptionKey : RecipeConstants.Messages.Failure]
        if(url == nil){
            completionHandlerForSearchImage(result: nil, error: NSError(domain: "completionHandlerForSearchImage", code: 1, userInfo: info))
            return
        }
        let request =  NSURLRequest(URL: url!)
        
        
        var image = UIImage(named: "noImage")
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
                if downloadError != nil {
                    print("Error downloading image for the recipe .ignore it")
                    completionHandlerForSearchImage(result: nil, error: NSError(domain: "completionHandlerForSearchImage", code: 1, userInfo: info))
                } else {
                    if let data = data {
                     image = UIImage(data: data)
                        completionHandlerForSearchImage(result: image, error: nil)
                    }
            }
        }
            
        task.resume()
    }
    
    //borrowed from http://stackoverflow.com/questions/31451798/new-generated-image-quality-is-low-ios-swift
    private func _resizeWithAspect_doResize(image: UIImage,size: CGSize)->UIImage{
        if UIScreen.mainScreen().respondsToSelector(#selector(NSDecimalNumberBehaviors.scale)){
            UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.mainScreen().scale);
        }
        else
        {
            UIGraphicsBeginImageContext(size);
        }
        
        image.drawInRect(CGRectMake(0, 0, size.width, size.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage
    {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSizeMake(newWidth, newHeight);
        
        return self._resizeWithAspect_doResize(image, size: newSize);
    }
    
    
    class func sharedInstance() -> RecipeUtil {
        struct Singleton {
            static var sharedInstance = RecipeUtil()
        }
        return Singleton.sharedInstance
    }

    
    struct TempKeys {
        static let goodRecipe  = "goodRecipe"
        static let goodRecipesIngredients = "goodRecipesIngredients"
        static let goodRecipesInstructions = "goodRecipesInstructions"
        static let image = "image"
        static let title = "title"
    }
    


}