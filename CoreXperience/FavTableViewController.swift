//
//  FavTableViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 05/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import CoreData
import MediaPlayer
import Social
import MessageUI

class FavTableViewController: UITableViewController {

    var favList : Array<AnyObject> = []
    var filteredSearchList : Array<AnyObject> = []
    var commonList : Array<AnyObject> = []
    
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()

    @IBAction func donePressed(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
  //           request.predicate = NSPredicate(format: "m_favourites == %@", true)
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        println("Fav count is \(favList.count)")
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            println(" filtered search count is \(self.filteredSearchList.count)")
            return self.filteredSearchList.count
            
        } else {
            println(" fav List count is \(self.favList.count)")
            
            return self.favList.count
        }
        
    }

    
   
      
      override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        var cell = self.tableView.dequeueReusableCellWithIdentifier("favCell") as UITableViewCell
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            var data: NSManagedObject = filteredSearchList[indexPath.row] as NSManagedObject
            // Configure the cell
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier:"favCell")
            var tempCategory = data.valueForKeyPath("m_type") as? String
            var tempTitle = data.valueForKeyPath("m_title") as? String
            cell.textLabel!.text = tempCategory! + ":   " + tempTitle!
            cell.detailTextLabel!.text = data.valueForKeyPath("m_desc") as? String
        } else {

        var data: NSManagedObject = favList[indexPath.row] as NSManagedObject
       cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier:"favCell")
        // Configure the cell
            var tempCategory = data.valueForKeyPath("m_type") as? String
            var tempTitle = data.valueForKeyPath("m_title") as? String
            cell.textLabel!.text = tempCategory! + ":   " + tempTitle!
       //     cell.textLabel!.text = data.valueForKeyPath("m_title") as? String
            cell.detailTextLabel!.text = data.valueForKeyPath("m_desc") as? String
            cell.detailTextLabel!.textColor = UIColor.purpleColor()
            

            
        }
        
  /*      var cell = tableView.dequeueReusableCellWithIdentifier("favCell") as favCellTableViewCell
        
      //  var data:NSManagedObject = NSManagedObject()
        var data:NSManagedObject = favList[indexPath.row] as NSManagedObject
        if tableView == self.searchDisplayController!.searchResultsTableView {
            data = filteredSearchList[indexPath.row] as NSManagedObject
        }
     
        //Assign the contents of global type list to the textLabel of each cell
       // var data:NSManagedObject = favList[indexPath.row] as NSManagedObject
        cell.d_expTitle!.text = data.valueForKeyPath("m_title") as? String
        cell.d_expDesc!.text = data.valueForKeyPath("m_desc") as? String
        cell.d_expCategory!.text = data.valueForKeyPath("m_type") as? String
     //   cell.textLabel!.textColor = UIColor.orangeColor()
        
        var tempDate = data.valueForKeyPath("m_date") as? NSDate
        
        println(" Fav Title is \(cell.d_expTitle!.text)")
        println(" Fav Desc is \(cell.d_expDesc!.text)")
        println(" Fav Type is \(cell.d_expCategory!.text)")
        
        let dateStringFormatter = NSDateFormatter()
        
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        var obtainedDateString : String = dateStringFormatter.stringFromDate(tempDate!)
        var tempType = data.valueForKeyPath("m_type") as? String
        var detailCombined =  obtainedDateString + "  " + tempType!
   //     cell.d_date!.text = obtainedDateString
 //       cell.detailTextLabel!.textColor = UIColor.purpleColor()
      
        
     /*
        let obtainedDate = data.valueForKeyPath("m_date") as NSDate
        
        let dateStringFormatter = NSDateFormatter()
        
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        var obtainedDateString : String = dateStringFormatter.stringFromDate(obtainedDate)
        println(" Obtained date is \(obtainedDateString)")
        g_cell.d_date.text = obtainedDateString
        
        */
        
        
        //Set Photo
        
        var photoLoc = data.valueForKeyPath("m_location") as? String
        println("Got reference to Photo Loc: \(photoLoc)")
        
        var count  = photoLoc?.utf16Count
        println("UTF 16 count is \(count)")
        
        //Get Photo
        
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        
        
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    var photoPath = dirPath.stringByAppendingPathComponent(photoLoc!)
                    println(" Photo Path is \(photoPath)")
                    if count > 1 {
                        var imagePhoto = UIImage(named: photoPath)
                        cell.d_image.image = imagePhoto
                    }
                }
            }
        }
*/
        
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        g_selectedListRow = indexPath.row
        println("Row selected in didSelectRow method is \(g_selectedListRow)")
        
        //Stop playing audio
        
        self.mediaPlayer.stop()
       
        // Get reference to selected Row and Item
        var selectedRow = self.tableView.indexPathForSelectedRow()?.row
        
        var selectedItem : NSManagedObject = self.favList[selectedRow!] as NSManagedObject
        println("Got reference to selected item")
        
        
        //Showing alert controller on selection of row
        var refreshAlert = UIAlertController(title: "Action", message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Play audio", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle audio logic here")
            
            
            self.mediaPlayer.stop()
            var docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            
         var soundURL = selectedItem.valueForKey("m_audio_location") as String
            
     //     var  soundURL = g_experiencesByType[indexPath.row].m_audio_location
            
            println("Printing current selected index : \(g_selectedListRow)")
            
            println("Sound URL is \(soundURL)")
            
            var url = NSURL(fileURLWithPath: docsDir + "/" + soundURL)
            
            println("URL is \(url)")
            
            
            self.mediaPlayer.contentURL = url
            
            self.mediaPlayer.play()
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "View text", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle view text logic here")
            
            var destinationVC:showTextEntryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showTextEntryViewController") as showTextEntryViewController
     //       var selectedRow = self.tableView.indexPathForSelectedRow()?.row
     //       println("selected row is \(selectedRow)")
     //       var selectedItem : NSManagedObject = self.favList[selectedRow!] as NSManagedObject
     //       println("Got reference to selected item")
            
            destinationVC.tempTextEntry = selectedItem.valueForKey("m_desc") as String
            println("Got reference to desc")
            
            //  self.presentViewController(refreshAlert, animated: true, completion: nil)
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "View photo", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle photo logic here")
            
            var destinationVC:showImagePickerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showImagePickerViewController") as showImagePickerViewController
            
            //       var selectedRow = self.tableView.indexPathForSelectedRow()?.row
            //       println("selected row is \(selectedRow)")
            //       var selectedItem : NSManagedObject = self.favList[selectedRow!] as NSManagedObject
            //       println("Got reference to selected item")
            
            var photoLoc = selectedItem.valueForKey("m_location") as String
            println("Got reference to photo location")
            
            
            let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
            if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let dirPath = paths[0] as? String {
                        var photoPath = dirPath.stringByAppendingPathComponent(photoLoc)
                        println(" Photo Path is \(photoPath)")
                        var imagePhoto = UIImage (named: photoPath)
                        destinationVC.tempPhoto = imagePhoto
                        destinationVC.viewMode = true
                    }
                }
            }
            
            
            //  self.presentViewController(refreshAlert, animated: true, completion: nil)
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Edit experience", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Edit logic here")
            
            var destinationVC:ExperienceDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ExperienceDetailViewController") as ExperienceDetailViewController
            
            
            
            g_selectedTypeIndex = indexPath.row
            
            
            
            
            
            
            println("Got reference to second view controller")
            
      //      var selectedRow = self.tableView.indexPathForSelectedRow()?.row
      //      println("selected row is \(selectedRow)")
      //      var selectedItem : NSManagedObject = self.favList[selectedRow!] as NSManagedObject
      //      println("Got reference to selected item")
            
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
            
            destinationVC.s_location = selectedItem.valueForKey("m_location") as String
            println("Got reference to Photo location \(destinationVC.s_location)")
            
            destinationVC.existingItem = selectedItem
            println("Got reference to existingItem")
            
            
            println("Going to set delegate")
            
            //set properties on the destination view controller
            
            
            //     destinationVC.delegateDetail = self
            //etc...
            println("finished setting delegate")
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
            
        }))

        
        

        
        
        refreshAlert.addAction(UIAlertAction(title: "Facebook Post", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle facebook logic here")
            var shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            //        var textToPost = g_experiencesByType[indexPath.row].m_title + "\r " + g_experiencesByType[indexPath.row].m_desc
            //        var selectedRow = self.tableView.indexPathForSelectedRow()?.row
            //        var selectedItem : NSManagedObject = self.favList[selectedRow!] as NSManagedObject
            //        println("Got reference to selected item")
            
            var textTitle = selectedItem.valueForKey("m_title") as String
            var textDesc = selectedItem.valueForKey("m_desc") as String
            
            var textToPost = textTitle + "\r" + textDesc
            //        var textToPost = g_experiencesByType[indexPath.row].m_title + "\r " + g_experiencesByType[indexPath.row].m_desc
            
            shareToFacebook.setInitialText(textToPost)
            
            //Share photo if photo is available
            
            var photoLoc = selectedItem.valueForKey("m_location") as String
            println("Got reference to photo location")
            
            
            let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
            if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let dirPath = paths[0] as? String {
                        var photoPath = dirPath.stringByAppendingPathComponent(photoLoc)
                        
                        println(" Photo Path is \(photoPath)")
                        
                        var imagePhoto = UIImage (named: photoPath)
                        shareToFacebook.addImage(imagePhoto)
                    }
                }
            }
            
            self.presentViewController(shareToFacebook, animated:true,completion:nil)
        }))

        

        
        refreshAlert.addAction(UIAlertAction(title: "Send email", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle email logic here")
            
            var emailTitle = selectedItem.valueForKey("m_title") as String
            var messageBody = selectedItem.valueForKey("m_desc") as String
            var toRecipents = ["itripuram@yahoo.co.in"]
            
            //    var mailcapability = self.canSendMail()
            var mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            
            //Include an attachment
            
            //Share photo if photo is available
            var photoLoc = selectedItem.valueForKey("m_location") as String
            println("Got reference to photo location")
            
            
            let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
            if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let dirPath = paths[0] as? String {
                        var photoPath = dirPath.stringByAppendingPathComponent(photoLoc)
                        
                        println(" Photo Path is \(photoPath)")
                        
                        var imagePhoto = UIImage (named: photoPath)
                        
                        var imageData = UIImageJPEGRepresentation(imagePhoto, 1.0)
                        
                        mc.addAttachmentData(imageData, mimeType: "image/jped", fileName:     "image")
                        
                        //add audio file
                        var docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                        
                        var soundURL = selectedItem.valueForKey("m_audio_location") as String
                        //      var soundURL = g_experiencesByType[indexPath.row].m_audio_location
                        
                        println("Printing current selected index : \(g_selectedListRow)")
                        
                        println("Sound URL is \(soundURL)")
                        
                        var url = NSURL(fileURLWithPath: docsDir + "/" + soundURL)
                        
                        let audioData = NSData(contentsOfURL: url)
                        
                        mc.addAttachmentData(audioData, mimeType: "audio/mp4", fileName:     "audio")
                        
                        println("going to present VC")
                        
                        self.presentViewController(mc, animated: true, completion: nil)
                        println("Finished presenting  VC")
                        
                    } } }
            
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
        
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
    
/*    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        g_cell = tableView.dequeueReusableCellWithIdentifier("customCell") as customCell
        
        var data:NSManagedObject = favList[indexPath.row] as NSManagedObject
        g_cell.d_expTitle.text = data.valueForKeyPath("m_title") as? String
        g_cell.d_expDesc.text = data.valueForKeyPath("m_desc") as? String
        var hasAudioLoc = data.valueForKeyPath("m_audio_location") as? String
        if (hasAudioLoc != nil) {
            g_cell.playButtonList.hidden = true
        }
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
            
            g_cell.d_favouriteFlag.image = UIImage (named: "FavSelected.png")
        } else {
            
            g_cell.d_favouriteFlag.image =  UIImage (named: "FavUnselected.jpeg")       }
        
        
        
        
        
        return g_cell
    }*/
}

extension FavTableViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            NSLog("Mail cancelled")
        case MFMailComposeResultSaved.value:
            NSLog("Mail saved")
        case MFMailComposeResultSent.value:
            NSLog("Mail sent")
        case MFMailComposeResultFailed.value:
            NSLog("Mail sent failure: %@", [error.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
}

extension FavTableViewController: UISearchBarDelegate, UISearchDisplayDelegate {

func filterContentForSearchText(searchText: String) {
// Filter the array using the filter method
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var context: NSManagedObjectContext;
    context = appDel.managedObjectContext!
    var request = NSFetchRequest(entityName: "CoreExperience")
//  request.predicate = NSPredicate(format: "m_type ==  %@", searchText)
  //  request.predicate = NSPredicate(format: "m_type CONTAINS[c] %@", searchText)
  //  request.predicate = NSPredicate(format: "m_type contains[c] \(searchText)", argumentArray: nil)
//    request.predicate = NSPredicate(format: "m_type Contains %@", searchText)
//    favList = context.executeFetchRequest(request, error: nil)!
    var i: Int = 0
    println(" Fav List has count of \(favList.count)")
    for element in favList {
        var tempDesc = element.valueForKey("m_desc") as String
        var tempTitle = element.valueForKey("m_title") as String
        if ((tempDesc.rangeOfString(searchText) != nil) || (tempTitle.rangeOfString(searchText) != nil))  {
        println("value for Desc is \(tempDesc)")
            println("value for Title is \(tempTitle)")
            println("i = \(i)")
            filteredSearchList.append(favList[i])
            
        }
        i++
    }

    
 //   filteredSearchList = context.executeFetchRequest(request, error: nil)!
    println(" Fav TypeList count is \(favList.count)")
    println(" Filtered TypeList count is \(filteredSearchList.count)")
    
   // filteredSearchList = ["Appaji", "Balaswamiji","My notes","Miscellaneous"]
    }
func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
println(" Entering search Display controller")
    filteredSearchList.removeAll(keepCapacity: true)
    self.filterContentForSearchText(searchString)
    println(" Exiting search Display controller")
return true
}

func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
    self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
    return true
}

}

