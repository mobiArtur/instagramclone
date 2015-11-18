//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by admin on 15.09.2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var nickNameTextfield: UITextField!
    
    @IBOutlet var noteTextField: UITextField!
    
    
    @IBOutlet var avatarImage: UIImageView!
    
    var avatarData = [PFFile]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = PFUser.currentUser()?.username
        nickNameTextfield.delegate = self
        noteTextField.delegate = self
        receiveData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapAvatarImage(sender: UITapGestureRecognizer) {
        
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        

        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        for var i = 0; i <= 1; i++ {
            if i == 0 {
                avatarImage.image = image

            } else if i == 1 {
                for var i = 0; i <= 1; i++ {
                    _ = PFObject(className: "Profile")
                    _ = PFQuery(className: "Profile")
                    let avatars = PFObject(className: "avatars")
                    let avatarsQuerry = PFQuery(className: "avatars")
                    
                    
                    let imageData = UIImagePNGRepresentation(self.avatarImage.image!)
                    let imageFile = PFFile(name: "image.png", data: imageData!)
                    if i == 0 {
                        avatarsQuerry.whereKey("userName", equalTo: PFUser.currentUser()!.username!)
                        //profileQuerry.whereKey("avatar", equalTo: imageFile)
                        avatarsQuerry.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                            
                            
                            if error == nil {
                                // The find succeeded.
                                //  println("Successfully retrieved \(objects!.count) scores.")
                                // Do something with the found objects
                                if let objects = objects as? [PFObject] {
                                    for object in objects {
                                        object.deleteInBackground()
                                        
                                    }
                                }
                            } else {
                                // Log details of the failure
                               // print("Error: \(error!) \(error!.userInfo)")
                            }
                            
                        })
                        
                    } else if i == 1 {
                        
                        avatars["avatar"] = imageFile
                        avatars["userName"] = PFUser.currentUser()!.username!
                        avatars.saveInBackground()
                    }
                }
            }
        }
        avatarImage.image = image
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
            for var i = 0; i <= 1; i++ {
                let profile = PFObject(className: "Profile")
                let profileQuerry = PFQuery(className: "Profile")
                if i == 0 {
                    profileQuerry.whereKey("userName", equalTo: PFUser.currentUser()!.username!)
                    profileQuerry.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                        
                        
                        if error == nil {
                            // The find succeeded.
                            //  println("Successfully retrieved \(objects!.count) scores.")
                            // Do something with the found objects
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    object.deleteInBackground()
                                }
                            }
                        } else {
                            // Log details of the failure
                            print("Error: \(error!) \(error!.userInfo)")
                        }
                        
                    })
                    
                } else if i == 1 {
                    profile["userName"] = PFUser.currentUser()!.username!
                    profile["Nick"] = nickNameTextfield.text
                    profile["About"] = noteTextField.text
                    profile.saveInBackground()
                }
            
        }

        

        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func receiveData(){
        
        let profileQuerry = PFQuery(className: "Profile")
        let avatarsQuerry = PFQuery(className: "avatars")
        profileQuerry.whereKey("userName", equalTo: PFUser.currentUser()!.username!)
        profileQuerry.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            
            if error == nil {
                // The find succeeded.
                //  println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.nickNameTextfield.text = object["Nick"] as? String
                        self.noteTextField.text = object["About"] as? String
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        })
        for var i = 0; i <= 1; i++ {
            if i == 0 {
                avatarsQuerry.whereKey("userName", equalTo: PFUser.currentUser()!.username!)
                avatarsQuerry.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    
                    if error == nil {
                        // The find succeeded.
                        //  println("Successfully retrieved \(objects!.count) scores.")
                        // Do something with the found objects
                        if let objects = objects as? [PFObject] {
                            for object in objects {
                                self.avatarData.append(object["avatar"] as! PFFile)
                                
                                
                            }
                        }
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                    if self.avatarData.count > 0 {
                        self.avatarData[0].getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                let image = UIImage(data: imageData!)
                                self.avatarImage.image = image
                            }
                        }
                    }

                })
            }
        }



        

    }
    
    
    
}
