//
//  UserTableView.swift
//  ParseStarterProject-Swift
//
//  Created by admin on 10.09.2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class UserTableView: UITableViewController {
    
    var users = [""]
    var fallowing = [Bool]()
    var refresh = UIRefreshControl()
    var usersAvatars = [[String : String]]()
    var usersAvatarsImages = [[String : PFFile]]()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        updateUsers()
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: "refreshing", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func refreshing(){
        
        updateUsers()
        
    }

    
    func updateUsers(){
        let query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            self.users.removeAll(keepCapacity: true)
            self.fallowing.removeAll(keepCapacity: true)
            
            for object in objects! {
                
                
                let user:PFUser = (object as? PFUser)!
                
                if user.username != PFUser.currentUser()?.username {
                    

                    
                    self.users.append(user.username!)
                    
                    let queryForAvatar = PFQuery(className: "avatars")
                    queryForAvatar.whereKey("userName", equalTo: user.username!)
                    queryForAvatar.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    let obje = ["name" : object["userName"] as! String]
                                    let avObj = [object["userName"] as! String: object["avatar"] as! PFFile]
                                    self.usersAvatars.append(obje)
                                    self.usersAvatarsImages.append(avObj)
                                    self.tableView.reloadData()
                                    
                                }
                            }
                        } else {
                           // print("Error: \(error!) \(error!.userInfo)")

                        }
                        
                    })
                    
                    
                    
                    
                    
                    let query = PFQuery(className:"Fallowers")
                    query.whereKey("fallowing", equalTo:user.username!)
                    query.whereKey("fallower", equalTo: PFUser.currentUser()!.username!)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            
                            // The find succeeded.
                          //  print("Successfully retrieved \(objects!.count) scores.")
                            // Do something with the found objects
                            
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    for user in self.users {
                                        if user == object["fallowing"] as! String {
                                        }
                                    }
                                    self.tableView.reloadData()
                                    
                                }
                            }

                        } else {
                            // Log details of the failure
                            //print("Error: \(error!) \(error!.userInfo)")
                        }

                        self.refresh.endRefreshing()
                    }
                    
                    
                }
                
                
            }
            
            self.tableView.reloadData()
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return users.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 

        if  fallowing.count > indexPath.row {
            if fallowing[indexPath.row] == true {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            
        }
        
        cell.textLabel?.text = users[indexPath.row]

        
        
        for obj in usersAvatars {
            if users[indexPath.row] == obj["name"] {
                let userWithAvatar = obj["name"]
                for objective in usersAvatarsImages {
                    objective[userWithAvatar!]?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            cell.imageView?.image = image
                        }
                    })
                }
            }
        }
        


        return cell
    }
    
    var clickUser = String()

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
        clickUser = users[indexPath.row]
            performSegueWithIdentifier("sProfile", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "sProfile" {
            let cv = segue.destinationViewController as! UserProfileViewController
            cv.profile = clickUser
        }
        

    }
    
    

}
