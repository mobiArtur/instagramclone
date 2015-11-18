//
//  UserProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by admin on 17.09.2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var loadingImageIndicatior: UIActivityIndicatorView!
    @IBOutlet var fallowUnfallowLabel: UILabel!
    var profile = " "
    var parseImages = [PFFile]()
    var usersComment = [String]()
    
    @IBOutlet var fallowingSwitchOutlet: UISwitch!
    @IBAction func fallowingSwitch(sender: UISwitch) {
        
        if sender.on {
            fallowUnfallowLabel.text = "Unfallow this user"
            
                        let fallowing = PFObject(className: "Fallowers")
                        fallowing["fallowing"] = profile
                        fallowing["fallower"] = PFUser.currentUser()?.username
                        fallowing.saveInBackground()
           
  
            
            
            
        } else {
             fallowUnfallowLabel.text = "Fallow this user"
                        let query = PFQuery(className:"Fallowers")
                        query.whereKey("fallowing", equalTo:profile)
                        query.whereKey("fallower", equalTo: PFUser.currentUser()!.username!)
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [AnyObject]?, error: NSError?) -> Void in
            
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
                        }
            
            
        }
        
    }
    
    @IBOutlet var imageViewrCollectionView: UICollectionView!
    
    
    @IBOutlet var infoParse: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        imageViewrCollectionView.delegate = self
        
        let profileQuerry = PFQuery(className: "Profile")
        let postParse = PFQuery(className: "Post")
        let fallowersParse = PFQuery(className: "Fallowers")
        profileQuerry.whereKey("userName", equalTo: profile)
        profileQuerry.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.infoParse.text = object["About"] as? String
                        
                        
                        
                    }
                }
            } else {
               // print("Error: \(error!) \(error!.userInfo)")

            }
        }
        
        postParse.whereKey("userName", equalTo: profile)
        postParse.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        print(object)
                        self.parseImages.append(object["imageFile"] as! PFFile)
                        self.usersComment.append(object["Title"] as! String)
                        self.imageViewrCollectionView.reloadData()
                        
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                
            }
        }
        
        fallowersParse.whereKey("fallowing", equalTo: profile)
        fallowersParse.whereKey("fallower", equalTo: PFUser.currentUser()!.username!)
        fallowersParse.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for _ in objects {
                        self.fallowingSwitchOutlet.on = true
                        
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                
            }
            if self.fallowingSwitchOutlet.on {
                self.fallowUnfallowLabel.text = "Unfallow this user"
            } else {
                self.fallowUnfallowLabel.text = "Fallow this user"
            }
        }
        

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pohotoCell", forIndexPath: indexPath) as! UserPhotosCollectionViewCell
        cell.lodaImageIndicator.startAnimating()
        if parseImages.count == 0 {
            cell.lodaImageIndicator.hidden = true
            cell.text.text = "No image for display"
        } else {
            cell.text.text = usersComment[indexPath.row]
            parseImages[indexPath.row].getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    let image = UIImage(data: imageData!)
                    cell.lodaImageIndicator.stopAnimating()
                    cell.lodaImageIndicator.hidden = true
                    cell.image.image = image
                }
            }
        }

        
        
                return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if parseImages.count == 0 {
            return 1
            
        } else {
            return parseImages.count

        }
        
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
