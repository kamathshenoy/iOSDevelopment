//
//  AddLocationViewController.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 5/2/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//
import UIKit
import CoreLocation
import AddressBookUI


class AddLocationViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var debugTextLabel: UILabel!
    
    @IBOutlet weak var findButton: UIButton!

    @IBAction func findLocation(sender: AnyObject) {
        let location = addressTextField.text!
        guard location.characters.count > 0   else {
            print("address is nil")
            self.showAlertMsg(Constants.ErrorMsgs.AddressErrorMsg)
            return
        }
        findLocation(location)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    private func findLocation(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error)
                    self.showAlertMsg(Constants.ErrorMsgs.LocationErrorMsg)
                    return
                }
                if placemarks?.count > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark?.location
                    let coordinate = location?.coordinate
                     print("placemark coordinate",coordinate)
                    self.showDetailsScene(coordinate!, address: address)
                }else{
                   self.showAlertMsg(Constants.ErrorMsgs.AddressErrorMsg)
                }
            })
        }
    
    func showAlertMsg(msg:String)->Void {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        presentViewController(alert, animated: true, completion: nil)
        return
    }
    
    private func showDetailsScene(coordinates: CLLocationCoordinate2D, address: String){
      let resultVC = self.storyboard!.instantiateViewControllerWithIdentifier("ShowLocationViewController") as! ShowLocationViewController
        resultVC.coor = coordinates
        resultVC.address = address
        self.presentViewController(resultVC, animated: true, completion: nil)
    }
}


extension AddLocationViewController: UITextFieldDelegate {
    
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