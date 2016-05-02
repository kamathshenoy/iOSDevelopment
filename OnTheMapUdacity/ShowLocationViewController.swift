//
//  ViewController.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 4/18/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//


import UIKit
import MapKit

class ShowLocationViewController: UIViewController {
    
    
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    //var myLocation = CLLocation(latitude: your_latitiude_value, longitude: your_longitude_value)
    var coor:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var address = ""
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
         
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    
    @IBAction func onSubmit(sender: AnyObject) {
        activityController.hidden = false
        activityController.startAnimating()
        let link = linkTextField.text!
        print("link",link)
        guard link.characters.count > 0   else {
            print("link is nil")
            self.showAlertErrorMsg(Constants.ErrorMsgs.AddLinkErrorMsg)
            return
        }
         textFieldShouldReturn(linkTextField)
        submit(link, address: address)
        self.activityController.stopAnimating()
        self.showAlertErrorMsg(Constants.ErrorMsgs.AddLinkSuccessMsg)

    }
    
    
    private func showNextScene() -> Void {
        print("next scene")
        dispatch_async(dispatch_get_main_queue()) {
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabViewController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
        

        
    }
    
    @IBAction func cancel(){
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    private func submit(link: String, address:String) {
        
        let request = NSMutableURLRequest(URL:MapUtility.sharedInstance().parseURLFromParameters([String:AnyObject](), withPathExtension: Constants.Student.StudentLocation))
        request.HTTPMethod = "POST"
        request.addValue(Constants.Student.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Student.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let username = "Mariane"//appDelegate.firstName

        let lastname = "lassy"//appDelegate.lastName
        let key = appDelegate.key
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let str = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(username)\", \"lastName\": \"\(lastname)\",\"mapString\": \"\(address)\", \"mediaURL\": \"\(link)\",\"latitude\": \(coor.latitude), \"longitude\": \(coor.longitude)}"
        request.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                self.showAlertErrorMsg("Error occured, Please try again!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                
                return
            }
            print("++++++++++")
            print(NSString(data: data, encoding: NSUTF8StringEncoding))

                     
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("++++++++++Could not parse the data as JSON: '\(data)'")
                self.showAlertErrorMsg("Error occured, Please try again!")
                return
            }
            
            print("=========================",parsedResult)
            
            guard let _ = parsedResult[Constants.Login.ObjectID] as? String else {
                print(" ++++++++See error code and message in \(parsedResult)")
                self.showAlertErrorMsg("Error occured, Please try again!")
                return
            }
            
                       // self.showNextScene()
            
           
        }
        task.resume()
    }
    
    
    func showAlertErrorMsg(errorMsg:String) ->Void{
        let alert = UIAlertController(title: "", message: errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    //    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //
    //        if control == annotationView.rightCalloutAccessoryView {
    //            let app = UIApplication.sharedApplication()
    //            app.openURL(NSURL(string: annotationView.annotation.subtitle))
    //        }
    //    }
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
