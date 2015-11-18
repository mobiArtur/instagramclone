//
//  UsersTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by admin on 14.09.2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class UsersTableViewController: UITableViewController {
    
    var titles = [String]()
    var usernames = [String]()
    var images = [UIImage]()
    var parseImages = [PFFile]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let getFallowedUsers = PFQuery(className: "Fallowers")
        getFallowedUsers.whereKey("fallower", equalTo: PFUser.currentUser()!.username!)
        getFallowedUsers.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error:NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                //println("Successfully retrieved \(objects!.count) scores.")
                print(PFUser.currentUser()!.username!)
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    var fallowedUser = String()
                    
                    for object in objects {
                        fallowedUser = object["fallowing"] as! String
                        
                        let query = PFQuery(className:"Post")
                        query.whereKey("userName", equalTo: fallowedUser)
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [AnyObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                // The find succeeded.
                                print("Successfully retrieved \(objects!.count) scores.")
                                // Do something with the found objects
                                if let objects = objects as? [PFObject] {
                                    for object in objects {
                                        self.titles.append(object["Title"] as! String)
                                        self.usernames.append(object["userName"] as! String)
                                        self.parseImages.append(object["imageFile"] as! PFFile)
                                        
                                        self.tableView.reloadData()
                                    }
                                }
                            } else {
                                // Log details of the failure
                                print("Error: \(error!) \(error!.userInfo)")
                            }
                        }
                        
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        

        
        
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
        return titles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UsersTableViewCell
        cell.titleLabel.text = usernames[indexPath.row]
        cell.commentLabel.text = titles[indexPath.row]
        //cell.imageView?.image = parseImages[indexPath.row]
        
        parseImages[indexPath.row].getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                let image = UIImage(data: imageData!)
                cell.userImageView.image = image
            }
        }

        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 226
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
