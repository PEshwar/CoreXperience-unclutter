//
//  ExperienceSummaryViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import CoreData

class ExperienceSummaryViewController: UITableViewController {

    var l_typeList = [NSManagedObject]()
    
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
            l_typeList = results
            
            g_typeList.removeAll(keepCapacity: true)
            for element in results {
                var tempString = element.valueForKey("md_category") as String
                println("value for key is \(tempString)")
                g_typeList.append(tempString)
              //  i++
            }
            println("Glist count is \(g_typeList.count)")
            }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
     
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"CoreCategory")
        fetchRequest.returnsObjectsAsFaults = false
        
        var error: NSError?
        let fetchedResults = context.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            l_typeList = results
            g_typeList.removeAll(keepCapacity: true)
            for element in results {
                var tempString = element.valueForKey("md_category") as String
                println("value for key is \(tempString)")
                g_typeList.append(tempString)
                // i++
            }
            println("Glist count is \(g_typeList.count)")
        }
            else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }


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
        return l_typeList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "CoreExperience")
        println(" selected Type is  \(l_typeList[indexPath.row])")
        var cat = l_typeList[indexPath.row].valueForKeyPath("md_category") as? String
      //  var photoLoc = l_typeList[indexPath.row].valueForKeyPath("md_categoryImage") as? String
        var photo = l_typeList[indexPath.row].valueForKeyPath("md_categoryImage") as? UIImage
        
        var cell = tableView.dequeueReusableCellWithIdentifier("summaryCell") as summaryCell
        //Add this line to get the subtitle text
     //   cell = summaryCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier:"summaryCell")
        //Assign the contents of global type list to the textLabel of each cell
        cell.d_labelTitle!.text = cat
    //   cell.textLabel!.textColor = UIColor.orangeColor()
    //    g_typeList.append(cell.d_labelTitle!.text!)
        
        //Retrieve total number of experience entries for the category
        
   

        request.predicate = NSPredicate(format: "m_type == %@", cat!)
        var totalCount = context.countForFetchRequest(request, error: nil)
        
        
        
        var typeList = context.executeFetchRequest(request, error: nil)!
            println(" TypeList count is \(totalCount)")
        //    println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
        cell.d_labelItems!.text = String(totalCount) + " Items"
        cell.d_image.image = l_typeList[indexPath.row].valueForKeyPath("md_categoryImage") as? UIImage
        
        //Get Photo
        
 /*       let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        cell.d_image.image
        
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    var photoPath = dirPath.stringByAppendingPathComponent(photoLoc!)
                    println(" Photo Path is \(photoPath)")
                    var imagePhoto = UIImage(named: photoPath)
                    cell.d_image.image = imagePhoto
                    
                }
            }
        }
*/
        
   /*     //Set image
        if cat == "My experiences with Sadguru" {
        cell.d_image.image = UIImage(named: "Bonsai.jpg")
        } else if cat == "Sadguru's teachings" {
        cell.d_image.image = UIImage(named: "Balaswamiji.jpg")
        } else {
        cell.d_image.image = UIImage(named: "Default-category.jpg")
        }
      */
        
   /*     //Depending on experience type chosen, enter the count of items in subtitle of each cell
        switch (indexPath.row) {
            case 0: cell.detailTextLabel!.text = String(g_experiencesByType1.count) + " Items"
            case 1: cell.detailTextLabel!.text = String(g_experiencesByType2.count) + " Items"
            case 2: cell.detailTextLabel!.text = String(g_experiencesByType3.count) + " Items"
            case 3: cell.detailTextLabel!.text = String(g_experiencesByType4.count) + " Items"
            case 4: cell.detailTextLabel!.text = String(g_experiencesByType5.count) + " Items"
            
            default:
            break
        }
     */
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        var totalCategories : Int = 0
        
        println(" Segue identifier is \(segue.identifier)")
        
        if segue.identifier == "showAddView" {
            println("show add view segue selected")
            
            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            var context: NSManagedObjectContext;
            context = appDel.managedObjectContext!
            
            let fetchRequest = NSFetchRequest(entityName:"CoreCategory")
            fetchRequest.returnsObjectsAsFaults = false
            
            totalCategories = context.countForFetchRequest(fetchRequest, error: nil)
            
            if totalCategories <= 0 {
                println(" No categories found")
                var categoryAlert = UIAlertController(title: "Action", message: "Add categories first before adding experience", preferredStyle: UIAlertControllerStyle.Alert)
                categoryAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                presentViewController(categoryAlert, animated: true, completion: nil)
            }
            
        }
        
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

