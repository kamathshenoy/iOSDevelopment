//
//  Constants.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 4/18/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import UIKit

// MARK: - Constants

struct Constants {
    
    
    struct Login {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let Userdata = "users"
        static let Session = "session"
        static let Registered = "registered"
        static let Key = "key"
        static let Account = "account"
        static let ID = "id"
        static let ObjectID = "objectId"
        static let user = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let UdacitySignUp = "https://www.udacity.com/account/auth#!/signup"
    }
    
    struct  ErrorMsgs {
        static let LogoutErrorMsg = "Unable to logout, please try again!"
        static let AddressErrorMsg = "Please enter a valid location."
        static let FacebookError = "Feature not implemented. Please upgrade to next version!"
        static let AddLinkErrorMsg = "Please enter a valid link."
        static let SubmitLinkErrorMsg = "Your request could not be fulfilled. Please try again."
        static let LoginErrorMsg = "Username or Password incorrect. Unable to login!"
    
        static let LocationErrorMsg = "Unable to find the location. Please check your internet connectivity."
        static let ReloadErrorMsg = "Unable to refresh data. Try again!"
        static let URLErrorMsg = "Invalid URL. Try some other URL!"
        static let NetworkErrorMsg = "Unable to connect to the internet. Please fix the issue and try again! "
        static let StudentLocationError = "Unable to fetch student location information. Please refresh"
    }
    
    struct Student {
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes"
        static let StudentLocation = "StudentLocation"
    }
    
    struct APIHEADERANDKEYS {
        static let ApplicationID_HeaderField = "X-Parse-Application-Id"
        static let RestAPIKey_HeaderField = "X-Parse-REST-API-Key"
        static let ApplicationID_Key = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPI_Key = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let Order_Key = "order"
        static let UpdatedAt_Value = "-updatedAt"
    }
    
    struct StudentLocation {
        static let CreatedAt =  "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
    
    //Response Keys
    struct ParseResponseKeys {
        static let Results = "results"
        static let Coordinates = "Coordinates"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let LastName = "lastName"
        static let FirstName = "firstName"

        static let MediaURL = "mediaURL"
        static let Fullname = "Fullname"
    }
    
    // MARK: UI
    struct UI {
        static let LoginColorTop = UIColor(red: 245/255, green: 139/255, blue: 86/255, alpha: 1.0).CGColor
        static let LoginColorBottom = UIColor(red: 247/255, green: 86/255, blue: 5/255, alpha: 1.0).CGColor
        static let GreyColor = UIColor(red: 247/255, green: 173/255, blue: 136/255, alpha:1.0)
        static let BlueColor = UIColor(red: 36/255, green:13/255, blue:1/255, alpha: 1.0)
    }
    
    // MARK: Selectors
    struct Selectors {
        static let KeyboardWillShow: Selector = "keyboardWillShow:"
        static let KeyboardWillHide: Selector = "keyboardWillHide:"
        static let KeyboardDidShow: Selector = "keyboardDidShow:"
        static let KeyboardDidHide: Selector = "keyboardDidHide:"
    }
}