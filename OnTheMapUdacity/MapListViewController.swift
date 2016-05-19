
//
//  MapListViewController.swift
//  OnTheMapUdacity
//
//  Created by Sheethal Shenoy on 5/2/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//
import UIKit
import MapKit


class MapListViewController: CommonMapViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appDelegate = MapUtility.sharedInstance().appDelegate
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func refresh(){
        StudentLocation.sharedInstance().removeAll()
        MapUtility.sharedInstance().getStudentLocations { (locations, error) in
            if error == nil {
                StudentLocation.sharedInstance().setStudentData(StudentData.studentsFromResults(locations!))
            }else{
                self.showAlertMsg(Constants.ErrorMsgs.ReloadErrorMsg)
            }
        }
    }
    
}



extension MapListViewController {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // get cell type
        let cellReuseIdentifier = "StudentsCell"
        let title = StudentLocation.sharedInstance().studentData[indexPath.row].getFullname()
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        // set cell defaults
        cell.textLabel!.text = title
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocation.sharedInstance().getStudentData().count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let toOpen = StudentLocation.sharedInstance().studentData[indexPath.row].getMediaURL()
        if MapUtility.sharedInstance().validateUrl(toOpen) {
            UIApplication.sharedApplication().openURL(NSURL(string: toOpen)!)
        } else {
            showAlertMsg(Constants.ErrorMsgs.URLErrorMsg)
        }

    }
 
}
