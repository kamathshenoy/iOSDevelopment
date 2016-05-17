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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        mapView.removeAnnotations(self.appDelegate.studentLocations)

        mapView.addAnnotations(self.appDelegate.studentLocations)
        reloadView() 
    }
    
    func reloadView() ->Void {
        print("reloadTable")
        dispatch_async(dispatch_get_main_queue()) {
            
            self.mapView.reloadInputViews()
        }
    }

    
    @IBAction func refresh(sender: AnyObject) {
        
        mapView.removeAnnotations(self.appDelegate.studentLocations)
        appDelegate.studentLocations.removeAll()
        MapUtility.sharedInstance().getStudentLocations { (locations, error) in
            if error == nil {
                MapUtility.sharedInstance().populateStudentLocations(locations, error: error)
                self.mapView.addAnnotations(self.appDelegate.studentLocations)
                self.reloadView()
            }else{
                self.showAlertMsg("Unable to refresh data. Try again!")
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            let button = UIButton(type: .DetailDisclosure)
            pinView!.rightCalloutAccessoryView = button
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let toOpen = view.annotation?.subtitle!
            
            if MapUtility.sharedInstance().validateUrl(toOpen) {
                UIApplication.sharedApplication().openURL(NSURL(string: toOpen!)!)
            } else {
                showAlertMsg(Constants.ErrorMsgs.URLErrorMsg)
            }
        }
    }
    
}

    


