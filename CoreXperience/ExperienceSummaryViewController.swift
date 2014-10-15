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
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        

     expMgr.listByType()
     tableView.reloadData()
        
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
        return g_typeList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell") as UITableViewCell
        //Add this line to get the subtitle text
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier:"SummaryCell")
        //Assign the contents of global type list to the textLabel of each cell
        cell.textLabel!.text = g_typeList[indexPath.row]
        cell.textLabel!.textColor = UIColor.orangeColor()
        
        
        //Depending on experience type chosen, enter the count of items in subtitle of each cell
        switch (indexPath.row) {
            case 0: cell.detailTextLabel!.text = String(g_experiencesByType1.count) + " Items"
            case 1: cell.detailTextLabel!.text = String(g_experiencesByType2.count) + " Items"
            case 2: cell.detailTextLabel!.text = String(g_experiencesByType3.count) + " Items"
            case 3: cell.detailTextLabel!.text = String(g_experiencesByType4.count) + " Items"
            case 4: cell.detailTextLabel!.text = String(g_experiencesByType5.count) + " Items"
            
            default:
            break
        }
        
        return cell
    }
    
   
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Create instance of ExperienceListViewController
        var detail:ExperienceListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ExperienceListViewController") as ExperienceListViewController
        
        //In this implementation no variable of list controller is being set from here. But global variables are used by LC to load data
        
        
        //update global variable for type selected in summary VC (for use in other view controllers)
        g_selectedTypeIndex = indexPath.row
        
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
    
  
}
