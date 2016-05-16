
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
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var titles: [String] = [String]()
    var links: [String] = [String]()
    
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaddata()
    }
    
    func loaddata() -> Void {
        for dictionary in appDelegate.studentLocations {
            let title = dictionary.fullName
            let trimmedString = title.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            
            if(trimmedString.characters.count > 0 && !self.titles.contains(trimmedString)){
                self.titles.append(title)
                self.links.append(dictionary.mediaURL)
                 print(" unique")
            }else{
                print("not unique")
            }
        }
         self.reloadTable()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func reloadTable() ->Void {
        print("reloadTable")
        dispatch_async(dispatch_get_main_queue()) {
            self.reloadInputViews()
        }
    }
    
    @IBAction func refresh(){
        appDelegate.studentLocations.removeAll()
        MapUtility.sharedInstance().getStudentLocations { (locations, error) in
            if error == nil {
                MapUtility.sharedInstance().populateStudentLocations(locations, error: error)
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
        if validateUrl(toOpen) {
            UIApplication.sharedApplication().openURL(NSURL(string: toOpen)!)
        } else {
            showAlertMsg(Constants.ErrorMsgs.URLErrorMsg)
        }

    }
    
    func validateUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }

}
