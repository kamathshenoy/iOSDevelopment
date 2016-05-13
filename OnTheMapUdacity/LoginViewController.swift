//
//  LoginViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityController.hidden = true
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        configureUI()
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: Constants.Selectors.KeyboardWillShow)
        subscribeToNotification(UIKeyboardWillHideNotification, selector: Constants.Selectors.KeyboardWillHide)
        subscribeToNotification(UIKeyboardDidShowNotification, selector: Constants.Selectors.KeyboardDidShow)
        subscribeToNotification(UIKeyboardDidHideNotification, selector: Constants.Selectors.KeyboardDidHide)
    }
    
    override func viewWillAppear(animated: Bool) {
       
        activityController.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Login
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        userDidTapView(self)
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlertMsg("Username or Password Empty.")
            
            usernameTextField.text = ""
            passwordTextField.text = ""
            setUIEnabled(true)
        } else {
            setUIEnabled(false)
            activityController.hidden = false
            activityController.startAnimating()
            getRequestToken()
            
        }
        
    }
    
    
    private func completeLogin() {
        dispatch_async(dispatch_get_main_queue()) {
            self.resetInputFields()
            self.activityController.stopAnimating()
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabViewController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    private func resetInputFields() -> Void {
       
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    // MARK: TheMovieDB
    
    private func getRequestToken() {
        
        MapUtility.sharedInstance().loginUdacity { (data, error) in
           
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()){
                        self.showAlertMsg((error?.userInfo[NSLocalizedDescriptionKey])! as! String)
                        return
                    }
                }else{
                    self.appDelegate.key = data as! String
                    print("Key",self.appDelegate.key)
                    self.getUserData()
                }
         
        }

       
        
    }
    
    
    @IBAction func facebookLogin(sender: AnyObject) {
      showAlertMsg(Constants.ErrorMsgs.FacebookError)
    }
    
    
    func showAlertMsg(msg:String)->Void {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        presentViewController(alert, animated: true, completion: nil)
        return
    }
    
    
    private func getUserData() {
        
        MapUtility.sharedInstance().getRequestTokenFromUdacity { (data, error) in
            
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()){
                        self.showAlertMsg((error?.userInfo[NSLocalizedDescriptionKey])! as! String)
                        return
                    }
                }else{
                    
                    self.appDelegate.firstName = data![0] as! String
                    self.appDelegate.lastName = data![1] as! String
                    print("No error, recieved the first and lastname", self.appDelegate.lastName, self.appDelegate.firstName)
                    self.getStudentLocations()
                    
                }
            }
        
    }
    
    
    private func getStudentLocations(){
        
        appDelegate.studentLocations.removeAll()
        MapUtility.sharedInstance().getStudentLocations { (locations, error) in
            if error == nil {
                print("got student location")
                MapUtility.sharedInstance().populateStudentLocations(locations, error: error)
                self.completeLogin()
            }else{
                print("did not get student location")
                dispatch_async(dispatch_get_main_queue()){
                    self.showAlertMsg((error?.userInfo[NSLocalizedDescriptionKey])! as! String)
                    return
                }
            }
        }
    }
}



// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
       /* if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
            //movieImageView.hidden = true
            
            print("keyboardWillShow - view.frame.origin.y",view.frame.origin.y)
        }*/
    }
    
    func keyboardWillHide(notification: NSNotification) {
       /* if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
            //movieImageView.hidden = false
            print("keyboardWillHide - view.frame.origin.y",view.frame.origin.y)
        }*/
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
}

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    private func configureUI() {
        
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [Constants.UI.LoginColorTop, Constants.UI.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        configureTextField(usernameTextField)
        configureTextField(passwordTextField)
    }
    
    private func configureTextField(textField: UITextField) {
        let textFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .Always
        textField.backgroundColor = Constants.UI.GreyColor
        textField.textColor = Constants.UI.BlueColor
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        textField.tintColor = Constants.UI.BlueColor
        textField.delegate = self
    }
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}