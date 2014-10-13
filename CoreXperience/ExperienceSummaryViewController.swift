//
//  ExperienceSummaryViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

class ExperienceSummaryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        
        tableView.reloadData()
        println("Going to call list by type")
        expMgr.listByType()
        
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
        return expMgr.experiences.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell") as UITableViewCell
        
        //Assign the contents of our var "items" to the textLabel of each cell
        cell.textLabel!.text = expMgr.experiences[indexPath.row].m_title
        cell.textLabel!.textColor = UIColor.orangeColor()
    //    cell.detailTextLabel!.text = expMgr.experiences[indexPath.row].m_desc
        
   
  //      tempCell.imageView?.image = UIImage(named: experienceTitle)
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Create instance of ExperienceDetailViewController
        var detail:ExperienceDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ExperienceDetailViewController") as ExperienceDetailViewController
        
        //Reference ExperienceDetailViewController's var "cellName" and assign it to ExperienceDetailViewController's var "items"
        println(" title text is: \(expMgr.experiences[indexPath.row].m_title)")
        detail.s_title = expMgr.experiences[indexPath.row].m_title
       println(" Desc text is: \(expMgr.experiences[indexPath.row].m_desc)")
        detail.s_desc = expMgr.experiences[indexPath.row].m_desc
        println(" location text is: \(expMgr.experiences[indexPath.row].m_location)")
        detail.s_location = expMgr.experiences[indexPath.row].m_location

        
        //Programmatically push to associated VC (ExperienceDetailViewController)
        self.navigationController?.pushViewController(detail, animated: true)
      
    }
    
    //This code adds animation while displaying table rows
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(1, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    override func tableView(tableView:UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath:NSIndexPath!){
        
        if(editingStyle == UITableViewCellEditingStyle.Delete){
          println(" Index path is \(indexPath.row)")
            expMgr.removeExperience(indexPath.row)
          println(" After deletion")
            tableView.reloadData()
        }
        
    }
    /*
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
