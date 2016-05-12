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
           dispatch_async(dispatch_get_main_queue()){
            
                self.getRequestToken()
                
            }
            
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
        
        let request = NSMutableURLRequest(URL:MapUtility.sharedInstance().udacityURLFromParameters([String:AnyObject](), withPathExtension: [Constants.Login.Session]))
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let username = /*usernameTextField.text!*/"sheethal.shenoy@gmail.com"
        let password = /*passwordTextField.text!*/"Sriram123"
        let str = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        
        request.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
               self.showAlertMsg( "Username or Password not correct.")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                self.showAlertMsg( "Username or Password not correct.")
                return
            }
            
           
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showAlertMsg("Your request returned a status code other than 2xx")
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            print("parsedResult",parsedResult)
            
            
            guard let sessionResult = parsedResult[Constants.Login.Account] as? [String:AnyObject] else {
                print(" See error code and message \(parsedResult)")
                return
            }
            
            /* GUARD: Is userID "success" key in parsedResult? */
            guard let userid = sessionResult[Constants.Login.Key] as? String else {
                print("Cannot find key 'session id ")
                return
            }
            
            
            self.appDelegate.key = userid
            self.getUserData()
            self.completeLogin()
            print("userid:",userid)
        }
        task.resume()
        
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
        
        let request = NSMutableURLRequest(URL:MapUtility.sharedInstance().udacityURLFromParameters([String:AnyObject](), withPathExtension: [Constants.Login.Userdata,(self.appDelegate.key) ]))
        

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                self.showAlertMsg("Unable to get userdata.")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                self.showAlertMsg("Unable to get userdata.")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showAlertMsg("Your request returned a status code other than 2xx")
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            guard let user = parsedResult[Constants.Login.user] as? [String:AnyObject] else {
                print(" Can't find the user in \(parsedResult)")
                return
            }
            
            guard let firstName = user[Constants.Login.FirstName] as? String else {
                print(" Can't find the firstname in \(parsedResult)")
                return
            }
            
            /* GUARD: Is firstName "success" key in parsedResult? */
            guard let lastName = user[Constants.Login.LastName] as? String else {
                print(" Can't find the lastname in \(parsedResult)")
                return
            }

        self.appDelegate.firstName = firstName
        self.appDelegate.lastName = lastName
        print("firstname:",firstName,"lastname:",lastName)
        self.completeLogin()
        
    }
    task.resume()
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