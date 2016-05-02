//
//  ViewController.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 4/18/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//


import UIKit
import MapKit

class MapViewController: CommonMapViewController, MKMapViewDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var mapView: MKMapView!
   
    //let iExists :Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.studentLocations.removeAll()
        MapUtility.sharedInstance().getStudentLocations { (locations, error) in
            MapUtility.sharedInstance().populateStudentLocations(locations, error: error)
            self.mapView.addAnnotations(self.appDelegate.studentLocations)
            
        }
    }
    
    
    func reloadView() ->Void {
        print("reloadTable")
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.reloadInputViews()
        }
    }

    
    @IBAction func refresh(sender: AnyObject) {
        appDelegate.studentLocations.removeAll()
        MapUtility.sharedInstance().getStudentLocations { (locations, error) in
            MapUtility.sharedInstance().populateStudentLocations(locations, error: error)
            self.reloadView()
            
        }
    }
    /*
    
    @IBAction func addLocation(){
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddLocationViewController")
            self.presentViewController(controller, animated: true, completion: nil)
    }

    @IBAction func logout() {
         MapUtility.sharedInstance().logoutUdacity() { (data, error) in
            
            if error != nil { // Handle error…
                self.showAlertMsg(Constants.ErrorMsgs.LogoutErrorMsg)
                return
            }
            
            if data != nil {
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
        }
    }

    
    func showAlertMsg(msg:String)->Void {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
        return
    }
    */
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            print("=========1")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            print("=========2")
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
    
    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.
    }

