/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var accountControlerOutlet: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passwordName: UITextField!
    
    
    @IBOutlet var emailName: UITextField!
    
    @IBOutlet var atLabel: UILabel!
    @IBOutlet var emailDomena: UITextField!
    @IBAction func accountControler(sender: UISegmentedControl) {
        
        
        if sender.selectedSegmentIndex == 1 {
            SignUpOutlet.setTitle("Log In", forState: UIControlState.Normal)
            userName.placeholder = "Enter your user name"
            passwordName.placeholder = "Enter your password"
            emailName.hidden = true
            emailDomena.hidden = true
            atLabel.hidden = true


        } else if sender.selectedSegmentIndex == 0 {
            emailName.hidden = false
            emailDomena.hidden = false
            atLabel.hidden = false
            SignUpOutlet.setTitle("Sign Up", forState: UIControlState.Normal)
            userName.placeholder = "Enter a user name for Sign Up"
            passwordName.placeholder = "Enter a password for Sign Up"

        }
        
    }

    
    @IBOutlet weak var SignUpOutlet: UIButton!
    
    
    @IBAction func singUp(sender: UIButton) {
        var error = String()
        

        
        if userName.text == "" || passwordName.text == "" {
            
            error = "Plase enter Name and Password"
        } else if userName.text!.characters.count < 3 || passwordName.text!.characters.count < 5 {
            error = "User name need to have more than 3 characters and password more than 5 charcters"
        }
        
        
        
        if error != "" {
            displayAlert("Error", error: error)
            
            
            
        } else {
            let user = PFUser()
            let profile = PFObject(className: "Profile")
            let avtarProfile = PFObject(className: "avtars")
            
            user.username = userName.text
            user.password = passwordName.text
            user.email = String(emailName.text! + "@" + emailDomena.text! )
            
            profile["userName"] = userName.text
            avtarProfile["username"] = userName.text
            
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            if accountControlerOutlet.selectedSegmentIndex == 0 {
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, sError: NSError?) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                
                if let sError = sError {
                    error = (sError.userInfo["error"] as? String)!
                    self.displayAlert("Error", error: error)
                    
                } else {
                    self.performSegueWithIdentifier("goToNavi", sender: self)
                }
            }
            } else if accountControlerOutlet.selectedSegmentIndex == 1 {
                PFUser.logInWithUsernameInBackground(userName.text!, password:passwordName.text!) {
                    (user: PFUser?, sError: NSError?) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    if user != nil {
                        self.performSegueWithIdentifier("goToNavi", sender: self)
                    } else {
                        error = (sError!.userInfo["error"] as? String)!
                        self.displayAlert("Error", error: "\(error)")
                    }
                }
            }
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Parse.setApplicationId("Td3C4g2d9ei0rBdkog5XpQiHPNQfh51jFrs8osfV",
            clientKey: "RsanZOvpw1tRLMZWalDWZccWaTwiwwcVWOxtkHzZ")
        
    }
    
    @IBAction func forgottenPassword(sender: UIButton) {
        forgittenPassw()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(title:String, error:String){
        let allert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        allert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {  action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(allert, animated: true, completion: nil)
    }
    
    func forgittenPassw(){
        let allert = UIAlertController(title: "Forgot your Password", message: "Type your addres email for reset", preferredStyle: UIAlertControllerStyle.Alert)
        var textFields = UITextField()
        allert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: {  action in
            PFUser.requestPasswordResetForEmailInBackground(textFields.text!, block: { (succes: Bool, error: NSError?) -> Void in
                if succes {
                    self.displayAlert("Succes", error: "Check your mail for next direc")
                } else {
                    if let error = error {
                        if error.code == PFErrorCode.ErrorObjectNotFound.rawValue {
                            print("Uh oh, we couldn't find the object!")
                        } else if error.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                            self.displayAlert("Error", error: "Uh oh, we couldn't even connect to the Parse Cloud!")
                        } else {
                            let errorString = error.userInfo["error"] as? NSString
                            self.displayAlert("Error", error: String(errorString!))
                        }
                    }
                }
            })
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        allert.addTextFieldWithConfigurationHandler { textField -> Void in
            textFields = textField
            
        }
        self.presentViewController(allert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
//        
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("goToNavi", sender: self)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    
}
