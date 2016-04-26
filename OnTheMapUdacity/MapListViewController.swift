//
//  GenreTableViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - GenreTableViewController: UITableViewController

class MapListViewController: UITableViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var titles: [String] = [String]()
    var genreID: Int? = nil
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
                for dictionary in appDelegate.studentLocations {
                    let title = dictionary.fullName
                    print(title)
                    
                    let trimmedString = title.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    )
                    
                    if(trimmedString.characters.count > 0 && !self.titles.contains(trimmedString)){
                        self.titles.append(title)
                    }else{
                        print("not unique")
                    }
                }

        
            self.performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        
        
    }
    
    func performUIUpdatesOnMain(updates: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            updates()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
       
        /* TASK: Get movies by a genre id, then populate the table */
    }
    
    // MARK: Logout
    
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
    
   }



extension MapListViewController {

      override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // get cell type
        let cellReuseIdentifier = "StudentsCell"
        let title = titles[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        // set cell defaults
        cell.textLabel!.text = title
        print(cell.textLabel!.text)
        return cell
    }
    
      override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("titles.count",self.titles.count)
        return self.titles.count
    }
    
    
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        // push the movie detail view
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MapListViewController") as! MovieDetailViewController
        controller.movie = movies[indexPath.row]
        navigationController!.pushViewController(controller, animated: true)*/
    }
    

}
