//
//  StudentLocation.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 4/25/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation


class StudentLocation:  NSObject {
    private var studentData = [StudentData]()
    
    
    func setStudentData(data:[StudentData]) ->Void {
        studentData = data
    }
    
    
    func getStudentData() ->[StudentData] {
        return studentData
    }
    
    func removeAll() ->Void {
        studentData.removeAll()
    }
    
    class func sharedInstance() -> StudentLocation {
        struct Singleton {
            static var sharedInstance = StudentLocation()
        }
        return Singleton.sharedInstance
    }

}