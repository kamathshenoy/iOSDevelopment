//
//  Constants.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - Constants

struct Constants {
    
    
    struct Login {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        //static let loginURL = "https://www.udacity.com/api/"
        //static let UserData = "https://www.udacity.com/api/users/"
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
        

    }
    
    struct  ErrorMsgs {
        static let LogoutErrorMsg = "Unable to logout, please try again!"
        static let AddressErrorMsg = "Please enter a valid location."
        static let FacebookError = "Feature not implemented. Please upgrade to next version!"
        static let AddLinkErrorMsg = "Please enter a valid link."
        static let AddLinkSuccessMsg = "Your post was successful."
    }
    
    struct Student {
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes/"
        static let StudentLocation = "StudentLocation"
        //        static let StudentsURL = "https://api.parse.com/1/classes/StudentLocation"
        
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
     
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
    
    
    // MARK: TMDB Parameter Keys
    struct TMDBParameterKeys {
        static let ApiKey = "api_key"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: TMDB Parameter Values
    struct TMDBParameterValues {
        static let ApiKey = "c59caf3dda17a95e037c70739ec2a847"
    }
    
    // MARK: TMDB Response Keys
    struct ParseResponseKeys {
        static let Title = "title"
        static let ID = "id"
        static let PosterPath = "poster_path"
        static let StatusCode = "status_code"
        static let StatusMessage = "status_message"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Success = "success"
        static let UserID = "id"
        static let Results = "results"
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