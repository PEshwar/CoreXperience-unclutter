//
//  categoryViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 09/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class categoryViewController: UITableViewController {

    var catImage = UIImageView()
      var l_typeList = [NSManagedObject]()
    
            
   
 
    @IBAction func donePressed(sender: AnyObject) {
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
 
        
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        g_typeList.removeAll(keepCapacity: true)
        
        
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"CoreCategory")
        fetchRequest.returnsObjectsAsFaults = false
        
        var error: NSError?
        let fetchedResults = context.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            l_typeList = results }
            else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        }

    override func viewWillAppear(animated: Bool) {
    var typeList : Array<AnyObject> = []
    g_typeList.removeAll(keepCapacity: true)
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var context: NSManagedObjectContext;
    context = appDel.managedObjectContext!
    let fetchRequest = NSFetchRequest(entityName:"CoreCategory")
    fetchRequest.returnsObjectsAsFaults = false
    
    var error: NSError?
    let fetchedResults = context.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
    
    if let results = fetchedResults {
        l_typeList = results }
        else {
        println("Could not fetch \(error), \(error!.userInfo)")
    }

    tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return l_typeList.count
    }

    
override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

            var categoryCell = tableView.dequeueReusableCellWithIdentifier("categoryCell") as categoryTableViewCell
    
    
            //Assign the contents of global type list to the textLabel of each cell
            categoryCell.categoryLabel!.text = l_typeList[indexPath.row].valueForKeyPath("md_category") as? String
            //  var photoLoc =  l_typeList[indexPath.row].valueForKeyPath("md_categoryImage") as? String
        categoryCell.categoryImage.image =  l_typeList[indexPath.row].valueForKeyPath("md_categoryImage") as? UIImage

    //Get Photo
    
 /*   let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
    let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
    
    
    if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
        if paths.count > 0 {
            if let dirPath = paths[0] as? String {
                var photoPath = dirPath.stringByAppendingPathComponent(photoLoc!)
                println(" Photo Path is \(photoPath)")
                var imagePhoto = UIImage(named: photoPath)
                categoryCell.categoryImage.image = imagePhoto
                
            }
        }
    }
    */
   
   // get image from device location
    
  //  Default-category.jpg
    //Set image for category
  //  categoryCell.categoryImage.image = UIImage(named: "Default-category.jpg")
    
          //  cell.textLabel!.textColor = UIColor.blackColor()

        // Configure the cell...
    g_typeList.append(categoryCell.categoryLabel!.text!)
    
//    var myBackView=UIView(frame:cell.frame)
    
//    myBackView.backgroundColor = UIColor.orangeColor();
    
//    cell.selectedBackgroundView = myBackView
       
    return categoryCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Obtain reference to selected row  & selected item
        
        var selectedRow = self.tableView.indexPathForSelectedRow()?.row
        var selectedItem : NSManagedObject = self.l_typeList[selectedRow!] as NSManagedObject
  //      println("Got reference to selected item")
        
        var destinationVC:categoryImageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("categoryImageViewController") as categoryImageViewController
        
        var catName = selectedItem.valueForKey("md_category") as String?
        var catImage = selectedItem.valueForKey("md_categoryImage") as UIImage?
        destinationVC.s_catName = catName!
        destinationVC.s_catImage = catImage!
        destinationVC.existingItem = selectedItem
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
        
            // Delete the row from the data source
        var persistenceHelper: ExperiencePersistenceHelper = ExperiencePersistenceHelper()
        
        var valueToBeDeleted = l_typeList[indexPath.row].valueForKeyPath("md_category") as? String
            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            var context: NSManagedObjectContext;
            context = appDel.managedObjectContext!
            
       
        
        var typeList : Array<AnyObject> = []
     //   var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
     //   var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        
            //Check if there are experience entries for that category
            
            
            var request = NSFetchRequest(entityName: "CoreExperience")
      //      println(" selected Type is  \(l_typeList[indexPath.row])")
            var cat = l_typeList[indexPath.row].valueForKeyPath("md_category") as? String
            
            request.predicate = NSPredicate(format: "m_type == %@", valueToBeDeleted!)
            var totalCount = context.countForFetchRequest(request, error: nil)
            if totalCount > 0 {
   //             println(" \(totalCount) experiences found for this category \(valueToBeDeleted)")
                var categoryAlert = UIAlertController(title: "Warning", message: " \(totalCount) experience(s) exist for this category, you cannot delete", preferredStyle: UIAlertControllerStyle.Alert)
                categoryAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Destructive, handler: nil))
                presentViewController(categoryAlert, animated: true, completion: nil)
                
            } else {
             // Delete category if there are no experiences for the category selected for deletion
            
         persistenceHelper.remove("CoreCategory", key: "md_category", value: valueToBeDeleted!)
        let fetchRequest = NSFetchRequest(entityName:"CoreCategory")
        fetchRequest.returnsObjectsAsFaults = false
            var error: NSError?
        let fetchedResults = context.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            l_typeList = results }
            else {
            println("Could not fetch \(error), \(error!.userInfo)")
        } }
        g_typeList.removeAll(keepCapacity: true)
        tableView.reloadData()
        }
        }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

extension categoryViewController : categoryImagePickedDelegate {
    
    func userImagePicked(selectedPhoto : UIImage, categoryName : String) {
        
        //   photoExperience.image = UIImage (named: "FavSelected.png")
        catImage.image = selectedPhoto
    }
    
}
