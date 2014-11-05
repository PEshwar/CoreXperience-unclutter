//
//  FavTableViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 05/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import CoreData

class FavTableViewController: UITableViewController {

    var favList : Array<AnyObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "CoreExperience")
   //     request.predicate = NSPredicate(format: "m_favourites == %@", true)
        favList = context.executeFetchRequest(request, error: nil)!
        println(" TypeList count is \(favList.count)")
    //    println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
        
        tableView.reloadData()
*/
    }
    
    override func viewDidAppear(animated: Bool) {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "CoreExperience")
             request.predicate = NSPredicate(format: "m_favourites == %@", true)
        favList = context.executeFetchRequest(request, error: nil)!
        println(" TypeList count is \(favList.count)")
        //    println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
        
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
        println("Fav count is \(favList.count)")
        return favList.count
    }

    
   
      
      override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("favCell") as UITableViewCell
        //Add this line to get the subtitle text
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier:"favCell")
        //Assign the contents of global type list to the textLabel of each cell
         var data:NSManagedObject = favList[indexPath.row] as NSManagedObject
        cell.textLabel!.text = data.valueForKeyPath("m_title") as? String
        cell.textLabel!.textColor = UIColor.orangeColor()
        
        var tempDate = data.valueForKeyPath("m_date") as? NSDate
        
        
        
        let dateStringFormatter = NSDateFormatter()
        
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        var obtainedDateString : String = dateStringFormatter.stringFromDate(tempDate!)
        var tempType = data.valueForKeyPath("m_type") as? String
        var detailCombined =  obtainedDateString + "  " + tempType!
        cell.detailTextLabel!.text = detailCombined
        cell.detailTextLabel!.textColor = UIColor.purpleColor()
      
      
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
