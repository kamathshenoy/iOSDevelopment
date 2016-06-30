//
//  ImagesViewController.swift
//  VirtualTourist
//
//  Created by Sheethal Shenoy on 6/12/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class ImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    var pinInTopic: Pin!
    
    var selectedIndexes = [NSIndexPath]()
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    
    @IBOutlet weak var newCollection: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newCollection.enabled = false
        retrievePhotos()
        self.collectionView!.reloadData()
        getLastMapRegion()
        let annotation = MyPointAnnotation()
        annotation.pin = pinInTopic
        annotation.coordinate = CLLocationCoordinate2D(latitude: (pinInTopic.latitude as? Double)!, longitude: (pinInTopic.longitude as? Double)!)
         mapView.addAnnotation(annotation)
    
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        //if the photos are cached, enable the button right away
        if(pinInTopic.pintoPhoto?.count > 0) {
            self.newCollection.enabled = true
        }
        updateButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView!.reloadData()
    }
    
    func retrievePhotos(){
        FlickrUtility.sharedInstance().getPhotosForPin(pinInTopic!) {success in
            self.newCollection.enabled = true
            print("enable the new Collection button")
            if !success{
                let alert = UIAlertController(title: "", message: "Unable to get any photos for this pin. Try another pin." , preferredStyle: UIAlertControllerStyle.Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                }
                alert.addAction(OKAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
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
    
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let width = floor(self.collectionView.frame.size.width/3)
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func reloadCollection(sender: AnyObject?) {
        if selectedIndexes.isEmpty {
                deleteAllPhotos()
            
                getMorePhotos(){success  in
                    if !success {
                        self.newCollection.enabled = true
                        return
                    }else{
                        self.showErrorAlert("Unable to get any photos for this pin. Try another.")
                    }
                }
            } else {
                deleteSelectedPhotos()
            }
        
    }
    
    
    func showErrorAlert(msg:String) ->Void{
        let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getMorePhotos(completionHander:(success:Bool) -> Void) {
        
        FlickrUtility.sharedInstance().getPhotos(pinInTopic.latitude!.description, longitude: pinInTopic.longitude!.description, pageNumber: getPageNumberForNewRequest(), pin: pinInTopic) {   success in
            self.newCollection.enabled = true
            print("enable the new Collection button - getMorePhtos")
            if !success{
                let alert = UIAlertController(title: "", message: "Unable to get any photos for this pin. Try another pin." , preferredStyle: UIAlertControllerStyle.Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                }
                alert.addAction(OKAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
        
        
    }
    
    
    func getPageNumberForNewRequest()-> Int {
        let totalPages = Int(pinInTopic.totalPages!)
        let currentPage = Int(pinInTopic.currentPage!)
        
        if (totalPages > currentPage) {
            pinInTopic.currentPage = currentPage + 1
        }
        else if (pinInTopic.totalPages == pinInTopic.currentPage) {
            pinInTopic.currentPage = 1
        }
        print("Current page is ", currentPage," total pages for this pin is ", totalPages, " next page to retrieve is ", pinInTopic.currentPage)
        return Int(pinInTopic.currentPage!)
    }
    
   
    func deleteAllPhotos() {
        for photo in fetchedResultsController.fetchedObjects as! [Photo] {
            print("deleting photos")
            sharedContext.deleteObject(photo)
        }
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func deleteSelectedPhotos() {
        var photosToDelete = [Photo]()
        
        for indexPath in selectedIndexes {
            photosToDelete.append(fetchedResultsController.objectAtIndexPath(indexPath) as! Photo)
        }
        
        for photo in photosToDelete {
            sharedContext.deleteObject(photo)
        }
        
        selectedIndexes = [NSIndexPath]()
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    
    func configureCell(cell: ImageCell, atIndexPath indexPath: NSIndexPath) {
        
        var imageForCell = UIImage(named: "noImage")
        
        cell.imageCollectionViewCellImage.image = nil
        
        let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as?  Photo
                
        _ = photo!.photoToPin! as Pin
        if let image = photo!.image  {
            //print("Retrieving image from CoreData")
            let img = UIImage(data: image)!
            imageForCell = img
        }else{
            if photo!.url_m == "" {
                print("URL for photoImage is nil or an empty string")
            } else if photo!.url_m != nil {
                
                cell.activityIndicator.startAnimating()
                _ = FlickrUtility.sharedInstance().getPhotoImageForPin(photo!){success, data  in
                    
                    if success {
                        
                        let image = UIImage(data: data!)
                        CoreDataStackManager.sharedInstance().saveContext()
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.activityIndicator.stopAnimating()
                            cell.imageCollectionViewCellImage.image = image
                        }
                    } else {
                        print("UNABLE TO LOAD PHOTOS")
                    }
                }
            }
        
        }
        if selectedIndexes.indexOf(indexPath) != nil {
            cell.imageCollectionViewCellImage.alpha = 0.3
        } else {
            cell.imageCollectionViewCellImage.alpha = 1.0
        }
        
        cell.imageCollectionViewCellImage.image = imageForCell
    }
    
    
    // MARK: - UICollectionView
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let sections = fetchedResultsController.sections {
           // print("section count",sections.count)
            
            return sections.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            //print("currentSection.numberOfObjects",currentSection.numberOfObjects)
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //print("indexPath",indexPath)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCell
        
        // Whenever a cell is tapped we will toggle its presence in the selectedIndexes array
        if let index = selectedIndexes.indexOf(indexPath) {
            selectedIndexes.removeAtIndex(index)
        } else {
            selectedIndexes.append(indexPath)
        }
        
        // Then reconfigure the cell
        configureCell(cell, atIndexPath: indexPath)
        
        // And update the buttom button
        updateButton()
    }
    
    func updateButton() {
        if selectedIndexes.count > 0 {
            newCollection.title = "Remove Selected Photos"
        } else {
            newCollection.title = "New Collection"
        }
    }
    
    // MARK: - NSFetchedResultsController
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        //Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        
        //Add a sort descriptor
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Fetch only photos from the selected pin
        let predicate = NSPredicate(format: "photoToPin == %@", self.pinInTopic)
        fetchRequest.predicate = predicate
        
        //Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        //Return the fetched results controller
        return fetchedResultsController
        
    }()
    
    // MARK: - Fetched Results Controller Delegate
    
    // Whenever changes are made to Core Data the following three methods are invoked. This first method is used to create
    // three fresh arrays to record the index paths that will be changed.
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // We are about to handle some new changes. Start out with empty arrays for each change type
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
        
       // print("in controllerWillChangeContent")
    }
    
    // The second method may be called multiple times, once for each Color object that is added, deleted, or changed.
    // We store the incex paths into the three arrays.
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type{
            
        case .Insert:
           // print("Insert an item")
            // Here we are noting that a new Color instance has been added to Core Data. We remember its index path
            // so that we can add a cell in "controllerDidChangeContent". Note that the "newIndexPath" parameter has
            // the index path that we want in this case
            insertedIndexPaths.append(newIndexPath!)
            break
        case .Delete:
           // print("Delete an item")
            // Here we are noting that a Color instance has been deleted from Core Data. We keep remember its index path
            // so that we can remove the corresponding cell in "controllerDidChangeContent". The "indexPath" parameter has
            // value that we want in this case.
            deletedIndexPaths.append(indexPath!)
            break
        case .Update:
            //print("Update an item.")
            // We don't expect Color instances to change after they are created. But Core Data would
            // notify us of changes if any occured. This can be useful if you want to respond to changes
            // that come about after data is downloaded. For example, when an images is downloaded from
            // Flickr in the Virtual Tourist app
            updatedIndexPaths.append(indexPath!)
            break
        case .Move:
            print("Move an item. We don't expect to see this in this app.")
            break
        default:
            break
        }
    }
    
    // This method is invoked after all of the changed in the current batch have been collected
    // into the three index path arrays (insert, delete, and upate). We now need to loop through the
    // arrays and perform the changes.
    //
    // The most interesting thing about the method is the collection view's "performBatchUpdates" method.
    // Notice that all of the changes are performed inside a closure that is handed to the collection view.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
       // print("in controllerDidChangeContent. changes.count: \(insertedIndexPaths.count )")
        
        collectionView.performBatchUpdates({() -> Void in
            
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.collectionView.reloadItemsAtIndexPaths([indexPath])
            }
            
            }, completion: nil)
        
        updateButton()
    }
    
    
    @IBAction func buttonButtonClicked() {
        
        if selectedIndexes.isEmpty {
            deleteAllPhotos()
        } else {
            deleteSelectedPhotos()
        }
    }

    
       
}