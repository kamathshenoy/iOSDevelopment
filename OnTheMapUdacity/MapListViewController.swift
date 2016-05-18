
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
    var titles: [String] = [String]()
    var links: [String] = [String]()
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func loaddata() -> Void {
        print("student locations", StudentLocation.sharedInstance().getStudentData().count)
        titles.removeAll()
        links.removeAll()
        
        for element in StudentLocation.sharedInstance().getStudentData() {
            self.titles.append(element.getFullname())
            self.links.append(element.getMediaURL())
        }
        self.reloadTable()
    }
    
    override func viewWillAppear(animated: Bool) {
         loaddata()
    }
    
    func reloadTable() ->Void {
        print("reloadTable")
        dispatch_async(dispatch_get_main_queue()) {
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func refresh(){
        StudentLocation.sharedInstance().removeAll()
        MapUtility.sharedInstance().getStudentLocations { (locations, error) in
            if error == nil {
                StudentLocation.sharedInstance().setStudentData(StudentData.studentsFromResults(locations!))
                self.loaddata()
                
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
        let title = titles[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        // set cell defaults
        cell.textLabel!.text = title
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let toOpen =  links[indexPath.row]
        if MapUtility.sharedInstance().validateUrl(toOpen) {
            UIApplication.sharedApplication().openURL(NSURL(string: toOpen)!)
        } else {
            showAlertMsg(Constants.ErrorMsgs.URLErrorMsg)
        }

    }
   

}
