//
//  ExperienceListViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit


class ExperienceListViewController: UITableViewController {


    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        println("Unwinding")
    }

    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    //Show the title of ListController as the type selected in Summary VC
    navigationItem.title = g_typeList[g_selectedTypeIndex]
    //Load the various global list arrays per type from database
    expMgr.listByType()
    
    }

    
    
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    
    //Load the various global list arrays per type from database everytime view is refreshed
    expMgr.listByType()
    tableView.reloadData()
    
    
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
    // Return the number of sections.
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    // Return the number of rows in the section.
    return g_experiencesByType.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as UITableViewCell
    
    //Assign the title of each experience to the textLabel of each cell
    cell.textLabel!.text = g_experiencesByType[indexPath.row].m_title
    cell.textLabel!.textColor = UIColor.orangeColor()
    
    return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    //Create instance of ExperienceDetailShowController
    
    var detail:ExperienceDetailShowController = self.storyboard?.instantiateViewControllerWithIdentifier("ExperienceDetailShowController") as ExperienceDetailShowController
    
        
    //Reference ExperienceDetailViewController's var "cellName" and assign it to ExperienceDetailViewController's var "items"
    
    // Prepopulate the fields of detail VC for View /update
    detail.s_title = g_experiencesByType[indexPath.row].m_title
    detail.s_desc = g_experiencesByType[indexPath.row].m_desc
    detail.s_location = g_experiencesByType[indexPath.row].m_location
    
    detail.selectedTitle = g_experiencesByType[indexPath.row].m_title // Set global value to enable update

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
    
    override func tableView(tableView:UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath:NSIndexPath){
    
    if(editingStyle == UITableViewCellEditingStyle.Delete){
    expMgr.removeExperience(indexPath.row)
    expMgr.listByType()
    tableView.reloadData()
    }
    
    }
    
}
