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
import MessageUI



class ExperienceListViewController: UITableViewController {

    var typeList : Array<AnyObject> = []
    
var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    

   
    
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
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "CoreExperience")
        var totalCategories = context.countForFetchRequest(request, error: nil)
        
        if totalCategories > 0 {

        request.predicate = NSPredicate(format: "m_type == %@", g_typeList[g_selectedTypeIndex])
        typeList = context.executeFetchRequest(request, error: nil)!
        println(" TypeList count is \(typeList.count)")
        println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
        
        tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
/*        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "CoreExperience")
        request.predicate = NSPredicate(format: "m_type == %@", g_typeList[g_selectedTypeIndex])
        typeList = context.executeFetchRequest(request, error: nil)!
        println(" TypeList count is \(typeList.count)")
        println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
        
        tableView.reloadData()
  */  }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        println(" Segue identifier is \(segue.identifier)")
        
   }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
    // Return the number of sections.
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    // Return the number of rows in the section.
 
        return typeList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        g_cell = tableView.dequeueReusableCellWithIdentifier("customCell") as customCell
 
            var data:NSManagedObject = typeList[indexPath.row] as NSManagedObject
        
        
            g_cell.d_expTitle.text = data.valueForKeyPath("m_title") as? String
            g_cell.d_expDesc.text = data.valueForKeyPath("m_desc") as? String
        var hasAudioLoc = data.valueForKeyPath("m_audio_location") as? String
        if (hasAudioLoc != nil) {
            g_cell.playButtonList.hidden = true
        }

       let obtainedDate = data.valueForKeyPath("m_date") as NSDate
        
        let dateStringFormatter = NSDateFormatter()
        
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        var obtainedDateString : String = dateStringFormatter.stringFromDate(obtainedDate)
        println(" Obtained date is \(obtainedDateString)")
         g_cell.d_date.text = obtainedDateString
        
        //Set Favourite Flag
        
        var favouriteSelected = data.valueForKeyPath("m_favourites") as Bool
        
        if favouriteSelected == true {
            var image = UIImage (named: "FavSelected.png")
            
            g_cell.d_favouriteFlag.image = UIImage (named: "FavSelected.png")
        } else {
            
            g_cell.d_favouriteFlag.image =  UIImage (named: "FavUnselected.jpeg")       }
        
        
    return g_cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        g_selectedListRow = indexPath.row
        println("Row selected in didSelectRow method is \(g_selectedListRow)")
        
        //Stop playing audio
        
        self.mediaPlayer.stop()
        
        //Obtain reference to selected row  & selected item
        
        var selectedRow = self.tableView.indexPathForSelectedRow()?.row
        var selectedItem : NSManagedObject = self.typeList[selectedRow!] as NSManagedObject
        println("Got reference to selected item")
        
        
        
        //Showing alert controller on selection of row
        
        var refreshAlert = UIAlertController(title: "Action", message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Get audio URL
        
        var docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        var soundURL = selectedItem.valueForKey("m_audio_location") as String
        //      var soundURL = g_experiencesByType[indexPath.row].m_audio_location
        
        println("Printing current selected index : \(g_selectedListRow)")
        
        println("Sound URL is \(soundURL)")
        
        var url = NSURL(fileURLWithPath: docsDir + "/" + soundURL)
        
        println("URL is \(url)")

        if (soundURL.isEmpty) {
            println(" No Audio recorded with experience")
        } else {
        
        refreshAlert.addAction(UIAlertAction(title: "Play audio", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle audio logic here")
          
            
            self.mediaPlayer.stop()
            
            
            self.mediaPlayer.contentURL = url
            
            self.mediaPlayer.play()
        }))
        
        }
        
        refreshAlert.addAction(UIAlertAction(title: "View text", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle view text logic here")
            
            var destinationVC:showTextEntryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showTextEntryViewController") as showTextEntryViewController
   //         var selectedRow = self.tableView.indexPathForSelectedRow()?.row
   //         println("selected row is \(selectedRow)")
   //         var selectedItem : NSManagedObject = self.typeList[selectedRow!] as NSManagedObject
   //         println("Got reference to selected item")
            
            destinationVC.tempTextEntry = selectedItem.valueForKey("m_desc") as String
            println("Got reference to desc")
            
          //  self.presentViewController(refreshAlert, animated: true, completion: nil)
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        }))
        
        var photoLoc = selectedItem.valueForKey("m_location") as String?
        println("Got reference to Photo Loc: \(photoLoc)")
        
        //Get Photo
        
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
       

        
        if ((photoLoc) != nil) {
            
        refreshAlert.addAction(UIAlertAction(title: "View Photo", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle photo logic here")
            
            
            var destinationVC:showImagePickerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showImagePickerViewController") as showImagePickerViewController
            
            if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let dirPath = paths[0] as? String {
                        var photoPath = dirPath.stringByAppendingPathComponent(photoLoc!)
                        println(" Photo Path is \(photoPath)")
                        var imagePhoto = UIImage(named: photoPath)
                        destinationVC.tempPhoto = imagePhoto
                        destinationVC.viewMode = true
                        
                    }
                }
            }
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        }))
        }
        
        refreshAlert.addAction(UIAlertAction(title: "Edit experience", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Edit logic here")
            
            var destinationVC:ExperienceDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ExperienceDetailViewController") as ExperienceDetailViewController
   
            g_selectedTypeIndex = indexPath.row
        
            println("Got reference to second view controller")
            
    //        var selectedRow = self.tableView.indexPathForSelectedRow()?.row
    //        println("selected row is \(selectedRow)")
    //        var selectedItem : NSManagedObject = self.typeList[selectedRow!] as NSManagedObject
    //        println("Got reference to selected item")
            
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
        
        

        
   
        
   //     refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
  //          println("Handle Cancel Logic here")
  //      }))
        refreshAlert.addAction(UIAlertAction(title: "Facebook Post", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle facebook logic here")
            var shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            //        var selectedRow = self.tableView.indexPathForSelectedRow()?.row
            //        var selectedItem : NSManagedObject = self.typeList[selectedRow!] as NSManagedObject
            //        println("Got reference to selected item")
            
            var textTitle = selectedItem.valueForKey("m_title") as String
            var textDesc = selectedItem.valueForKey("m_desc") as String
            
            var textToPost = textTitle + "\r" + textDesc
            
            
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        refreshAlert.addAction(cancelAction)
        
        presentViewController(refreshAlert, animated: true, completion: nil)
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
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "CoreExperience")
        request.predicate = NSPredicate(format: "m_type == %@", g_typeList[g_selectedTypeIndex])
        typeList = context.executeFetchRequest(request, error: nil)!
        println(" TypeList count is \(typeList.count)")
        println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
        
        tableView.reloadData()

        
//        expMgr.listByType()
//    tableView.reloadData()
        }
    
    }
}

extension ExperienceListViewController : MFMailComposeViewControllerDelegate {
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
