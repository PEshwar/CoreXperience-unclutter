//
//  ExperienceListViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import MediaPlayer
import Social
import CoreData


class ExperienceListViewController: UITableViewController {

    var typeList : Array<AnyObject> = []
    
var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    
    @IBAction func favButtonPressed(sender: AnyObject) {
        println("Favourite button pressed")
  
        
        
    }
   
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        println("Share button pressed")
        var shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        var textToPost = g_experiencesByType[g_selectedListRow].m_title + "\r " + g_experiencesByType[g_selectedListRow].m_desc
        shareToFacebook.setInitialText(textToPost)
        self.presentViewController(shareToFacebook, animated:true,completion:nil)
        
    }
    
    
    @IBAction func playPressed(sender: UIButton) {
        
          mediaPlayer.stop()
        var docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        var soundURL = g_experiencesByType[g_selectedListRow].m_audio_location
        
        println("Printing current selected index : \(g_selectedListRow)")
        
        println("Sound URL is \(soundURL)")
        
        var url = NSURL(fileURLWithPath: docsDir + "/" + soundURL)
        
        println("URL is \(url)")
        
        
        mediaPlayer.contentURL = url
        
        mediaPlayer.play()
        
    }
    
    
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
//    expMgr.listByType()
//    tableView.reloadData()
    
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "CoreExperience")
        request.predicate = NSPredicate(format: "m_type == %@", g_typeList[g_selectedTypeIndex])
        typeList = context.executeFetchRequest(request, error: nil)!
        println(" TypeList count is \(typeList.count)")
        println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        println(" Segue identifier is \(segue.identifier)")
        
       if (segue.identifier == "showDetailView") {
            //get a reference to the destination view controller
            println("Getting reference to second view controller")
       
        let destinationVC:ExperienceDetailViewController = segue.destinationViewController as ExperienceDetailViewController
        println("Got reference to second view controller")
        
        var selectedRow = self.tableView.indexPathForSelectedRow()?.row
               println("selected row is \(selectedRow)")
            var selectedItem : NSManagedObject = typeList[selectedRow!] as NSManagedObject
               println("Got reference to selected item")
          
            destinationVC.s_title = selectedItem.valueForKey("m_title") as String
             println("Got reference to title")
            destinationVC.s_desc = selectedItem.valueForKey("m_desc") as String
            println("Got reference to desc")
        
            destinationVC.s_type = selectedItem.valueForKey("m_type") as String
            println("Got reference to type")
        
            destinationVC.s_favourites = selectedItem.valueForKey("m_favourites") as Bool
            println("Got reference to desc")
        
            destinationVC.s_audio_location = selectedItem.valueForKey("m_audio_location") as String
            println("Got reference to audio location ")
        
            destinationVC.s_date = selectedItem.valueForKey("m_date") as NSDate
            println("Got reference to Date")
        
        destinationVC.s_favourites = selectedItem.valueForKey("m_favourites") as Bool
        
            destinationVC.existingItem = selectedItem
            println("Got reference to existingItem")
            
            
            println("Going to set delegate")
            
            //set properties on the destination view controller
         
            
       //     destinationVC.delegateDetail = self
            //etc...
            println("finished setting delegate")
            
            
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
    // Return the number of sections.
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    // Return the number of rows in the section.
  //  return g_experiencesByType.count
        return typeList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        g_cell = tableView.dequeueReusableCellWithIdentifier("customCell") as customCell
 
            var data:NSManagedObject = typeList[indexPath.row] as NSManagedObject
            g_cell.d_expTitle.text = data.valueForKeyPath("m_title") as? String
            g_cell.d_expDesc.text = data.valueForKeyPath("m_desc") as? String
        
        //   cell = customCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier:"customCell")
    
    //Assign the title of each experience to the textLabel of each cell
//    cell.textLabel!.text = g_experiencesByType[indexPath.row].m_title
//    cell.textLabel!.textColor = UIColor.orangeColor()
  
   //     g_cell.d_expTitle.text = g_experiencesByType[indexPath.row].m_title
   //     g_cell.d_expDesc.text = g_experiencesByType[indexPath.row].m_desc
       
        //Obtain and convert date to string
        
 //       let obtainedDate = g_experiencesByType[indexPath.row].m_date
       let obtainedDate = data.valueForKeyPath("m_date") as NSDate
        
        let dateStringFormatter = NSDateFormatter()
        
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        var obtainedDateString : String = dateStringFormatter.stringFromDate(obtainedDate)
        println(" Obtained date is \(obtainedDateString)")
         g_cell.d_date.text = obtainedDateString
   //     g_cell.playIcon.text = "▶️"
        
    // Set the subtitles in list view
//    cell.detailTextLabel!.text = obtainedDateString + "  " + g_experiencesByType[indexPath.row].m_desc
//    cell.detailTextLabel!.textColor = UIColor.purpleColor()
  //      println("after displaying text and subtitle")
        
   //     cell.setCell()
        
        //Set Favourite Flag
        
        var favouriteSelected = data.valueForKeyPath("m_favourites") as Bool
        
        if favouriteSelected == true {
            var image = UIImage (named: "FavSelected.png")
            
            g_cell.d_favouriteFlag.setImage(image, forState: .Normal)
        } else {
            var image = UIImage (named: "FavUnselected.jpeg")
            
            g_cell.d_favouriteFlag.setImage(image, forState: .Normal)
        }
        
        

        
        
    return g_cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
 /*       println("Inside tableList view : did select row. index path is \(indexPath.row)")
        mediaPlayer.stop()
    
       
        var docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
 
        var soundURL = g_experiencesByType[indexPath.row].m_audio_location
        g_selectedListRow = indexPath.row
        println("Printing current selected index : \(indexPath.row)")
        
        println("Sound URL is \(soundURL)")
        
        var url = NSURL(fileURLWithPath: docsDir + "/" + soundURL)
        
        println("URL is \(url)")
        
     
        mediaPlayer.contentURL = url

        mediaPlayer.play()
*/
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


