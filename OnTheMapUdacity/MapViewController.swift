//
//  ViewController.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 4/18/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//


import UIKit
import MapKit

class MapViewController: UIViewController {

    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
   
    let iExists :Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        MapUtility.sharedInstance().getStudentLocations { (locations, error) in
            if let locations = locations {
                
               // var annotations = [MKAnnotation]()
                
                // The "locations" array is loaded with the sample data below. We are using the dictionaries
                // to create map annotations. This would be more stylish if the dictionaries were being
                // used to create custom structs. Perhaps StudentLocation structs.
                
                for dictionary in locations {
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                    let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = dictionary["firstName"] as! String
                    let last = dictionary["lastName"] as! String
                    let mediaURL = dictionary["mediaURL"] as! String
                    let fullName = "\(first) \(last)"
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = StudentLocation(coordinate: coordinate, fullName: (fullName), mediaURL: mediaURL)
                    appDelegate.studentLocations.append(annotation)
                    //annotations.append(annotation)
                }
                
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(appDelegate.studentLocations)
                
            } else {
                print(error)
            }
        }

        }
    
    func handleCancel(alertView: UIAlertAction!)
    {
        print("User click cancel button")
    }
    
    @IBAction func addLocation(){
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddLocationViewController")
            self.presentViewController(controller, animated: true, completion: nil)
    }

    @IBAction func logout() {
         MapUtility.sharedInstance().logoutUdacity() { (data, error) in
            
            if error != nil { // Handle error…
                
                let alert = UIAlertController(title: "", message: "Unable to logout, please try again!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
        }
        
    }
    
    
      /*  var locManager = CLLocationManager()
        if (CLLocationManager.locationServicesEnabled()) {
            locManager.requestAlwaysAuthorization()
            locManager.desiredAccuracy = kCLLocationAccuracyBest
           // locManager.startUpdatingLocation()
            var currentLocation = CLLocation!()
            currentLocation = locManager.location
            print("location",currentLocation)

            let longitude = currentLocation.coordinate.longitude
            let latitude = currentLocation.coordinate.latitude
            for dictionary in locations! {
                let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                
                if(longitude == long && latitude == lat){
                    let alert = UIAlertController(title: "", message: Constants.Student.Warn, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Cancel, handler:{(ACTION :UIAlertAction!)in
                        print("User adding location")
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddLocationViewController")
                        self.presentViewController(controller, animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:handleCancel))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }else{
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddLocationViewController")
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }

        }else{
            print("location services not enabled")
            let alert = UIAlertController(title: "", message: Constants.Student.Warn2, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:handleCancel))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }*/
        
        
    
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.
    }

