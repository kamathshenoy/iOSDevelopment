//
//  MapUtility.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 4/20/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapUtility: NSObject {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
 
    func getStudentLocations(completionHandlerForLocations: (result: [[String:AnyObject]]?, error: NSError?) -> Void) {
        
        /* . Make the request */
        dispatch_async(dispatch_get_main_queue()) {
            self.taskForGETData() { (results, error) in
            
            /* . Send the desired value(s) to completion handler */
                if let error = error {
                    completionHandlerForLocations(result: nil, error: error)
                } else {
                
                    if let results = results![Constants.ParseResponseKeys.Results] as? [[String:AnyObject]]! {
                    completionHandlerForLocations(result: results, error: nil)
                    } else {
                        completionHandlerForLocations(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                    }
                }
            }
        }
    }
    
    func populateStudentLocations(locations :[[String:AnyObject]]?, error: NSError?)->Void{
        if let locations = locations {
            for dictionary in locations {
                
                let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary["firstName"] as! String
                let last = dictionary["lastName"] as! String
                let mediaURL = dictionary["mediaURL"] as! String
                let fullName = "\(first) \(last)"
                
                let annotation = StudentLocation(coordinate: coordinate, fullName: (fullName), mediaURL: mediaURL)
                appDelegate.studentLocations.append(annotation)
                
            }
            print("studentlocaions", appDelegate.studentLocations.count)
        }else{
            print(error)
        }
    }
    
 
    
   func taskForGETData(completionHandlerForGET: (data: AnyObject?, error: NSError?) -> Void) -> NSURLSessionTask {
        let request = NSMutableURLRequest(URL:MapUtility.sharedInstance().parseURLFromParameters([String:AnyObject](), withPathExtension: Constants.Student.StudentLocation))
        
       // let request = NSMutableURLRequest(URL:  NSURL(string:filePath)!)
        request.addValue(Constants.Student.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Student.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
    
        /* 7. Start the request */
        task.resume()
    
        return task
    
    }
    
    
    func submitData(coor:CLLocationCoordinate2D, link: String, address:String, completionHandlerForSubmit: (data: AnyObject?, error: NSError?) -> Void) -> Void {
        let request = NSMutableURLRequest(URL:MapUtility.sharedInstance().parseURLFromParameters([String:AnyObject](), withPathExtension: Constants.Student.StudentLocation))
        request.HTTPMethod = "POST"
        request.addValue(Constants.Student.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Student.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let username = "Mariane"//appDelegate.firstName
        
        let lastname = "lassy"//appDelegate.lastName
        let key = appDelegate.key
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let str = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(username)\", \"lastName\": \"\(lastname)\",\"mapString\": \"\(address)\", \"mediaURL\": \"\(link)\",\"latitude\": \(coor.latitude), \"longitude\": \(coor.longitude)}"
        request.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                let info = [NSLocalizedDescriptionKey : "Error occured, Please try again!"]
                completionHandlerForSubmit(data: nil, error: NSError(domain: "completionHandlerForSubmit", code: 1, userInfo: info))
                
                return
            }
            
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print("++++++++++Could not parse the data as JSON: '\(data)'")
                let info = [NSLocalizedDescriptionKey : "Error occured, Please try again!"]
                completionHandlerForSubmit(data: nil, error: NSError(domain: "completionHandlerForSubmit", code: 1, userInfo: info))

                return
            }
            
            print("=========================",parsedResult)
            
            guard let objectID = parsedResult[Constants.Login.ObjectID] as? String else {
                print(" ++++++++See error code and message in \(parsedResult)")
                let info = [NSLocalizedDescriptionKey : "Error occured, Please try again!"]
                completionHandlerForSubmit(data: nil, error: NSError(domain: "completionHandlerForSubmit", code: 1, userInfo: info))
                return
            }
            
            completionHandlerForSubmit(data: objectID, error: nil)
        }
        task.resume()
        
    }
    
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            //print(parsedResult)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    
    
    func logoutUdacity(completionHandlerForLogout: (result: NSData?, error: NSError?) -> Void){
        let request = NSMutableURLRequest(URL:MapUtility.sharedInstance().udacityURLFromParameters([String:AnyObject](), withPathExtension: [Constants.Login.Session]))
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        //print(request.URL?.path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                let info = [NSLocalizedDescriptionKey : "Could not logout"]
                completionHandlerForLogout(result: nil, error: NSError(domain: "completionHandlerForLogout", code: 1, userInfo: info))
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            completionHandlerForLogout(result: newData, error: nil)
            
        }
        task.resume()
        
    }
    
    
    
    func loginUdacity(completionHandlerForLogin: (result: AnyObject?, error: NSError?) -> Void){
        
        let request = NSMutableURLRequest(URL:udacityURLFromParameters([String:AnyObject](), withPathExtension: [Constants.Login.Session]))
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let username = /*usernameTextField.text!*/"sheethal.shenoy@gmail.com"
        let password = /*passwordTextField.text!*/"Sriram123"
        let str = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        
        request.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                //self.showAlertMsg( "Username or Password not correct.")
                let info = [NSLocalizedDescriptionKey : "Username or Password not correct."]
                completionHandlerForLogin(result: nil, error: NSError(domain: "completionHandlerForLogin", code: 1, userInfo: info))
                return
                
            }
           
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let info = [NSLocalizedDescriptionKey : "Your request returned a status code other than 2xx."]
                completionHandlerForLogin(result: nil, error: NSError(domain: "completionHandlerForLogin", code: 1, userInfo: info))
                //self.showAlertMsg("Your request returned a status code other than 2xx")
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            print("parsedResult",parsedResult)
            
            
            guard let sessionResult = parsedResult[Constants.Login.Account] as? [String:AnyObject] else {
                print(" See error code and message \(parsedResult)")
                return
            }
            
            /* GUARD: Is userID "success" key in parsedResult? */
            guard let userid = sessionResult[Constants.Login.Key] as? String else {
                print("Cannot find key 'session id ")
                return
            }
            print("loginUdacity - NO ERROR")

            completionHandlerForLogin(result: userid, error: nil)
            
        }
        task.resume()
        
    }
    
    
    func getRequestTokenFromUdacity(completionHandlerForRequestToken: (result: AnyObject?, error: NSError?) -> Void){
        
        
        let request = NSMutableURLRequest(URL:MapUtility.sharedInstance().udacityURLFromParameters([String:AnyObject](), withPathExtension: [Constants.Login.Userdata,(appDelegate.key) ]))
        print("self.appDelegate.key",appDelegate.key)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                let info = [NSLocalizedDescriptionKey : "Unable to get userdata."]
                completionHandlerForRequestToken(result: nil, error: NSError(domain: "completionHandlerForRequestToken", code: 1, userInfo: info))
                return
            }
           
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let info = [NSLocalizedDescriptionKey : "Check you network. Recieved an status code other than 2xx."]
                completionHandlerForRequestToken(result: nil, error: NSError(domain: "completionHandlerForRequestToken", code: 1, userInfo: info))
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            guard let user = parsedResult[Constants.Login.user] as? [String:AnyObject] else {
                print(" Can't find the user in \(parsedResult)")
                return
            }
            
            guard let firstName = user[Constants.Login.FirstName] as? String else {
                print(" Can't find the firstname in \(parsedResult)")
                return
            }
            
            /* GUARD: Is firstName "success" key in parsedResult? */
            guard let lastName = user[Constants.Login.LastName] as? String else {
                print(" Can't find the lastname in \(parsedResult)")
                return
            }
            print("getRequestTokenFromUdacity - NO ERROR")
            
            completionHandlerForRequestToken(result: [firstName,lastName], error: nil)
        }
        task.resume()
        
    }

    

    // create a URL from parameters
     func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: [String]? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Login.ApiScheme
        components.host = Constants.Login.ApiHost
       // print("++++++", components.URL)

        var path = Constants.Login.ApiPath
        for (extn) in withPathExtension! {
            path = path + "/"+extn ?? ""
        }
        components.path = path//Constants.Login.ApiPath + (withPathExtension[0] ?? "")
        print("===========", components.path)
        print("===========", components.URL)
        return components.URL!
    }
    
    
    // create a URL from parameters
    func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Student.ApiScheme
        components.host = Constants.Student.ApiHost
        components.path = Constants.Student.ApiPath + (withPathExtension ?? "")
        print("=======parse===", components.URL)
        return components.URL!
    }

    


    class func sharedInstance() -> MapUtility {
        struct Singleton {
            static var sharedInstance = MapUtility()
        }
        return Singleton.sharedInstance
    }
}

