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
import AVFoundation
import AudioToolbox



class ExperienceListViewController: UITableViewController {

    var typeList : Array<AnyObject> = []
    
var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    

var audioPlayer:AVAudioPlayer!
   
//custom cell 
    
    var g_cell = customCell ()
    


    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    //Show the title of ListController as the type selected in Summary VC
    navigationItem.title = g_typeList[g_selectedTypeIndex]
       
    //Load the various global list arrays per type from database
  
        
        
        //Set image in navigation bar
        /* Create an Image View to replace the Title View */
 /*       let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named:"Balaswamiji.jpg")
        
        imageView.image = image
        
        /* Set the Title View */
        navigationItem.titleView = imageView
   */
    
    }

    
    
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    
    //Load the various global list arrays per type from database everytime view is refreshed

        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "CoreExperience")
        var totalCategories = context.countForFetchRequest(request, error: nil)
        
        if totalCategories > 0 {
        println(" In view will appear of List conroller- value of index is \(g_selectedTypeIndex)")
        request.predicate = NSPredicate(format: "m_type == %@", g_typeList[g_selectedTypeIndex])
        typeList = context.executeFetchRequest(request, error: nil)!
        println(" TypeList count is \(typeList.count)")
        println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
        
        tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
 }
    
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
        
        
        //Set Photo
        
      println("LVC,CFRAIP, BB GetBlobPhoto")
     //   var blob_photo = data.valueForKeyPath("m_photo_blob") as UIImage
        
        var blob_photo = NSData()
        
    //    if blob_photo.length > 0 {
        // blob_photo = data.valueForKeyPath("m_photo_blob") as NSData
        blob_photo = data.valueForKey("m_photo_blob") as NSData
            println("LVC,CFRAIP, AA GetBlobPhoto")
    //    if blob_photo.size.width > 0 {
        
        
         //   g_cell.d_listImage.image = blob_photo
            g_cell.d_listImage.image = UIImage(data: blob_photo)
            
      //  } else {
      // println(" No photo present in database, getting default experience image")
      //      g_cell.d_listImage.image = getExperienceDefaultImage()
            
       // }
/*
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
                    g_cell.d_listImage.image = imagePhoto
                    } 
                    }
            }
        }
*/
    return g_cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        
        //Stop playing audio
        
        self.mediaPlayer.stop()
       
        
        //Obtain reference to selected row  & selected item
        
        var selectedRow = self.tableView.indexPathForSelectedRow()?.row
        var selectedItem : NSManagedObject = self.typeList[selectedRow!] as NSManagedObject
        println("Got reference to selected item")
   
        showActionListExperience(selectedItem)
        
       

   }
    
    
        
    
    //This code adds animation while displaying table rows
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
    cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
    UIView.animateWithDuration(1, animations: {
    cell.layer.transform = CATransform3DMakeScale(1,1,1)
    })
    }
    
    
    // Delete an experience
    
    override func tableView(tableView:UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath:NSIndexPath){
    
    if(editingStyle == UITableViewCellEditingStyle.Delete){

        
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "CoreExperience")
        request.returnsObjectsAsFaults = false
       
        //Obtain reference to selected row  & selected item
        
    //    var selectedRow = self.tableView.indexPathForSelectedRow()?.row
        var selectedItem : NSManagedObject = self.typeList[indexPath.row] as NSManagedObject
        println("Got reference to selected item")
        var textTitle = selectedItem.valueForKey("m_title") as String
       
        request.predicate = NSPredicate(format: "m_title == %@", textTitle)
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count>0){
            
            var res = results[0] as NSManagedObject
            context.deleteObject(res)
            context.save(nil)
            
        }
        
        request.predicate = NSPredicate(format: "m_type == %@", g_typeList[g_selectedTypeIndex])
        typeList = context.executeFetchRequest(request, error: nil)!
        println(" TypeList count is \(typeList.count)")
        println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
        
        tableView.reloadData()
        
        

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

extension ExperienceListViewController {
    
    @IBAction func unwindToExperienceListViewController (sender: UIStoryboardSegue){
        // bug? exit segue doesn't dismiss so we do it manually...
        println(" In unwind seque -> after cancel button pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ExperienceListViewController {
    func showActionListExperience(selectedItem : NSManagedObject) {
        
        //Get various attributes from context
        var blobAudioTemp = NSData?()
        var blobAudio = NSData()
        blobAudioTemp = selectedItem.valueForKey("m_audio_blob") as? NSData
        if blobAudioTemp?.length > 0 {
            blobAudio = blobAudioTemp!
            println(" Manaaged to get BlobAudio fom database. length is \(blobAudio.length)")
        } else {
            println(" NOT Manaaged to get BlobAudio fom database")
        }
        var soundURL = selectedItem.valueForKey("m_audio_location") as String
        var photoLoc = selectedItem.valueForKey("m_location") as String?
        println("LVC, SALE, BB GetBlobPhoto")
         var blob_photo = selectedItem.valueForKey("m_photo_blob") as NSData
        println("LVC, SALE, AA GetBlobPhoto")
        var title = selectedItem.valueForKey("m_title") as String
        var text = selectedItem.valueForKey("m_desc") as String
        var type = selectedItem.valueForKey("m_type") as String
        var favourite = selectedItem.valueForKey("m_favourites") as Bool
        var audioExists = selectedItem.valueForKey("m_audio_location") as String
        var dateExp = selectedItem.valueForKey("m_date") as NSDate
        var location = selectedItem.valueForKey("m_location") as String
       
     
        
        //Showing alert controller on selection of row
        
        var refreshAlert = UIAlertController(title: "Action", message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Get audio blob from db and play
        
        
        
        //Get audio URL
        
        var docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        
        
        
        //    println("Printing current selected index : \(g_selectedListRow)")
        
        println("Sound URL is \(soundURL)")
        
        var url = NSURL(fileURLWithPath: docsDir + "/" + soundURL)
        
        println("URL is \(url)")
    //    var count  = soundURL.utf16Count
    //    println("UTF 16 count is \(count)")
    //    println("Count of audio location is \(count)")
        if (blobAudio.length > 0) {
            
            refreshAlert.addAction(UIAlertAction(title: "Play audio", style: .Default, handler: { (action: UIAlertAction!) in
                println("Handle audio logic here")
                
                
                self.mediaPlayer.stop()
                
                //Try alternative way to play
                
                if  blobAudio.length <= 0 {
                    println("No audio has been recorded")
                } else {
                    println("Audio found, will be playing, byte length is \(blobAudio.length)")
               
                }
                //    self.mediaPlayer.contentURL = url
                
                
                var fileMgr = NSFileManager()
                var stringURL = url?.absoluteString
     //           var successAudio = fileMgr.createFileAtPath(docsDir, contents: blobAudio, attributes: nil)
                var filePath = docsDir.stringByAppendingPathComponent("audio.m4a")
               var removeSuccess = fileMgr.removeItemAtPath(filePath, error: nil)
               
                if removeSuccess {
                    println("Audio file removed successfully")
                }
                
                var successFile = fileMgr.createFileAtPath(filePath, contents: blobAudio, attributes: nil)
                
       //         println("Success in writing audio to disk is \(successAudio), and file name is \(stringURL)")
                println("Success in writing file to disk is \(successFile), and file name is \(filePath)")
                var fileURL = NSURL(fileURLWithPath: filePath)
                self.mediaPlayer.contentURL = fileURL
                println("Going to play audio from file location that was just saved")
                //End different way to play sound
                self.mediaPlayer.play()
                
            }))
            
        } else {
            println(" No Audio file- so no menu option")
        }
        
        refreshAlert.addAction(UIAlertAction(title: "View text", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle view text logic here")
            
            var destinationVC:showTextEntryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showTextEntryViewController") as showTextEntryViewController
            
            destinationVC.tempTextEntry = text
            println("Got reference to desc")
            
            //  self.presentViewController(refreshAlert, animated: true, completion: nil)
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        }))
        
        
        println("Got reference to Photo Loc: \(photoLoc)")
        
        //Get Photo
        
        
        
        refreshAlert.addAction(UIAlertAction(title: "View Photo", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle photo logic here")
            
            
   //         var destinationVC:showImagePickerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showImagePickerViewController") as showImagePickerViewController
            var destinationVC:fullPhotoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showfullPhotoViewController") as fullPhotoViewController
            
            println("Getting blob photo in view photo")
           
            println("Got blob photo in view photo- setting vc tempPhoto variable")
            destinationVC.tempImage = UIImage(data:blob_photo)!
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Edit experience", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Edit logic here")
            
            var destinationVC:ExperienceDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ExperienceDetailViewController") as ExperienceDetailViewController
            
            
            println(" List index selected for edit is \(g_selectedTypeIndex)")
            
            println("Got reference to second view controller")
            
            
            
            destinationVC.s_title = title
            println("Got reference to title")
        //    destinationVC.s_desc = selectedItem.valueForKey("m_desc") as String
          destinationVC.s_desc = text
            println("Got reference to desc")
            
            destinationVC.s_type = type
            println("Got reference to type")
            
            destinationVC.s_favourites = favourite
            println("Got reference to desc")
            
            
    //        destinationVC.s_audio_location = audioExists
          
            
            println("Got reference to audio location ")
            
 /*           if (audioExists.utf16Count > 0) {
                destinationVC.l_recordFlag = true
            } else {
                destinationVC.l_recordFlag = false
            }
   */
            if blobAudio.length > 0 {
                destinationVC.l_recordFlag = true
                destinationVC.audioBlob = blobAudio
                println("Audio blob found in list view, length \(blobAudio.length)")
            } else {
                destinationVC.l_recordFlag = false
                destinationVC.audioBlob = blobAudio
                println("Audio blob NOT found in list view")
            }
            
            destinationVC.s_date = dateExp
            println("Got reference to Date")
            
       //     destinationVC.s_favourites = selectedItem.valueForKey("m_favourites") as Bool
            destinationVC.s_favourites = favourite
            
            destinationVC.s_location = location
            println("Got reference to Photo location \(destinationVC.s_location)")
            
            destinationVC.s_blob_photo = UIImage( data:blob_photo)!
            
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
            
     //       var textTitle = selectedItem.valueForKey("m_title") as String
            var textTitle = title
      //      var textDesc = selectedItem.valueForKey("m_desc") as String
                var textDesc = text
            var textToPost = textTitle + "\r" + textDesc
            
            
            shareToFacebook.setInitialText(textToPost)
            
            //Share photo if photo is available
          
            shareToFacebook.addImage(UIImage(data:blob_photo))
            
            self.presentViewController(shareToFacebook, animated:true,completion:nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Send email", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle email logic here")
            
           // var emailTitle = selectedItem.valueForKey("m_title") as String
            var emailTitle = title
        //    var messageBody = selectedItem.valueForKey("m_desc") as String
            var messageBody = text
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
         //   var imageData = UIImageJPEGRepresentation(blob_photo, 1.0)
           var imageData = blob_photo
            mc.addAttachmentData(imageData, mimeType: "image/jped",fileName : "image")
            mc.addAttachmentData(blobAudio, mimeType: "audio/mp4", fileName:"audio")
       /*
            
           let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
            if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let dirPath = paths[0] as? String {
                        var photoPath = dirPath.stringByAppendingPathComponent(photoLoc)
                        
                        println(" Photo Path is \(photoPath)")
                        
                        var imagePhoto = UIImage (named: photoPath)
                        
                        var imageData = UIImageJPEGRepresentation(imagePhoto, 1.0)
                        
                        mc.addAttachmentData(imageData, mimeType: "image/jpeg", fileName:     "image")
                        
                        //add audio file
                        var docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

                        
                        var url = NSURL(fileURLWithPath: docsDir + "/" + soundURL)
                        
                        let audioData = NSData(contentsOfURL: url)
                        
                        mc.addAttachmentData(audioData, mimeType: "audio/mp4", fileName:     "audio")
                        
                        println("going to present VC")
                        
                        self.presentViewController(mc, animated: true, completion: nil)
                        println("Finished presenting  VC")
                        
                    } } }
            */
            
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        refreshAlert.addAction(cancelAction)
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }

    

}

extension ExperienceListViewController {
    func getExperienceDefaultImage() -> UIImage {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"DefaultImages")
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format: "m_defaultCategory == %@", kExperienceDefaultConstant)
        let l_defaultList = context.executeFetchRequest(fetchRequest, error: nil)! as [NSManagedObject]
        println(" TypeList count is \(l_defaultList.count)")
        if l_defaultList.count > 0 {
            println(" 1 found default experience image")
            
        }
        //    println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
    return l_defaultList[0].valueForKeyPath("m_defaultImage") as UIImage
    }
}
