//
//  StudentData.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 5/17/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import MapKit

struct StudentData {
        
    private let coordinates: CLLocationCoordinate2D
    private let fullName: String
    private let mediaURL: String
    
    // MARK: Initializers
    
    private init(dictionary: [String:AnyObject]) {
        
        let lat = CLLocationDegrees(dictionary[Constants.ParseResponseKeys.Latitude] as! Double)
        let long = CLLocationDegrees(dictionary[Constants.ParseResponseKeys.Longitude] as! Double)
        coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let first = dictionary[Constants.ParseResponseKeys.FirstName] as! String
        let last = dictionary[Constants.ParseResponseKeys.LastName] as! String
        fullName =  "\(first) \(last)"
        mediaURL = dictionary[Constants.ParseResponseKeys.MediaURL] as! String
    }
    

    
    func getCoordinates() -> CLLocationCoordinate2D {
        return coordinates
    }
    
    func getFullname() ->String {
        return fullName
    }
    
    func getMediaURL() ->String {
        return mediaURL
    }
    
    static func studentsFromResults(results: [[String:AnyObject]]) -> [StudentData] {
    
        var studentloc = [StudentData]()
    
        for result in results {
            studentloc.append(StudentData(dictionary: result))
        }
    
        return studentloc
    }

}