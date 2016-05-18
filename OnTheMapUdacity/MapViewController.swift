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

    var appDelegate = MapUtility.sharedInstance().appDelegate
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocations()
        mapView.addAnnotations(annotations)
    }
    
    private func getStudentLocations(){
        
        MapUtility.sharedInstance().getStudentLocations { (locations, error) in
            if error == nil {
                StudentLocation.sharedInstance().setStudentData(StudentData.studentsFromResults(locations!))
                self.annotations = MapUtility.sharedInstance().convertStudentDataIntoAnnotation(StudentLocation.sharedInstance().getStudentData())
                 self.reloadView()
            }else{
                dispatch_async(dispatch_get_main_queue()){
                    self.showAlertMsg((error?.userInfo[NSLocalizedDescriptionKey])! as! String)
                    return
                }
            }
        }
    }
    

    
    override func viewWillAppear(animated: Bool) {
        //get fresh data if coming back to this scene aftre posting location
        print("StudentLocation.sharedInstance().getStudentData().count",StudentLocation.sharedInstance().getStudentData().count)
        if(StudentLocation.sharedInstance().getStudentData().count == 0){
            mapView.removeAnnotations(annotations)
            //print("get student locs")
            getStudentLocations()
            
        }
        
    }
    
    func reloadView() ->Void {
        print("reloadTable")
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.addAnnotations(self.annotations)
            self.mapView.reloadInputViews()
        }
    }

    
    @IBAction func refresh(sender: AnyObject) {
        
        mapView.removeAnnotations(annotations)
        StudentLocation.sharedInstance().removeAll()
        getStudentLocations()
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

    


