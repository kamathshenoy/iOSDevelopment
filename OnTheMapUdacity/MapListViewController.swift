//
//  GenreTableViewController.swift
//  MyFavoriteMovies
//
//

import UIKit
import MapKit


class MapListViewController: CommonMapViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var titles: [String] = [String]()
    var genreID: Int? = nil
    
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
                 print(" unique")
            }else{
                print("not unique")
            }
        }
         self.reloadTable()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
       
        /* TASK: Get movies by a genre id, then populate the table */
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
            MapUtility.sharedInstance().populateStudentLocations(locations, error: error)
            self.loaddata()
            self.reloadTable()
        }

    }
    
   /* @IBAction func addLocation(){
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddLocationViewController")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: Logout
    @IBAction func logout() {
        MapUtility.sharedInstance().logoutUdacity() { (data, error) in
            
            if error != nil { // Handle error…
                self.showAlertMsg(Constants.ErrorMsgs.LogoutErrorMsg)
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
    }*/
    
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
        /*
        // push the movie detail view
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MapListViewController") as! MovieDetailViewController
        controller.movie = movies[indexPath.row]
        navigationController!.pushViewController(controller, animated: true)*/
    }
    

}
