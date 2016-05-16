//
//  UdacityClientStore.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 5/13/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation

class UdacityClientStore: NSObject {
    
    var key : String = ""
    var firstName : String = ""
    var lastName :String = ""
   

    init(key: String, fName: String, lName : String) {
        self.key = key
        firstName = fName
        lastName = lName
    }
}
