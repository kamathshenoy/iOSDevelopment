//
//  MasterViewController.swift
//  VirtualTourist
//
//  Created by Sheethal Shenoy on 5/19/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import UIKit
import CoreData
import MapKit
class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    var annotation: MyPointAnnotation!
    var selectedPin:Pin!
    var lastAddedPin:Pin? = nil
    var inEditMode = false
   // @IBOutlet weak var taptoDeleteView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.addGestureRecognizer(getLongPressGesture())
        getLastMapRegion()
        addAnnotations()
    }
    
    func getLongPressGesture() -> UILongPressGestureRecognizer {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delaysTouchesBegan = true
        longPressGesture.delegate = self
        return longPressGesture
    }
    
    func addAnnotations() -> Void {
        let pins:[Pin] = fetchAllPins()
        var annotations : [MyPointAnnotation] = []
        for pin in pins {
            let annotation = MyPointAnnotation()
            annotation.pin = pin
            annotation.coordinate = CLLocationCoordinate2D(latitude: (pin.latitude as? Double)!, longitude: (pin.longitude as? Double)!)
            annotations.append(annotation)
        }
        if(annotations.count > 0){
            mapView.addAnnotations(annotations)
        }
        editButton.enabled = annotations.count > 0 ? true : false
    }
    
    override func viewWillAppear(animated: Bool) {
        //taptoDeleteView.backgroundColor = UIColor.redColor()
        //taptoDeleteView.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchAllPins() -> [Pin] {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        var pins:[Pin] = []
        do {
            let results = try sharedContext.executeFetchRequest(fetchRequest)
            pins = results as! [Pin]
        } catch let error as NSError {
            print("An error occured accessing managed object context \(error.localizedDescription)")
        }
        return pins
    }
    
    func saveMapRegion() {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Location")
        let region = mapView.region
        let regionDictionary = [
            "latitude": region.center.latitude,
            "longitude": region.center.longitude,
            "spanLatitude":   region.span.latitudeDelta,
            "spanLongitude":   region.span.longitudeDelta
        ]
        NSUserDefaults.standardUserDefaults().setObject(regionDictionary, forKey: "Location")
    }
    
    func getLastMapRegion() {
        if let regionDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey("Location") {
           // print("saveLastMapRegion", regionDictionary)
            let region = MKCoordinateRegionMake(
                CLLocationCoordinate2DMake(
                    regionDictionary["latitude"] as! Double,
                    regionDictionary["longitude"] as! Double
                ),
                MKCoordinateSpanMake(
                    regionDictionary["spanLatitude"] as! Double,
                    regionDictionary["spanLongitude"]as! Double
                )
            )
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        if !inEditMode {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        
            let dictionary: [String : AnyObject] = [
                Pin.Keys.lat : newCoordinates.latitude,
                Pin.Keys.lon : newCoordinates.longitude
            ]

            switch gestureRecognizer.state {
                case UIGestureRecognizerState.Began:
                    let pin = Pin(dictionary: dictionary, context: sharedContext)
                
                    annotation = MyPointAnnotation()
                    annotation.pin = pin
                    annotation.coordinate = newCoordinates
                
                    dispatch_async(dispatch_get_main_queue()) {
                        self.mapView.addAnnotation(self.annotation)
                        self.editButton.enabled = true
                    }
                    break
            
            case UIGestureRecognizerState.Ended:
                CoreDataStackManager.sharedInstance().saveContext()
            default:
                return
            }
        }
        
    }
    
    
    func deletePin(annotationToDel: MyPointAnnotation) {
        let alert = UIAlertController(title: "", message: "Are you sure that you want to delete the pin?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
           
        }
        let OKAction = UIAlertAction(title: "Delete", style: .Default) { (action) in
            self.mapView.removeAnnotation(annotationToDel)
            self.sharedContext.deleteObject((annotationToDel.pin)!)
            CoreDataStackManager.sharedInstance().saveContext()
        }
        alert.addAction(cancelAction)
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
        editButton.enabled = self.mapView.annotations.count > 0 ? true : false
    }
    
    
    @IBAction func toggleEditMode(sender: AnyObject) {
        if inEditMode {
            inEditMode = false
            editButton.title = "Edit"
        } else {
            inEditMode = true
            editButton.title = "Done"
        }
    }
    
        
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "Pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.animatesDrop = true
            pinView!.pinTintColor = UIColor.redColor()
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveMapRegion()
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
       
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        let annotation = view.annotation as? MyPointAnnotation
               if(inEditMode){
                    deletePin(annotation!)
                    return
               }else{
                    let pin = annotation?.pin
                    CoreDataStackManager.sharedInstance().saveContext()

                    let controller = storyboard!.instantiateViewControllerWithIdentifier("ImagesViewController") as! ImagesViewController
                    controller.pinInTopic = pin
                    self.presentViewController(controller, animated: true, completion: nil)
            }
    }
}








