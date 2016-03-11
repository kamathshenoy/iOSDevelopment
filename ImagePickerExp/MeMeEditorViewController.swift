//
//  ViewController.swift
//  ImagePickerExp
//
//  Created by Sheethal Shenoy on 2/22/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import UIKit

class MeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lowerToolBar: UIToolbar!
    
    @IBOutlet weak var upperNavBar: UINavigationItem!
    @IBOutlet weak var photoLibraryBarItem: UIButton!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
   // @IBOutlet weak var cancelBarItem: UIButton!
    
    @IBOutlet weak var shareBarItem: UIBarButtonItem!
    @IBOutlet weak var cameraBarItem: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
  
       
    //all viewController metods here
    override func viewDidLoad() {
        setTextFieldDelegate(bottomTextField)
        setTextFieldDelegate(topTextField)
        setDefaultTextAttributes(bottomTextField)
        setDefaultTextAttributes(topTextField)
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        setTextAlignment(topTextField)
        setTextAlignment(bottomTextField)
        setStateOfUIBarButtonItem(shareBarItem, state: false)
        
        //let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override  func viewWillAppear(animated: Bool) {
        cameraBarItem.enabled = isCameraPresent()
        subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
  
    
    //all text field mehods here
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //all image picker methods here
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.delegate = self
        if let image  = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            imagePickerView.contentMode = .ScaleAspectFit
        }
        setStateOfUIBarButtonItem( shareBarItem, state: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

   //all NSNotifications methods go here
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if(bottomTextField.isFirstResponder()){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
 //all IBActions go here

  /*  @IBAction func closeApp(sender: AnyObject) {
       // exit(0)
    }*/
    

   @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let img = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [img]
            , applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            if !completed {
                //user hit cancel , don't save
                return
            }
            self.save()
        }
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        let sentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SentMemesCollectionViewController") as! SentMemesCollectionViewController
        self.navigationController!.pushViewController(sentViewController, animated: true)
    }
    
    //all utility methods go here
    
    
    func isCameraPresent() ->Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    func getAppDelegate() -> AppDelegate {
        return  (UIApplication.sharedApplication().delegate as! AppDelegate)
    }
    
    func save() {
        //Create the meme
        let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!,  image:
            imagePickerView.image!, memedImage: generateMemedImage())
        print("length of memes", getAppDelegate().memes.count)
        getAppDelegate().memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage
    {
        setStateOfUIButtonItem( photoLibraryBarItem, state: false)
         cameraBarItem.enabled =  false
        lowerToolBar.hidden  = true
        cancelButton.enabled = false
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setStateOfUIButtonItem( photoLibraryBarItem, state: true)
         cameraBarItem.enabled =  isCameraPresent()
        lowerToolBar.hidden  = false
        cancelButton.enabled = true
        return memedImage
    }
    
    
    func setTextFieldDelegate(textField:UITextField){
        textField.delegate = self
    }
    
    func setStateOfUIButtonItem(button:UIButton, state:Bool){
        button.enabled = state
    }
    
    func setStateOfUIBarButtonItem(barItem:UIBarButtonItem, state:Bool){
        barItem.enabled = state
    }
    
    //set the meme attributes as the default text attributes
    func setDefaultTextAttributes(textField:UITextField){
        textField.defaultTextAttributes = memeTextAttributes
    }
    
    func setTextAlignment(textField:UITextField){
        textField.textAlignment = NSTextAlignment.Center
    }

}

