//
//  collectionViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 22/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import CoreData
//let reuseIdentifier = "Cell"

class collectionViewController: UICollectionViewController {

   
    @IBOutlet var catCollectionView: UICollectionView!

    var l_typeList = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
   //     self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.clearsSelectionOnViewWillAppear = true
        
        // Do any additional setup after loading the view.
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 90)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
     // Get data from table
        
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
    
 //       println(" No of items in collection from table is during view did load \(l_typeList.count)")
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
 //       println(" Hello- in view will appear ")
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
   //     println(" No of items in collection from table is during view will appear is \(l_typeList.count)")
//        println(" Hello- in view will appear: finished fetching new collection cells ")
        collectionView.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView,
        shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
    }
    
    override func collectionView(collectionView: UICollectionView,
        canPerformAction action: Selector,
        forItemAtIndexPath indexPath: NSIndexPath,
        withSender sender: AnyObject!) -> Bool {
            return true
    }
    
    override func viewDidAppear(animated: Bool) {
        catCollectionView.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
  //      println(" Tapped item at indexpath \(indexPath.row)")
        
        var collectionAlert = UIAlertController(title: "Action", message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.Alert)
        collectionAlert.addAction(UIAlertAction(title: "Change Image", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Change image logic here")
            
        }))
        collectionAlert.addAction(UIAlertAction(title: "Delete Category", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle delete logic here")
            
            // Delete the row from the data source
            var persistenceHelper: ExperiencePersistenceHelper = ExperiencePersistenceHelper()
            
            var valueToBeDeleted = self.l_typeList[indexPath.row].valueForKeyPath("md_category") as? String
            println ("Value to be deleted is \(valueToBeDeleted) at index path: \(indexPath.row)")
            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            var context: NSManagedObjectContext;
            context = appDel.managedObjectContext!
            
            
            
            var typeList : Array<AnyObject> = []
            //   var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            //   var context: NSManagedObjectContext;
            context = appDel.managedObjectContext!
            
            //Check if there are experience entries for that category
            
            
            var request = NSFetchRequest(entityName: "CoreExperience")
            println(" selected Type is  \(self.l_typeList[indexPath.row])")
            var cat = self.l_typeList[indexPath.row].valueForKeyPath("md_category") as? String
            
            request.predicate = NSPredicate(format: "m_type == %@", valueToBeDeleted!)
            var totalCount = context.countForFetchRequest(request, error: nil)
            if totalCount > 0 {
                println(" \(totalCount) experiences found for this category \(valueToBeDeleted)")
                var categoryAlert = UIAlertController(title: "Warning", message: " \(totalCount) experience(s) exist for this category, you cannot delete", preferredStyle: UIAlertControllerStyle.Alert)
                categoryAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Destructive, handler: nil))
                self.presentViewController(categoryAlert, animated: true, completion: nil)
                
            } else {
                // Delete category if there are no experiences for the category selected for deletion
                println("Going to delete category \(valueToBeDeleted)")
                persistenceHelper.remove("CoreCategory", key: "md_category", value: valueToBeDeleted!)
                println("Finished deleting category \(valueToBeDeleted)")
                println(" Going to delete collectionView at \(indexPath.row)")
     //           let deleteIndexPath = self.catCollectionView.indexPathsForSelectedItems()[0] as NSIndexPath
                let deleteIndexPath : NSArray = [indexPath]
                self.catCollectionView.deleteItemsAtIndexPaths(deleteIndexPath)
                
                let fetchRequest = NSFetchRequest(entityName:"CoreCategory")
                fetchRequest.returnsObjectsAsFaults = false
                var error: NSError?
                let fetchedResults = context.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
                
                if let results = fetchedResults {
                    self.l_typeList = results
                println(" Refreshed the collection view after deleting, now total categories are \(self.l_typeList.count)")}
                else {
                    println("Could not fetch \(error), \(error!.userInfo)")
                } }
            g_typeList.removeAll(keepCapacity: true)
           
       //     self.navigationController?.popToRootViewControllerAnimated(true)
            
            self.catCollectionView.reloadData()
            
            
            /////End Delete
            
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        collectionAlert.addAction(cancelAction)
        
        presentViewController(collectionAlert, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return l_typeList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as CollectionViewCell
        
        cell.backgroundColor = UIColor.purpleColor()
  //      cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
    
        //Get category photo
        
        var photoLoc =  l_typeList[indexPath.row].valueForKeyPath("md_categoryImage") as? String
        
        //Get category name
        
         cell.textLabel?.text = l_typeList[indexPath.row].valueForKeyPath("md_category") as? String
        cell.textLabel?.textColor =
            UIColor.whiteColor()
       
        //Get Photo
        
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        
        
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    var photoPath = dirPath.stringByAppendingPathComponent(photoLoc!)
                    println(" Photo Path is \(photoPath)")
                    var imagePhoto = UIImage(named: photoPath)
                    cell.imageView?.image = imagePhoto
       
                }}}
   //     cell.imageView?.image = UIImage(named: "Appaji.jpg")
        
        //Insert into collection view
        
     //   collectionView.insertItemsAtIndexPaths([indexPath.row])
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView!, shouldHighlightItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView!, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, canPerformAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, performAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) {
    
    }
    */


  
    }
    

