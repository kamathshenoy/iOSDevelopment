//
//  SentMemesCollectionViewController.swift
//  ImagePickerExp
//
//  Created by Sheethal Shenoy on 2/29/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemesCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var addMeme: UIBarButtonItem!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var hgt_dimension : CGFloat = 0.0
    var wdt_dimension : CGFloat = 0.0
    
    @IBAction func showMemeEditor(sender: AnyObject) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MeMeEditorViewController") as! MeMeEditorViewController
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //createFlowLayout()
        collectionView!.reloadData()
        self.tabBarController?.tabBar.hidden = false
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.registerClass(MemesCollectionViewCell.self,forCellWithReuseIdentifier: reuseIdentifier)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

   /* override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        return appDelegate.memes.count
    }*/


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return getAppDelegate().memes.count
    }
    
    func getAppDelegate() -> AppDelegate {
        return  (UIApplication.sharedApplication().delegate as! AppDelegate)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemesCollectionViewCell", forIndexPath: indexPath) as! MemesCollectionViewCell
        let meme = getAppDelegate().memes[indexPath.item]
        cell.memeImageView?.image = meme.image
        cell.topLabel?.text = meme.topText+"...."+meme.bottomText
        
        UIGraphicsBeginImageContextWithOptions(flowLayout.itemSize, false, UIScreen.mainScreen().scale)
        let imageRect : CGRect = CGRectMake(0, 0, flowLayout.itemSize.width, flowLayout.itemSize.height)
        cell.memeImageView?.image?.drawInRect(imageRect)
        cell.memeImageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        detailController.meme = getAppDelegate().memes[indexPath.item]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func createFlowLayout(){
        let space : CGFloat = 3.0
        wdt_dimension = (self.view.frame.width - (2 * space)) / 2.0
        hgt_dimension = (self.view.frame.height - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(wdt_dimension, hgt_dimension)
        collectionView!.collectionViewLayout = flowLayout
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
