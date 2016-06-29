//
//  FlickrUtility.swift
//  VirtualTourist
//
//  Created by Sheethal Shenoy on 6/14/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import UIKit



class FlickrUtility: NSObject {
    
   
    var session : NSURLSession
    var totalPages : Int?
    
    // Create reference to a sharedContext for dealing with Core Data managed objects
    lazy var sharedContext = {
        CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    // Create a shared session to use when making calls
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // Get the number of pages of results for our Flickr ArgumentValues location
    func getPageCount(latitude: String, longitude: String, completionHandler: (success: Bool, result : Int?) -> Void) {
        
        // Compile necessary info, create our url, and create the request
        let methodParameters = getMethodArguments(latitude, longitude: longitude)
        let urlString = FlickrConstants.ArgumentValues.BASE_URL + escapedParameters(methodParameters)
        let request = NSURLRequest(URL: NSURL(string: urlString)!)

        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                print(error!.description)
                return
            }
            
            guard let data = data else {
                print("No data reiceved")
                return
            }
            self.parseJSON(data) { (parsedData, parsedError) in
                if parsedError != nil {
                    completionHandler(success:false, result: nil)
                    return
                }
                guard let parsedData = parsedData else {
                    print("No data recieved")
                    return
                }
               
                if let photosDictionary = parsedData.valueForKey("photos") as? [String: AnyObject] {
                    if let totalPages = photosDictionary["pages"] as? Int {
                        print("totalpages", totalPages)
                        completionHandler(success: true, result: totalPages)
                    }
                }
            }
        }
        task.resume()
        
    }
    
    // Use the page number to refine our Flickr ArgumentValues and get back the number of photos we need
    func getPhotosForPage(latitude: String, longitude: String, pageNumber:Int, completionHandler: (success: Bool, result : [[String:AnyObject]]?) -> Void) {
        
        var parameters = getMethodArguments(latitude, longitude: longitude)
        parameters[FlickrConstants.ArgumentNames.PAGE_NUMBER] = pageNumber
        parameters[FlickrConstants.ArgumentNames.PHOTOS_PER_PAGE] = FlickrConstants.ArgumentValues.PHOTOS_PER_PAGE
        let urlString = FlickrConstants.ArgumentValues.BASE_URL + escapedParameters(parameters)
        print("pageNumber",pageNumber)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                print(error!.description)
                return
            }
            
            guard let data = data else {
                print("No data reiceved")
                return
            }
            
            self.parseJSON(data) { (parsedData, parsedError) in
                if parsedError != nil {
                        completionHandler(success:false, result : nil)
                        
                }
                guard let parsedData = parsedData else {
                    print("No data recieved")
                    return
                }
                if let photosDictionary = parsedData.valueForKey("photos") as? [String: AnyObject] {
                        if let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] {
                            print("photosArray length",photosArray.count)
                            if(photosArray.count > 0){
                                completionHandler(success: true, result: photosArray)
                            }else{
                                completionHandler(success: false, result: nil)
                            }
                        }else {
                            completionHandler(success: false, result: nil)
                        }
                }
            }
        }
        task.resume()
    }
    
    
    
    func getMethodArguments(latitude: String?, longitude: String?) -> [String: AnyObject]{
        
        let methodArguments = [
            FlickrConstants.ArgumentNames.METHOD_NAME : FlickrConstants.ArgumentValues.METHOD_NAME,
            FlickrConstants.ArgumentNames.API_KEY : FlickrConstants.ArgumentValues.API_KEY,
            FlickrConstants.ArgumentNames.SAFE_SEARCH : FlickrConstants.ArgumentValues.SAFE_SEARCH,
            FlickrConstants.ArgumentNames.EXTRAS : FlickrConstants.ArgumentValues.EXTRAS,
            FlickrConstants.ArgumentNames.DATA_FORMAT : FlickrConstants.ArgumentValues.DATA_FORMAT,
            FlickrConstants.ArgumentNames.NO_JSON_CALLBACK : FlickrConstants.ArgumentValues.NO_JSON_CALLBACK,
            FlickrConstants.ArgumentNames.RADIUS_UNITS : FlickrConstants.ArgumentValues.RADIUS_UNITS,
            FlickrConstants.ArgumentNames.RADIUS : FlickrConstants.ArgumentValues.RADIUS,
            FlickrConstants.ArgumentNames.LATITUDE : latitude!,
            FlickrConstants.ArgumentNames.LONGITUDE : longitude!
        ]
        return methodArguments as! [String : AnyObject]
    }
    
    
    func parseJSON(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error {
            parsingError = error as? NSError
            parsedResult = nil
        }
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    /* Borrowed from another project/website  */
     /*http://stackoverflow.com/questions/31103358/could-not-find-member-init-in-a-dictionary-extension */
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        for (key, value) in parameters {
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    func getPhotosForPin(pin : Pin, completionHandler :(success:Bool) ->Void) {
        
        let latitude = pin.latitude!.stringValue
        let longitude = pin.longitude!.stringValue
        
        if(pin.pintoPhoto == nil || pin.pintoPhoto!.count == 0) {
            print("getting photos from flickr")
            FlickrUtility.sharedInstance().getPageCount(latitude, longitude: longitude) {
                
                (success: Bool, totalPages: Int?) in
                
                if success {
                    print(" totalPages",totalPages)
                    pin.totalPages = totalPages
                
                    if totalPages == 0 {
                        completionHandler(success:false)
                    }else{
                        pin.currentPage = 1
                        self.getPhotos(latitude, longitude: longitude, pageNumber: 1, pin: pin) { success in
                                if !success{
                                    print("Failed to get totalPages. Showing an error message on screen")
                                }
                                completionHandler(success:success)
                            }
                    }
                }else{
                    print("Failed to get totalPages")
                    completionHandler(success:success)
                }
                
            }
        } else {
            print("Photos array contains existing photos", pin.pintoPhoto!.count)
        }
        
    }
    
    
    func getPhotos(latitude:String, longitude:String, pageNumber:Int, pin:Pin,completionHandler :(success:Bool) ->Void){
        
        FlickrUtility.sharedInstance().getPhotosForPage(latitude, longitude: longitude, pageNumber: pageNumber) {
            
            (success: Bool, result : [[String: AnyObject]]?) in
            
            if success {
                print("Success in getting photos")
                let photosDictionaries = result!
                 _ = photosDictionaries.map() {
                    
                    (dictionary: [String : AnyObject]) -> Photo in
                        let photo = Photo(dictionary: dictionary, context: self.sharedContext)
                        photo.photoToPin = pin
                        self.getPhotoImageForPin(photo){success, data in
                            
                            guard let data = data else {
                                print("No data reiceved")
                                return
                            }
                            
                            let image = UIImage(data: data)
                            
                            photo.image =  UIImagePNGRepresentation(image!)
                           

                    }
                    return photo
                }
                
                CoreDataStackManager.sharedInstance().saveContext()
                completionHandler(success:true)
            }else {
                print("No photos to get!")
                completionHandler(success:false)
            }
        }
    }
    
    
    // Called to download the photo image after we create our photo object
    func getPhotoImageForPin(imageForDownload: Photo, completionHandler: (success: Bool, data: NSData?) -> Void) -> NSURLSessionDataTask {
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: imageForDownload.url_m!)
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if downloadError != nil {
                print("Error downloading image for the pin")
                completionHandler(success: false, data: nil)
            } else {
                if let data = data {
                    completionHandler(success: true, data: data)
                }
            }
        }
        task.resume()
        return task
    }

    
    
    // Create global instance of FlickrUtility to use throughout Virtual Tourist
    class func sharedInstance() -> FlickrUtility {
        struct Singleton {
            static var sharedInstance = FlickrUtility()
        }
        return Singleton.sharedInstance
    }
    
}
