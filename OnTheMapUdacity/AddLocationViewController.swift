//
//  LoginViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
// MARK: - AddLocationViewController: UIViewController

class AddLocationViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    // MARK: Outvars
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var debugTextLabel: UILabel!
    
    
    @IBOutlet weak var findButton: UIButton!
    

    @IBAction func findLocation(sender: AnyObject) {
        print("-------------",addressTextField)
        if(addressTextField == nil){
            let alert = UIAlertController(title: "", message: "Please enter the location", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            findLocation(addressTextField.text!)
        }
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        print("cancel")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        setUIEnabled(true)
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: Constants.Selectors.KeyboardWillShow)
        subscribeToNotification(UIKeyboardWillHideNotification, selector: Constants.Selectors.KeyboardWillHide)
        subscribeToNotification(UIKeyboardDidShowNotification, selector: Constants.Selectors.KeyboardDidShow)
        subscribeToNotification(UIKeyboardDidHideNotification, selector: Constants.Selectors.KeyboardDidHide)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    func performUIUpdatesOnMain(updates: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            updates()
        }
    }
    
    
    // MARK: TheMovieDB
    
    private func findLocation(address: String) {
        print("-------------",address)
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error)
                    return
                }
                if placemarks?.count > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark?.location
                    let coordinate = location?.coordinate
                    print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                    
                    self.showDetailsScene(coordinate!.latitude, long: coordinate!.longitude, address: address)
                }
            })
        }
    
    private func showDetailsScene(lat: CLLocationDegrees, long: CLLocationDegrees, address: String){
       /* let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ShowLocationViewController")
        controller.
        self.presentViewController(controller, animated: true, completion: nil)*/
        
      let resultVC = self.storyboard!.instantiateViewControllerWithIdentifier("ShowLocationViewController") as! ShowLocationViewController
        
        // Communicate the match
        resultVC.lat = lat
        resultVC.long = long
        resultVC.address = address
        print("push the next controller")
        self.presentViewController(resultVC, animated: true, completion: nil)
        
    }
}



extension AddLocationViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(addressTextField)
    }
}

// MARK: - LoginViewController (Configure UI)

extension AddLocationViewController {
    
    private func setUIEnabled(enabled: Bool) {
        addressTextField.enabled = enabled
        
        findButton.enabled = enabled
        debugTextLabel.text = ""
     
        
        // adjust login button alpha
        if enabled {
            findButton.alpha = 1.0
        } else {
            findButton.alpha = 0.5
        }
    }
}


extension AddLocationViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}