//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by admin on 11.09.2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    var imageChoose = Bool()
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var shareText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageChoose = false
        imageToPost.image = UIImage(named: "defaultImage.png")
        shareText.text = ""
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func choseImage(sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }

    
    
    @IBAction func postImage(sender: UIButton) {
        
        var error = String()
        
        if !imageChoose {
            error = "Choose image to post"
            
            displayAlert("Error", error: error)
            
        } else if shareText.text == "" {
            error = "Add Coment to your photo"
            displayAlert("Error", error: error)
        } else {
            let post = PFObject(className: "Post")
            _ = PFObject(className: "User")
            post["Title"] = shareText.text
            post["userName"] = PFUser.currentUser()?.username
            
            
            post.saveInBackgroundWithBlock({ (succeeded: Bool, sError: NSError?) -> Void in
                if succeeded == false {
                    self.displayAlert("Could Not Post Image", error: String(stringInterpolationSegment: sError))
                } else {
                    let imageData = UIImagePNGRepresentation(self.imageToPost.image!)
                    let imageFile = PFFile(name: "image.png", data: imageData!)
                    post["imageFile"] = imageFile
                    
                    post.saveInBackgroundWithBlock({ (succeeded: Bool, sError: NSError?) -> Void in
                        if succeeded == false {
                            self.displayAlert("Could Not Post Image", error: String(stringInterpolationSegment: sError))
                        } else {
                            self.displayAlert("Image Posted", error: "Your image has been posted")
                            self.imageChoose = false
                            self.imageToPost.image = UIImage(named: "defaultImage.png")
                            self.shareText.text = ""
                            
                        }
                    })
                    
                    
                }
            })
            
        }
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        imageChoose = true
    }
    
    func displayAlert(title:String, error:String){
        let allert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        allert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(allert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func logOutBarItem(sender: UIBarButtonItem) {
        PFUser.logOut()
        performSegueWithIdentifier("logOut", sender: self)
        
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
