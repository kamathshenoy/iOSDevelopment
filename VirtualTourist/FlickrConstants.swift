//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by Sheethal Shenoy on 6/14/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation


class FlickrConstants {
    
        
        struct ArgumentValues {
            static let BASE_URL : String = "https://api.flickr.com/services/rest/"
            static let METHOD_NAME : String = "flickr.photos.search"
            static let API_KEY : String = "2524eab2d3e1f09dc6a9a88097e3cbe3"
            
            static let EXTRAS  = "url_m"
            static let SAFE_SEARCH  = "1"
            static let DATA_FORMAT = "json"
            static let NO_JSON_CALLBACK  = "1"
            static let PHOTOS_PER_PAGE  = "12"
            static let RADIUS  = 1.0
            static let RADIUS_UNITS = "km"
            
            
        }
        
        struct ArgumentNames {
            static let METHOD_NAME = "method"
            static let API_KEY = "api_key"
            static let SAFE_SEARCH = "safe_search"
            static let EXTRAS = "extras"
            static let DATA_FORMAT = "format"
            static let NO_JSON_CALLBACK = "nojsoncallback"
            static let PAGE_NUMBER = "page"
            static let PHOTOS_PER_PAGE = "per_page"
            static let RADIUS_UNITS = "radius_units"
            static let RADIUS = "radius"
            static let LATITUDE = "lat"
            static let LONGITUDE  = "lon"
            
        }
        
    
}