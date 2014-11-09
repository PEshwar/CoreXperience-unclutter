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

      var l_typeList = [NSManagedObject]()
    
    @IBAction func addCategoryPressed(sender: AnyObject) {
       
        func wordEntered(alert: UIAlertAction!){
            // store the new word
            //self.textView2.text = deletedString + " " + self.newWordField.text
        println(" New Category entered is ")
        }
        
        //Showing alert controller for add category
        var inputTextField: UITextField?
        var categoryAlert = UIAlertController(title: "Action", message: "Enter name of category to add", preferredStyle: UIAlertControllerStyle.Alert)
        categoryAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        categoryAlert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // Now do whatever you want with inputTextField (remember to unwrap the optional)
            var categoryText = inputTextField?.text
            
            
            println(" Category entered is \(inputTextField?.text)")
            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            var context: NSManagedObjectContext;
            context = appDel.managedObjectContext!
            let ent = NSEntityDescription.entityForName("CoreCategory", inManagedObjectContext: context)
            //Createa instance of model Category class
            var newCategory = modelCategory(entity: ent!, insertIntoManagedObjectContext: context)
            newCategory.md_category = categoryText!
      //      var charCount = countElements(categoryText)
        //    println("Char count is \(charCount)")
        //    if charCount > 0 {
            context.save(nil)
            println("Context Saved")
            
      //      g_typeList.append(categoryText!)
            

           //Reload data
            
            let fetchRequest = NSFetchRequest(entityName:"CoreCategory")
            fetchRequest.returnsObjectsAsFaults = false
            
            var error: NSError?
            let fetchedResults = context.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
            
            if let results = fetchedResults {
                self.l_typeList = results }
                else {
                println("Could not fetch \(error), \(error!.userInfo)")
            }
            
            g_typeList.removeAll(keepCapacity: true)
         
            self.tableView.reloadData()
         //   }
        }))
        
        categoryAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.textColor = UIColor.orangeColor()
            inputTextField = textField
            //textField.secureTextEntry = true
            })
            
     presentViewController(categoryAlert, animated: true, completion: nil)
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

            var cell = tableView.dequeueReusableCellWithIdentifier("categoryCell") as UITableViewCell
            //Add this line to get the subtitle text
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier:"categoryCell")
            //Assign the contents of global type list to the textLabel of each cell
            cell.textLabel!.text = l_typeList[indexPath.row].valueForKeyPath("md_category") as? String
            cell.textLabel!.textColor = UIColor.orangeColor()

        // Configure the cell...
    g_typeList.append(cell.textLabel!.text!)

        return cell
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
            println(" selected Type is  \(l_typeList[indexPath.row])")
            var cat = l_typeList[indexPath.row].valueForKeyPath("md_category") as? String
            
            request.predicate = NSPredicate(format: "m_type == %@", valueToBeDeleted!)
            var totalCount = context.countForFetchRequest(request, error: nil)
            if totalCount > 0 {
                println(" \(totalCount) experiences found for this category \(valueToBeDeleted)")
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
