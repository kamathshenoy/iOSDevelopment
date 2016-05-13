//
//  StudentLocation.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 4/25/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import MapKit

class StudentLocation:  MKPointAnnotation {
    let coordinates: CLLocationCoordinate2D
    let fullName: String
  
    let mediaURL: String
    
    init(coordinate: CLLocationCoordinate2D, fullName: String, mediaURL : String) {
        self.coordinates = coordinate
        self.fullName = fullName
        self.mediaURL = mediaURL
    }
}