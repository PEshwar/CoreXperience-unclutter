//
//  ExperienceDetailViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CoreData
import MediaPlayer

class Date {
    
    class func from(#year:Int, month:Int, day:Int) -> NSDate {
        var c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        var gregorian = NSCalendar(identifier:NSGregorianCalendar)
        var date = gregorian.dateFromComponents(c)
        return date!
    }
    //2a. How to construct NSDate from String date
    
    class func parse(dateStr:String, format:String="yyyy-MM-dd") -> NSDate {
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)!
    }
}


class ExperienceDetailViewController: UIViewController, userDateTimeDelegate, userTextEntryDelegate {

    
    //Edit related
    
    var existingItem : NSManagedObject!
    
  //Favourite related
    
    
  
    @IBOutlet weak var favouriteFlag: UIButton!
  
    
    var favouriteFlagOn = false
    
    //Photo-related
    
    var l_PhotoLocation : String = " "
    var blob_photo : UIImage = UIImage()
    
 
    @IBOutlet weak var photoButton: UIBarButtonItem!
    
    @IBOutlet weak var photoExperience: UIImageView!
    
    
    //Recording-related variables
    
    var l_recordFlag = false
    
    var recorder: AVAudioRecorder!
    
    var player:AVAudioPlayer!
    
    var g_fileNameAudio : String = ""
    
    var audioBlob = NSData()
   
    
    @IBOutlet weak var recordButton: UIBarButtonItem!
    
 
    @IBOutlet weak var stopButton: UIBarButtonItem!
    
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    

    @IBOutlet weak var statusLabel: UIBarButtonItem!
    
 
    
    var meterTimer:NSTimer!
    
    var soundFileURL:NSURL?
    
 
    
    //End Recorder related variables

    // File, Docs-dire related variables
    
    var fileMgr = NSFileManager()
    let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
    let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
    
    
           //Title field on screen

    @IBOutlet weak var d_title: UITextField!
    
    
    
  
    @IBOutlet weak var d_category: UIButton!
    
    
  
    @IBAction func categoryButtonPressed(sender: AnyObject) {
    }


    @IBAction func imageTapped(sender: UITapGestureRecognizer) {

        
        var destinationVC:fullPhotoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showfullPhotoViewController") as fullPhotoViewController
        
        println("Getting blob photo in view photo")
        
        println("Got blob photo in view photo- setting vc tempPhoto variable")
        destinationVC.tempImage = photoExperience.image!
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }

   
    @IBOutlet weak var d_desc: UITextView! = UITextView()
    
   
    
//    @IBOutlet var d_location: UITextField!      //Location field on screen
//    @IBOutlet weak var d_picker: UIPickerView!  //Picker type field on screen
    
    //date related
    var l_date = NSDate()
    
    @IBOutlet weak var d_dateLabel: UIButton!
    
    @IBAction func d_date(sender: AnyObject) {
    }
    
  /*  @IBOutlet weak var d_date_year: UITextField! = UITextField()
    
    @IBOutlet weak var d_date_day: UILabel! = UILabel()
    
    @IBOutlet weak var d_date_month: UILabel! = UILabel()
    
    
    @IBOutlet weak var d_date_HH: UILabel! = UILabel()
    
    @IBOutlet weak var d_date_MM: UILabel! = UILabel()
    */
    
    @IBAction func photoPressed(sender: AnyObject) {
        var imageController:UIImagePickerController = UIImagePickerController()
        println("Photo pressed")
        imageController.editing = false
        imageController.delegate = self;
        
        let alert = UIAlertController(title: "Lets get a picture", message: "Simple Message", preferredStyle: UIAlertControllerStyle.ActionSheet)
        println(" Going to add lib button")
      alert.popoverPresentationController?.sourceView = self.view
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default) { (alert) -> Void in
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
          println(" Going to show alert view controller for photo")
            
            self.presentViewController(imageController, animated: true, completion: nil)
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (alert) -> Void in
                println("Take Photo")
                imageController.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imageController, animated: true, completion: nil)
                
            }
            alert.addAction(cameraButton)
        } else {
            println("Camera not available")
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
            println("Cancel Pressed")
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //Initialize temp variable (to store user amended picker type value) to the type selected in summary view
    var userAmendedPickerTypeIndex: Int = g_pickerSelectedIndex
    
    
    //Receiving variable assigned to Summary VC's var
    var s_title:String = ""
    var s_desc:String = ""
    var s_location:String = ""
    var s_type : String = ""
    var s_date : NSDate = NSDate()
    var s_favourites : Bool = false
    var s_audio_location: String = ""
   
   
    
    @IBAction func favouritePressed(sender: AnyObject) {
        println(" Favourite pressed")
        if favouriteFlagOn == false {
            favouriteFlagOn = true
        var image = UIImage (named: "FavSelected.png")
            
        favouriteFlag.setImage(image, forState: .Normal)
            
        } else {
            favouriteFlagOn = false
            var image = UIImage (named: "FavUnselected.jpeg")
            
            favouriteFlag.setImage(image, forState: .Normal)
            
        }
        

    println(" Flag is \(favouriteFlagOn)")
    }
    
    
 /*   @IBAction func yearChanged(sender: AnyObject) {
        
       if (existingItem == nil)
       {
        d_title.text = "Experience on " + d_date_day.text! + "/" + d_date_month.text! + "/" + d_date_year.text! + ", " + d_date_HH.text! + d_date_MM.text! + " Hrs"
        }
    }

    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
    
    
    //When cancel button is pressed in Detailed VC
    
  //      navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    
    navigationController?.popToRootViewControllerAnimated(true)
    }
    */
    

    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        
        if existingItem == nil {
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
        }

    
    @IBAction func savePressed(sender: UIBarButtonItem) {
  
    
    //When Save button is pressed in Detailed VC

        
    println("Inside save button")
        
        var l_title: String = d_title.text
      
        var l_desc: String = d_desc.text!
        
        if (!l_recordFlag && l_desc.utf16Count <= 0) {
            
            var categoryAlert = UIAlertController(title: "Warning", message: " Please either enter text or record audio", preferredStyle: UIAlertControllerStyle.Alert)
            categoryAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Destructive, handler: nil))
            presentViewController(categoryAlert, animated: true, completion: nil)
        } else {

        var l_user : String = "Family"
        var l_type : String = d_category.currentTitle!
            var l_audio_location = ""
            if (existingItem == nil) {
                if (l_recordFlag) {
                        l_audio_location = g_fileNameAudio
                } else {
                    l_audio_location = ""
                }
            } else {
                if (l_recordFlag) {
                    l_audio_location = g_fileNameAudio
                } else {
                    l_audio_location = g_fileNameAudio
                }
            }
            
            
        var l_favourites = favouriteFlagOn
      
            
        
 
        
        //Additional code to first check if the experience item exists in the database. If exists then update, or insert new entry
        
       // image = UIImage(data: imageData) ;
        
  /*      var imageData = UIImageJPEGRepresentation(photoExperience.image, 1.0)
        if imageData != nil {
    
            
            //save image to documents directory
            let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
            if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let dirPath = paths[0] as? String {
                        
                        var format = NSDateFormatter()
                        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
                        l_PhotoLocation = "Photo-\(format.stringFromDate(NSDate.date())).jpeg"
                        
                        //   let writePath = dirPath.stringByAppendingPathComponent("share2.jpeg")
                        let writePath = dirPath.stringByAppendingPathComponent(l_PhotoLocation)
                        println("write path is \(writePath)")
                       
                        UIImageJPEGRepresentation(photoExperience.image, 1.0).writeToFile(writePath, atomically: true)
                    }
                }
            }
        }
    */
        var l_location: String = l_PhotoLocation
        println(" Photo Location is \(l_PhotoLocation)")
        println(" L Location is \(l_location)")
            
            //Get audio file
            var audioPath = NSString()
            var fileMgr = NSFileManager()
            let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
            if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let dirPath = paths[0] as? String {
                        
                        
                        audioPath = dirPath.stringByAppendingPathComponent(l_audio_location)
                        println("write path is \(audioPath)")
                        
                        
                    }
                }
            }

            var l_audio_blob = fileMgr.contentsAtPath(audioPath)
            if l_audio_blob == nil {
                println(" No audio object found by file manager")
            } else {
                println(" audio object blob found by file mgr, writing to sqlite. file size is \(l_audio_blob?.length)")
            }
        
            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            var context: NSManagedObjectContext;
            context = appDel.managedObjectContext!
        if (existingItem != nil)
        {
            
 
            
            existingItem.setValue(l_title as String, forKey: "m_title")
            existingItem.setValue(l_desc as String, forKey: "m_desc")
            existingItem.setValue(l_type as String, forKey: "m_type")
            existingItem.setValue(l_audio_location as String, forKey: "m_audio_location")
            existingItem.setValue(l_favourites as Bool, forKey: "m_favourites")
            existingItem.setValue(l_date as NSDate, forKey: "m_date")
            existingItem.setValue(l_location as String, forKey: "m_location")
            existingItem.setValue(photoExperience.image, forKey: "m_photo_blob")
            existingItem.setValue(l_audio_blob, forKey: "m_audio_blob")
            
            
            context.save(nil)
        }
        else {
            var newEntity = NSEntityDescription.insertNewObjectForEntityForName("CoreExperience", inManagedObjectContext: context) as NSManagedObject
            
            newEntity.setValue(l_title as String, forKey: "m_title")
            newEntity.setValue(l_desc as String, forKey: "m_desc")
            newEntity.setValue(l_type as String, forKey: "m_type")
            newEntity.setValue(l_audio_location as String, forKey: "m_audio_location")
            newEntity.setValue(l_favourites as Bool, forKey: "m_favourites")
            newEntity.setValue(l_date as NSDate, forKey: "m_date")
            newEntity.setValue(l_location as String, forKey: "m_location")
            newEntity.setValue(photoExperience.image, forKey: "m_photo_blob")
            newEntity.setValue(l_audio_blob, forKey: "m_audio_blob")
            
   
            context.save(nil)
            
  
       println("Back to Detail controller after appending new experience")
        }
        self.view.endEditing(true)

        
         // Delete the audio recording file in docs directory
            
            if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let docsDir = paths[0] as? String {
                        var filePath = docsDir.stringByAppendingPathComponent(g_fileNameAudio)
                        var fileExists = fileMgr.fileExistsAtPath(filePath)
                        if fileExists {
                            fileMgr.removeItemAtPath(filePath, error: nil)
                            println("removed file at path \(g_fileNameAudio)")
                        }
                    }} }
                    
            
        //Reset the global variable audio filename
            
            
        g_fileNameAudio = ""
        
            
            
            
            
        if existingItem == nil {
            navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
        
        
  //  navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
   
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        //To set keyboard parameters
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        println("Inside view did load of detail VC")
       
        //Set Description text view parameters
        
        d_desc.layer.borderWidth = 0.8
        d_desc.scrollEnabled = true
        d_desc.layer.cornerRadius = 0.8
   
        var myColor : UIColor = UIColor (white:0.9, alpha: 1.0)
       
        d_desc.layer.borderColor = myColor.CGColor
        d_desc.scrollsToTop  = true
     
  /*      //Setup photo
        if (existingItem != nil) {
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                var photoPath = dirPath.stringByAppendingPathComponent(s_location)
                 println(" Photo Path is \(photoPath)")
                    var imagePhoto = UIImage (named: photoPath)
                    photoExperience.image = imagePhoto
                }
            }
            }
        }
        */
        
        if existingItem == nil {
            photoExperience.image = UIImage(named:"Bonsai.jpeg")
            d_category.setTitle(g_typeList[g_selectedTypeIndex], forState: .Normal)

        } else {
        photoExperience.image = blob_photo
        //load other details from the temp variables set in List VC before calling Detailed VC
            println(" Inside view did load- existing item is not nil")
        d_title.text = s_title
        d_desc.text = s_desc
        
           
            
            println(" Setting title & desc to \(s_title) and \(s_desc)")
          
        }
        
        if s_favourites == true {
            var image = UIImage (named: "FavSelected.png")
            
            favouriteFlag.setImage(image, forState: .Normal)
            favouriteFlagOn = true

        } else {
            var image = UIImage (named: "FavUnselected.jpeg")
            
            favouriteFlag.setImage(image, forState: .Normal)
            favouriteFlagOn = false
        }
       //Setup audio recording file name
   
        if (existingItem == nil) {
        var format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        g_fileNameAudio = "recording-\(format.stringFromDate(NSDate.date())).m4a"
        println("Inside view did load of detail vc, value of file name is \(g_fileNameAudio)")
        }
   /*     else {
            if (s_audio_location.utf16Count > 0) {
            g_fileNameAudio = s_audio_location
            } else {
                var format = NSDateFormatter()
                format.dateFormat="yyyy-MM-dd-HH-mm-ss"
                g_fileNameAudio = "recording-\(format.stringFromDate(NSDate.date())).m4a"
                playButton.enabled = false
            }
            
            println(" s_audio_location in edit mode is \(g_fileNameAudio)")
            var dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            var docsDir: AnyObject = dirPaths[0]
            //       var soundFilePath = docsDir.stringByAppendingPathComponent(currentFileName)
            var soundFilePath = docsDir.stringByAppendingPathComponent(g_fileNameAudio)
            
            soundFileURL = NSURL(fileURLWithPath: soundFilePath)
            println("Sound file URL in edit mode is \(soundFileURL)")
            
        }
        */
        else {
            if audioBlob.length > 0 {
                println("inside detail vc, got the audio file from the list VC, length is \(audioBlob.length)")
                g_fileNameAudio = "audio.m4a"
 
                if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                    if paths.count > 0 {
                        if let docsDir = paths[0] as? String {
                            var filePath = docsDir.stringByAppendingPathComponent("audio.m4a")
                            var fileExists = fileMgr.fileExistsAtPath(filePath)
                            if fileExists {
                                fileMgr.removeItemAtPath(filePath, error: nil)
                            }
                            var successAudio = fileMgr.createFileAtPath(filePath, contents: audioBlob, attributes: nil)
                            println("Sucess in creating audio.mp4 file \(successAudio)")
                            println(" Filepath behind success(or lack thereof \(filePath)")
                            // Setup SoundfileURL for Audio player to use
                            
                            soundFileURL = NSURL(fileURLWithPath: filePath)
                            
                            println("soundFileURL 1 is \(soundFileURL)")
                        }}}
            } else {
                var format = NSDateFormatter()
                format.dateFormat="yyyy-MM-dd-HH-mm-ss"
                g_fileNameAudio = "recording-\(format.stringFromDate(NSDate.date())).m4a"
                playButton.enabled = false
                
            }
        }
        
        if (existingItem == nil) {
        d_category.setTitle(g_typeList[g_selectedTypeIndex], forState: .Normal)
        }
        else {
            d_category.setTitle(s_type, forState: .Normal)
        
            
        }
        
            //Set date
        
        var dateFormatter = NSDateFormatter()
        println("Inside date picker changed")
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
       
        if (existingItem != nil) {
            l_date = s_date
           
            
        } else {
            
            l_date = NSDate()
        }
         var tempDate = dateFormatter.stringFromDate(l_date)
        d_dateLabel.setTitle(tempDate, forState: .Normal)
        d_title.text = "Experience on " + tempDate
        
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        recorder = nil
        player = nil
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) ->Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
   

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
       
        println(" Segue identifier is \(segue.identifier)")
        
        if (segue.identifier == "showDateTime") {
            //get a reference to the destination view controller
            println("Getting reference to second view controller")
            
            let destinationVC:showDateTimeViewController = segue.destinationViewController as showDateTimeViewController
            
            
            
            println("Going to set delegate")
            
            //set properties on the destination view controller
            destinationVC.tempDateTime = " Hello"
            
            destinationVC.delegateDate = self
            //etc...
            println("finished setting delegate")
            
            
        } else if (segue.identifier == "showTextEntry"){
            println("Getting reference to text entry controller")
            
            let destinationVC:showTextEntryViewController = segue.destinationViewController as showTextEntryViewController
            
            
            
            println("Going to set delegate for text entry")
            
            //set properties on the destination view controller
          destinationVC.tempTextEntry = d_desc.text!
         
           destinationVC.delegateText = self
            //etc...
            println("finished setting delegate for text entry")
        } 
        else if (segue.identifier == "showCategory") {
            
            let destinationVC:showCategoryViewController = segue.destinationViewController as showCategoryViewController
            
            
            
            println("Going to set delegate for category")
            
            //set properties on the destination view controller
            
            destinationVC.delegateCategory = self
            //etc...
            println("finished setting delegate for Category")
            
        } else if (segue.identifier == "showImagePicker") {
            
            let destinationVC:showImagePickerViewController = segue.destinationViewController as showImagePickerViewController
            
            
            
            println("Going to set delegate for category")
            
            //set properties on the destination view controller
            
            destinationVC.delegatePhoto = self
            if ((existingItem != nil) && (photoExperience.image != nil)){
            destinationVC.tempPhoto = photoExperience.image!
            }
            //etc...
            println("finished setting delegate for Category")
            
        }

    }

    func userDidSelectDateTime(selectedDateTime : NSDate) {
        println("Back to add experience: Date selected is \(selectedDateTime)")
        l_date = selectedDateTime
        let myCalendar = NSCalendar.currentCalendar()
        let myComponents = myCalendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: selectedDateTime)
        let hour = myComponents.hour
        println(" hour is \(hour)")
        let minutes = myComponents.minute
        println(" minutes is \(minutes)")
        let month = myComponents.month
        println(" Month is \(month)")
        let year = myComponents.year
        println(" year is \(year)")
        let day = myComponents.day
        println(" day is \(day)")
        
        var dateFormatter = NSDateFormatter()
        println("Inside date picker changed")
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        var strDate = dateFormatter.stringFromDate(selectedDateTime)
        
        d_dateLabel.setTitle(strDate, forState: .Normal)
        
        d_title.text = "Experience on " + strDate
        
      if (existingItem == nil) {
        //Set Auto title based on changed time
       // d_title.text = "Experience on " + String(day) + "/" + String(month) + "/" + String(year) + ", " + String(hour) + ":" + String(minutes) + " Hrs"
    
        }

        
    }
    
    func userDidEnterText(enteredText : NSString) {
        println(" Experience description received from text entry vs is \(enteredText)")
        d_desc.text = enteredText
        
    }
}


// MARK: AVAudioRecorderDelegate
extension ExperienceDetailViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!,
        successfully flag: Bool) {
            println("finished recording \(flag)")
            println("After recording, you can find it at \(soundFileURL)")
            
            stopButton.enabled = false
            playButton.enabled = true
      //      recordButton.setTitle("Record", forState:.Normal)
            recordButton.enabled = true
            // iOS8 and later
            var alert = UIAlertController(title: "Recorder",
                message: "Finished Recording",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Keep", style: .Default, handler: {action in
                println("keep was tapped")
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {action in
                println("delete was tapped")
                self.recorder.deleteRecording()
            }))
            self.presentViewController(alert, animated:true, completion:nil)
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!,
        error: NSError!) {
            println("\(error.localizedDescription)")
    }
}

// MARK: AVAudioPlayerDelegate
extension ExperienceDetailViewController : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        println("finished playing \(flag)")
        recordButton.enabled = true
        stopButton.enabled = false
        playButton.enabled = true
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("\(error.localizedDescription)")
    }
}

extension ExperienceDetailViewController {
    func updateAudioMeter(timer:NSTimer) {
      
        if (recorder != nil && recorder.recording) {
            let dFormat = "%02d"
            let min:Int = Int(recorder.currentTime / 60)
            let sec:Int = Int(recorder.currentTime % 60)
            let s = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            statusLabel.title = s
            recorder.updateMeters()
            var apc0 = recorder.averagePowerForChannel(0)
            var peak0 = recorder.peakPowerForChannel(0)
        } else if (player != nil && player.playing) {
            let dFormat = "%02d"
            let min:Int = Int(player.currentTime / 60)
            let sec:Int = Int(player.currentTime % 60)
            let s = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            statusLabel.title = s
            player.updateMeters()
            var apc0 = player.averagePowerForChannel(0)
            var peak0 = player.peakPowerForChannel(0)
        }
    }
    
    
   
    
    
    @IBAction func record(sender: UIBarButtonItem) {
    
        if (!l_recordFlag)
        {
            l_recordFlag = true
            self.goRecord()
        }
        else {
            var categoryAlert = UIAlertController(title: "Warning", message: " There is already a recording. Do you want to overwrite?", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            categoryAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (action: UIAlertAction!) in
                println("Handle record logic here")
                
                self.goRecord()
                
            }))
            
            
            categoryAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Destructive, handler: nil))

            presentViewController(categoryAlert, animated: true, completion: nil)
        }
        
        
           }
    
    func goRecord() {
        
        if player != nil && player.playing {
            player.stop()
        }
        
        if recorder == nil {
            println("recording. recorder nil")
            //  recordButton.setTitle("Pause", forState:.Normal)
            recordButton.enabled = false
            pauseButton.enabled = true
            playButton.enabled = false
            stopButton.enabled = true
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.recording {
            println("pausing")
            recorder.pause()
            // recordButton.setTitle("Continue", forState:.Normal)
            
        } else {
            println("recording")
            recordButton.enabled = false
            pauseButton.enabled = true
            playButton.enabled = false
            stopButton.enabled = true
            //            recorder.record()
            recordWithPermission(false)
        }

    }
    
    @IBAction func pausePressed(sender: UIBarButtonItem) {
        if recorder != nil && recorder.recording {
            println("pausing")
            recorder.pause()
            
            // recordButton.setTitle("Continue", forState:.Normal)
            
        } else if (recorder != nil && !recorder.recording) {
            recorder.record()
        } else if (player != nil && player.playing) {
            player.pause()
            stopButton.enabled = false
            playButton.enabled = true
            recordButton.enabled = true
            
        } else if (player != nil && !player.playing) {
            recordButton.enabled = true
            pauseButton.enabled = true
            playButton.enabled = true
            stopButton.enabled = false
            player.play()
            
            
        }
        
        
    }
    
    @IBAction func stop(sender: UIBarButtonItem) {
    
        if (recorder != nil) {
        println("stop")
        recorder.stop()
        meterTimer.invalidate()
        
       // recordButton.setTitle("Record", forState:.Normal)
        recordButton.enabled = true
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setActive(false, error: &error) {
            println("could not make session inactive")
            if let e = error {
                println(e.localizedDescription)
                return
            }
        }
        playButton.enabled = true
        stopButton.enabled = false
        recordButton.enabled = true
        recorder = nil
        }}
    
  
    @IBAction func play(sender: UIBarButtonItem) {
    
        play()
    }
    
    func play() {
        
        println("playing")
        var error: NSError?
        // recorder might be nil
        // self.player = AVAudioPlayer(contentsOfURL: recorder.url, error: &error)
        println(" contents of url in Play method is \(soundFileURL)")
  /*      if (soundFileURL == nil) {
            var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
            mediaPlayer.stop()
            var docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
          var soundURL = g_fileNameAudio
  
            
            println("Printing current selected index : \(g_selectedListRow)")
            
            println("Sound URL is \(soundURL)")
            
            var url = NSURL(fileURLWithPath: docsDir + "/" + soundURL)
            
            println("URL is \(url)")
            
            
            mediaPlayer.contentURL = url
            
            
            mediaPlayer.play()
            println(" contents of url after setting up recorder in Play method is \(url)")
        } else {
*/
        
        var fileLength = soundFileURL?.absoluteString!
        if (fileLength?.utf16Count > 0)
         {
        println("There is something to play")
        self.player = AVAudioPlayer(contentsOfURL: soundFileURL!, error: &error)

        if player == nil {
            println(" Player is nil - after finding there is something to play")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        player.delegate = self
        player.prepareToPlay()
        player.volume = 1.0
        self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
            target:self,
            selector:"updateAudioMeter:",
            userInfo:nil,
            repeats:true)
        recordButton.enabled = false
        pauseButton.enabled = true
        playButton.enabled = false
        stopButton.enabled = false
        player.play()
        } else {
            println("There is nothing to play")
        }
    }
    
    
    
    func setupRecorder() {
        //       var format = NSDateFormatter()
        //       format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        //       var currentFileName = "recording-\(format.stringFromDate(NSDate.date())).m4a"
        //       println(currentFileName)
        println("Inside setup recorder- global file name is \(g_fileNameAudio)")
        var dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var docsDir: AnyObject = dirPaths[0]
        //       var soundFilePath = docsDir.stringByAppendingPathComponent(currentFileName)
        var soundFilePath = docsDir.stringByAppendingPathComponent(g_fileNameAudio)
        
        soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        
        println("soundFileURL is \(soundFileURL)")
        let filemanager = NSFileManager.defaultManager()
        if filemanager.fileExistsAtPath(soundFilePath) {
            // probably won't happen. want to do something about it?
            println("sound exists")
            println("Sound file path")
        }
        /*
        var recordSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.Max.toRaw(),
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]*/
        
        var recordSettings = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVEncoderAudioQualityKey : AVAudioQuality.Min.toRaw(),
            AVEncoderBitRateKey : 32000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 8000.0
            
    ]
        var error: NSError?
        recorder = AVAudioRecorder(URL: soundFileURL!, settings: recordSettings, error: &error)
        if let e = error {
            println(e.localizedDescription)
        } else {
            recorder.delegate = self
            recorder.meteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        }
    }
    
    func recordWithPermission(setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    println("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                        target:self,
                        selector:"updateAudioMeter:",
                        userInfo:nil,
                        repeats:true)
                } else {
                    println("Permission to record not granted")
                }
            })
        } else {
            println("requestRecordPermission unrecognized")
        }
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayback, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }
    
    func setSessionPlayAndRecord() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }
    

    
    func askForNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"background:",
            name:UIApplicationWillResignActiveNotification,
            object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"foreground:",
            name:UIApplicationWillEnterForegroundNotification,
            object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"routeChange:",
            name:AVAudioSessionRouteChangeNotification,
            object:nil)
    }
    
    func background(notification:NSNotification) {
        println("background")
    }
    
    func foreground(notification:NSNotification) {
        println("foreground")
    }
    
    
    func routeChange(notification:NSNotification) {

    }

}

extension ExperienceDetailViewController : userselectedCategoryDelegate {
    
    func userDidSelectCategory(selectedCategory : NSString) {
        
        println(" Category selection received in Add Experience i \(selectedCategory)")
        d_category.setTitle(selectedCategory, forState: .Normal)
    }
}

extension ExperienceDetailViewController {
    func updateTextViewSizeForKeyboardHeight(keyboardHeight: CGFloat) {
        d_desc.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardHeight)
    }

    func keyboardDidShow(notification: NSNotification) {
        if let rectValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardSize = rectValue.CGRectValue().size
            updateTextViewSizeForKeyboardHeight(keyboardSize.height)
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        updateTextViewSizeForKeyboardHeight(0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
       navigationController?.hidesBarsWhenKeyboardAppears = true
    }

}

extension ExperienceDetailViewController : userPickedPhotoDelegate {
    
    func userDidPickPhoto(selectedPhoto : UIImage) {
        
     //   photoExperience.image = UIImage (named: "FavSelected.png")
        photoExperience.image = selectedPhoto
    }
    
}

//Hide keyboard

extension ExperienceDetailViewController :UITextFieldDelegate {

    func textFieldShouldReturn(textField:UITextField)->Bool {
        
        self.d_title.delegate = self
    //    d_title.resignFirstResponder()
        
   //     self.d_desc.delegate = self
        self.view.endEditing(true)
        return false
    }

    
    }
extension ExperienceDetailViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
//func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//    photoButton.image = info[UIImagePickerControllerOriginalImage] as? UIImage

func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    
    println(" In image delegate function, going to set image of photo button")
        photoExperience.image = image;
     self.dismissViewControllerAnimated(true, nil)
    
    }
    
    }
