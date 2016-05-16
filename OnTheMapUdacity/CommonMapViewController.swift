//
//  CommonMapViewController.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 5/2/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import UIKit
class CommonMapViewController:  UIViewController{
    @IBAction func addLocation(){
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddLocationViewController")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func logout() {
       /// self.dismissViewControllerAnimated(false, completion: nil)
        self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
        
        MapUtility.sharedInstance().logoutUdacity() { (data, error) in
            if error != nil { // Handle error…
                return
            }
            if data != nil {
                print("LOGGED OUT")
            }
        }
    }
    
    func showAlertMsg(msg:String)->Void {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
        return
    }
    
}
