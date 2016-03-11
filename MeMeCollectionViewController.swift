//
//  MeMeCollectionViewController.swift
//  ImagePickerExp
//
//  Created by Sheethal Shenoy on 2/28/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import UIKit

class MeMeCollectionViewController: UIViewController {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = appDelegate.memes
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
