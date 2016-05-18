//
//  ViewController.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 4/18/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//


import UIKit
import MapKit

class ShowLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    var coor:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var address:String = ""
    var keyboardOnScreen = false
    
    @IBOutlet weak var linkTextField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textFieldShouldReturn(linkTextField)
        subscribeToNotification(UIKeyboardWillShowNotification, selector: Constants.Selectors.KeyboardWillShow)
        subscribeToNotification(UIKeyboardWillHideNotification, selector: Constants.Selectors.KeyboardWillHide)
        subscribeToNotification(UIKeyboardDidShowNotification, selector: Constants.Selectors.KeyboardDidShow)
        subscribeToNotification(UIKeyboardDidHideNotification, selector: Constants.Selectors.KeyboardDidHide)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coor
        
        self.mapView.addAnnotation(annotation)
        self.mapView.reloadInputViews()
        let region = MKCoordinateRegionMakeWithDistance(coor, 10000, 10000)
        
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    
    @IBAction func onSubmit(sender: AnyObject) {
       // activityController.hidden = false
        activityController.startAnimating()
        let link = linkTextField.text!
        
        guard link.characters.count > 0   else {
            
            self.showAlertErrorMsg(Constants.ErrorMsgs.AddLinkErrorMsg)
            return
        }
        textFieldShouldReturn(linkTextField)
        submit(link, address: address)
    }
    
    
    private func showNextScene() -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabViewController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
       
    @IBAction func cancel(){
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabViewController") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    private func submit(link: String, address:String) {
        MapUtility.sharedInstance().submitData(coor, link: link, address: address) { (data, error) in
            dispatch_async(dispatch_get_main_queue()){
                self.activityController.stopAnimating()
                if error != nil {
                    self.showAlertErrorMsg((error?.userInfo[NSLocalizedDescriptionKey])! as! String)
                    return
                }else{
                    //let appDelegate = MapUtility.sharedInstance().appDelegate
                   
                   /* let first =  appDelegate.udacityUserInformation?.firstName
                    let last = appDelegate.udacityUserInformation?.lastName
                    
                    let dict = [Constants.ParseResponseKeys.FirstName : first, Constants.ParseResponseKeys.LastName : last, Constants.ParseResponseKeys.MediaURL :link]
                    
                    appDelegate.studentLocations.append(StudentData(dictionary: dict))*/
                    StudentLocation.sharedInstance().removeAll()
                    
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabViewController") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    
    func showAlertErrorMsg(errorMsg:String) ->Void{
        let alert = UIAlertController(title: "", message: errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: {
            
        })
    }

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}



extension ShowLocationViewController: UITextFieldDelegate {
    
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
        resignIfFirstResponder(linkTextField)
    }
}

extension ShowLocationViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
