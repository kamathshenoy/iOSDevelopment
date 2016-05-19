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
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
 
    func getStudentLocations(completionHandlerForLocations: (result: [[String:AnyObject]]?, error: NSError?) -> Void) {
        
        /* . Make the request */
        dispatch_async(dispatch_get_main_queue()) {
            self.taskForGETData() { (results, error) in
            
            /* . Send the desired value(s) to completion handler */
                if let _ = error {
                    completionHandlerForLocations(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: error?.userInfo))
                } else {
                
                    if let results = results![Constants.ParseResponseKeys.Results] as? [[String:AnyObject]]! {
                       
                        completionHandlerForLocations(result: results, error: nil)
                    } else {
                        
                        completionHandlerForLocations(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: error?.userInfo))
                    }
                }
            }
        }
    }
    
    
   func taskForGETData(completionHandlerForGET: (data: AnyObject?, error: NSError?) -> Void) -> NSURLSessionTask {
    
        let methodParameters = [
        Constants.APIHEADERANDKEYS.Order_Key : Constants.APIHEADERANDKEYS.UpdatedAt_Value]
    
        let request = NSMutableURLRequest(URL:MapUtility.sharedInstance().parseURLFromParameters(methodParameters, withPathExtension: [Constants.Student.StudentLocation]))
    
        request.addValue(Constants.APIHEADERANDKEYS.ApplicationID_Key, forHTTPHeaderField: Constants.APIHEADERANDKEYS.ApplicationID_HeaderField)
        request.addValue(Constants.APIHEADERANDKEYS.RestAPI_Key, forHTTPHeaderField: Constants.APIHEADERANDKEYS.RestAPIKey_HeaderField)
    
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandlerForGET(data: nil, error: NSError(domain: "taskForGETData ", code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.ErrorMsgs.NetworkErrorMsg]))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerForGET(data: nil, error: NSError(domain: "taskForGETData ", code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.ErrorMsgs.NetworkErrorMsg]))
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
        let request = NSMutableURLRequest(URL:MapUtility.sharedInstance().parseURLFromParameters([String:AnyObject](), withPathExtension: [Constants.Student.StudentLocation]))
        request.HTTPMethod = "POST"
        request.addValue(Constants.APIHEADERANDKEYS.ApplicationID_Key, forHTTPHeaderField: Constants.APIHEADERANDKEYS.ApplicationID_HeaderField)
        request.addValue(Constants.APIHEADERANDKEYS.RestAPI_Key, forHTTPHeaderField: Constants.APIHEADERANDKEYS.RestAPIKey_HeaderField)
        
        let username = appDelegate.udacityUserInformation?.firstName
        let lastname = appDelegate.udacityUserInformation?.lastName
        let key = appDelegate.udacityUserInformation?.key
        print("key ",key!," fname", username!, "lname", lastname!)
       //  username = "Jessica"//appDelegate.udacityUserInformation?.firstName
        // lastname = "Alba"//appDelegate.udacityUserInformation?.lastName
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let str = "{\"uniqueKey\": \"\(key!)\", \"firstName\": \"\(username!)\", \"lastName\": \"\(lastname!)\",\"mapString\": \"\(address)\", \"mediaURL\": \"\(link)\",\"latitude\": \(coor.latitude), \"longitude\": \(coor.longitude)}"
        print(str)
        request.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.NetworkErrorMsg]
                completionHandlerForSubmit(data: nil, error: NSError(domain: "completionHandlerForSubmit", code: 1, userInfo: info))
                
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.SubmitLinkErrorMsg]
                completionHandlerForSubmit(data: nil, error: NSError(domain: "completionHandlerForSubmit", code: 1, userInfo: info))

                return
            }
            
            guard let objectID = parsedResult[Constants.Login.ObjectID] as? String else {
                print(" See error code and message in \(parsedResult)")
                let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.SubmitLinkErrorMsg]
                completionHandlerForSubmit(data: nil, error: NSError(domain: "completionHandlerForSubmit", code: 1, userInfo: info))
                return
            }
            
            completionHandlerForSubmit(data: objectID, error: nil)
        }
        task.resume()
        
    }
    
    
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
    
    
    func validateUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    
    func loginUdacity(username:String, password:String, completionHandlerForLogin: (result: AnyObject?, error: NSError?) -> Void){
        
        let request = NSMutableURLRequest(URL:udacityURLFromParameters([String:AnyObject](), withPathExtension: [Constants.Login.Session]))
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let str = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        request.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                /*if error!.domain == NSURLErrorDomain && error!.code == NSURLErrorNotConnectedToInternet {
                    let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.ConnectivityrrorMsg]
                    completionHandlerForLogin(result: nil, error: NSError(domain: "completionHandlerForLogin",  code: 1, userInfo: info))
                    return
                }else{*/
                print("NO INTERNET CONNECTION")
                    let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.NetworkErrorMsg]
                    completionHandlerForLogin(result: nil, error: NSError(domain: "completionHandlerForLogin",  code: 1, userInfo: info))
                    return
               // }
                
            }
           
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.LoginErrorMsg]
                completionHandlerForLogin(result: nil, error: NSError(domain: "completionHandlerForLogin", code: 1, userInfo: info))
                
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
            
            guard let sessionResult = parsedResult[Constants.Login.Account] as? [String:AnyObject] else {
                print(" See error code and message \(parsedResult)")
                completionHandlerForLogin(result: nil, error: NSError(domain: "taskForGETData ", code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.ErrorMsgs.LoginErrorMsg]))
                return
            }
            
            /* GUARD: Is userID "success" key in parsedResult? */
            guard let userid = sessionResult[Constants.Login.Key] as? String else {
                print("Cannot find key 'session id ")
                completionHandlerForLogin(result: nil, error: NSError(domain: "taskForGETData ", code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.ErrorMsgs.LoginErrorMsg]))
                return
            }
            completionHandlerForLogin(result: userid, error: nil)
            
        }
        task.resume()
        
    }
    
    func convertStudentDataIntoAnnotation(data:[StudentData]) ->  [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for element in data {
            let annotation = MKPointAnnotation()
            annotation.coordinate = element.getCoordinates()
            annotation.title = element.getFullname()
            annotation.subtitle = element.getMediaURL()
            annotations.append(annotation)
        }
        print("annotations.size",annotations.count)
        return annotations
    }
    
    //I understand that I have over engineered this method here. It could just return an array of String(like was mentioned in the code review). I was trying to get myself some practice with Closures(they are not easy!). I guess I have used Closures everwhere very liberally  and in some places, like this, it was unnecessary ! But on the brighter side, I feel little comfortable with Closures now.
    func getRequestTokenFromUdacity(key: String, completionHandlerForRequestToken: (result: AnyObject?, error: NSError?) -> Void){
        
        let request = NSMutableURLRequest(URL:MapUtility.sharedInstance().udacityURLFromParameters([String:AnyObject](), withPathExtension: [Constants.Login.Userdata, key]))
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.NetworkErrorMsg]
                completionHandlerForRequestToken(result: nil, error: NSError(domain: "completionHandlerForRequestToken", code: 1, userInfo: info))
                return
            }
           
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.NetworkErrorMsg]
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
                let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.LoginErrorMsg]
                completionHandlerForRequestToken(result: nil, error: NSError(domain: "completionHandlerForRequestToken", code: 1, userInfo: info))
                return
            }
            
            guard let firstName = user[Constants.Login.FirstName] as? String else {
                print(" Can't find the firstname in \(parsedResult)")
                let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.LoginErrorMsg]
                completionHandlerForRequestToken(result: nil, error: NSError(domain: "completionHandlerForRequestToken", code: 1, userInfo: info))
                return
            }
            
            /* GUARD: Is firstName "success" key in parsedResult? */
            guard let lastName = user[Constants.Login.LastName] as? String else {
                print(" Can't find the lastname in \(parsedResult)")
                let info = [NSLocalizedDescriptionKey : Constants.ErrorMsgs.LoginErrorMsg]
                completionHandlerForRequestToken(result: nil, error: NSError(domain: "completionHandlerForRequestToken", code: 1, userInfo: info))
                return
            }
            completionHandlerForRequestToken(result: [firstName,lastName], error: nil)
        }
        task.resume()
        
    }

    

    // create a URL from parameters
     func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: [String]? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Login.ApiScheme
        components.host = Constants.Login.ApiHost
        var path = Constants.Login.ApiPath
        for (extn) in withPathExtension! {
            path = path + "/"+extn ?? ""
        }
        components.path = path
       
        return components.URL!
    }
    
    
    // create a URL from parameters
    func parseURLFromParameters(parameters: [String:AnyObject],  withPathExtension: [String]? = nil) -> NSURL {
        let components = NSURLComponents()
        components.scheme = Constants.Student.ApiScheme
        components.host = Constants.Student.ApiHost
        var path = Constants.Student.ApiPath //+ (withPathExtension ?? "")
        for (extn) in withPathExtension! {
            path = path + "/"+extn ?? ""
        }
        components.path = path
        
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }

       
        return components.URL!
    }

    class func sharedInstance() -> MapUtility {
        struct Singleton {
            static var sharedInstance = MapUtility()
        }
        return Singleton.sharedInstance
    }
}

