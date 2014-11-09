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
    
    @IBOutlet weak var photoExperience: UIImageView!
    
    
    //Recording-related variables
    
    var recorder: AVAudioRecorder!
    
    var player:AVAudioPlayer!
    
    @IBOutlet var recordButton: UIButton!
    
    @IBOutlet var stopButton: UIButton!
    
    @IBOutlet var playButton: UIButton!
    
    @IBOutlet var statusLabel: UILabel!
    
    var meterTimer:NSTimer!
    
    var soundFileURL:NSURL?
    
    //End Recorder related variables

           //Title field on screen

    @IBOutlet weak var d_title: UITextField!
    
    
    @IBOutlet weak var d_category: UILabel! = UILabel()
    
   
    @IBOutlet weak var d_desc: UITextView! = UITextView()
    
   
    
//    @IBOutlet var d_location: UITextField!      //Location field on screen
//    @IBOutlet weak var d_picker: UIPickerView!  //Picker type field on screen
    
    
    @IBOutlet weak var d_date_year: UITextField! = UITextField()
    
    @IBOutlet weak var d_date_day: UILabel! = UILabel()
    
    @IBOutlet weak var d_date_month: UILabel! = UILabel()
    
    
    @IBOutlet weak var d_date_HH: UILabel! = UILabel()
    
    @IBOutlet weak var d_date_MM: UILabel! = UILabel()
    
    
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
   
    //Variable to check if quick Audio or Quick text entry is required
    
 //   var quickAudio: Bool = false
  //  var quickEntry: Bool = false
   
    
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
    
    
    @IBAction func yearChanged(sender: AnyObject) {
        
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
    
    @IBAction func savePressed(sender: UIBarButtonItem) {
  
    
    //When Save button is pressed in Detailed VC

        
    println("Inside save button")
        
        var l_title: String = d_title.text
        println(" Title is \(d_title.text)")
        var l_desc: String = d_desc.text!
        
        
        
        var l_user : String = "Family"
        var l_type : String = d_category.text!
        var l_audio_location = g_fileNameAudio
        var l_favourites = favouriteFlagOn
        
        var inputYear : Int = d_date_year.text.toInt()!
        var inputMonth:Int? = d_date_month?.text?.toInt()
        var inputDay:Int? = d_date_day?.text?.toInt()!
        
        if inputYear != 0 {
            println("Got the number: \(inputYear)")
        } else {
            println("Couldn't convert to a number")
        }
        
        if inputMonth != 0 {
            println("Got the number: \(inputMonth)")
        } else {
            println("Couldn't convert to a number")
        }
        
        if inputDay != 0 {
            println("Got the number: \(inputDay)")
        } else {
            println("Couldn't convert to a number")
        }

        var l_date:NSDate = Date.from(year:inputYear, month: inputMonth!, day:inputDay!)
        println(" Date is \(l_date)")
        
        println("Value of picker selected type before appending is \(g_typeList[userAmendedPickerTypeIndex])")
        
        //Additional code to first check if the experience item exists in the database. If exists then update, or insert new entry
        
        if (photoExperience.image != nil)
        {
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
        
        var l_location: String = l_PhotoLocation
        println(" Photo Location is \(l_PhotoLocation)")
        println(" L Location is \(l_location)")
        
        if (existingItem != nil)
        {
            
            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            var context: NSManagedObjectContext;
            context = appDel.managedObjectContext!
            
            existingItem.setValue(l_title as String, forKey: "m_title")
            existingItem.setValue(l_desc as String, forKey: "m_desc")
            existingItem.setValue(l_type as String, forKey: "m_type")
            existingItem.setValue(l_audio_location as String, forKey: "m_audio_location")
            existingItem.setValue(l_favourites as Bool, forKey: "m_favourites")
            existingItem.setValue(l_date as NSDate, forKey: "m_date")
            existingItem.setValue(l_location as String, forKey: "m_location")
            
            
            
            context.save(nil)
        }
        else {
        expMgr.addExperience(l_user,a_type:l_type, a_title:l_title,a_desc:l_desc,a_location:l_location, a_audio_location: l_audio_location, a_favourites: l_favourites, a_date: l_date)
       println("Back to Detail controller after appending new experience")
        }
        self.view.endEditing(true)
        //Reload list view arrays from database adter adding new item
        expMgr.listByType()
        println("After reloading arrays in save button")
        
        //Reset the global variable audio filename
        
        g_fileNameAudio = ""
        
    //    navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        

    navigationController?.popToRootViewControllerAnimated(true)
        
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
     //   var myColor : UIColor = UIColor( red: 0.5, green: 0.5, blue:0.5, alpha: 1.0 )
        var myColor : UIColor = UIColor (white:0.9, alpha: 1.0)
       
        d_desc.layer.borderColor = myColor.CGColor
        d_desc.scrollsToTop  = true
     
        //Setup photo
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
        
        if (existingItem != nil) {
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
        else {
            g_fileNameAudio = s_audio_location
        }
        
        if (existingItem == nil) {
        d_category.text = g_typeList[g_selectedTypeIndex]
        }
        else {
            d_category.text = s_type
            
        }
        var date = NSDate()
            if (existingItem != nil) {
                date = s_date
            }
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
        let hour = components.hour
   //     d_date_HH.text = String(hour) + ":"
        let minutes = components.minute
   //     d_date_MM.text = String(minutes)
     
        if hour < 10 {
            d_date_HH.text = "0" + String(hour) + ":"
        } else {
            d_date_HH.text = String(hour) + ":"
        }
        if minutes < 10 {
            d_date_MM.text = "0" + String(minutes)
        } else {
            d_date_MM.text = String(minutes)
        }
        
        let month = components.month
        d_date_month.text = String(month)
        let year = components.year
        d_date_year.text = String(year)
        let day = components.day
        d_date_day.text = String(day)
    //    d_title.text = "Experience on " + d_date_day.text + "/" + d_date_month.text + "/" + d_date_year.text + ", " + d_date_HH.text + d_date_MM.text + " Hrs"
     
            if (existingItem == nil) {
            d_title.text = "Experience on " + d_date_day.text! + "/" + d_date_month.text! + "/" + d_date_year.text! + ", " + d_date_HH.text! + d_date_MM.text! + " Hrs"
        
        //set auto description
        
        d_desc.text = "Hi-  "
            }
            
        //temporarily hard-setting quik audio to yes
//      quickAudio = true
 /*       if quickAudio {
            println("QuickAudio enabled")
            
            performSegueWithIdentifier("audioRecord", sender: self)
            
            //var detail:RecorderViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RecorderViewController") as RecorderViewController
            
                      //Programmatically push to associated VC (ExperienceDetailViewController)
            //self.navigationController?.pushViewController(detail, animated: true)
        }
   */
        
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
        
        d_date_month.text = String(month)
        d_date_day.text = String(day)
        
        if hour < 10 {
            d_date_HH.text = "0" + String(hour) + ":"
        } else {
            d_date_HH.text = String(hour) + ":"
        }
        if minutes < 10 {
            d_date_MM.text = "0" + String(minutes)
        } else {
        d_date_MM.text = String(minutes)
        }
        if (existingItem == nil) {
        //Set Auto title based on changed time
        d_title.text = "Experience on " + String(day) + "/" + String(month) + "/" + String(year) + ", " + String(hour) + ":" + String(minutes) + " Hrs"
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
            recordButton.setTitle("Record", forState:.Normal)
            
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
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("\(error.localizedDescription)")
    }
}

extension ExperienceDetailViewController {
    func updateAudioMeter(timer:NSTimer) {
        
        if recorder.recording {
            let dFormat = "%02d"
            let min:Int = Int(recorder.currentTime / 60)
            let sec:Int = Int(recorder.currentTime % 60)
            let s = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            statusLabel.text = s
            recorder.updateMeters()
            var apc0 = recorder.averagePowerForChannel(0)
            var peak0 = recorder.peakPowerForChannel(0)
        }
    }
    
    
   
    
    @IBAction func removeAll(sender: AnyObject) {
        deleteAllRecordings()
    }
    
    @IBAction func record(sender: UIButton) {
        
        if player != nil && player.playing {
            player.stop()
        }
        
        if recorder == nil {
            println("recording. recorder nil")
            recordButton.setTitle("Pause", forState:.Normal)
            playButton.enabled = false
            stopButton.enabled = true
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.recording {
            println("pausing")
            recorder.pause()
            recordButton.setTitle("Continue", forState:.Normal)
            
        } else {
            println("recording")
            recordButton.setTitle("Pause", forState:.Normal)
            playButton.enabled = false
            stopButton.enabled = true
            //            recorder.record()
            recordWithPermission(false)
        }
    }
    
    @IBAction func stop(sender: UIButton) {
        println("stop")
        recorder.stop()
        meterTimer.invalidate()
        
        recordButton.setTitle("Record", forState:.Normal)
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
    }
    
    @IBAction func play(sender: UIButton) {
        play()
    }
    
    func play() {
        
        println("playing")
        var error: NSError?
        // recorder might be nil
        // self.player = AVAudioPlayer(contentsOfURL: recorder.url, error: &error)
        println(" contents of url in Play method is \(soundFileURL)")
        if (soundFileURL == nil) {
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
        self.player = AVAudioPlayer(contentsOfURL: soundFileURL!, error: &error)

        if player == nil {
            if let e = error {
                println(e.localizedDescription)
            }
        }
        player.delegate = self
        player.prepareToPlay()
        player.volume = 1.0
        player.play()
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
        
        var recordSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.Max.toRaw(),
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
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
    
    func deleteAllRecordings() {
        var docsDir =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var fileManager = NSFileManager.defaultManager()
        var error: NSError?
        var files = fileManager.contentsOfDirectoryAtPath(docsDir, error: &error) as [String]
        if let e = error {
            println(e.localizedDescription)
        }
        var recordings = files.filter( { (name: String) -> Bool in
            return name.hasSuffix("m4a")
        })
        for var i = 0; i < recordings.count; i++ {
            var path = docsDir + "/" + recordings[i]
            
            println("removing \(path)")
            if !fileManager.removeItemAtPath(path, error: &error) {
                NSLog("could not remove \(path)")
            }
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
        //      let userInfo:Dictionary<String,String!> = notification.userInfo as Dictionary<String,String!>
        //      let userInfo = notification.userInfo as Dictionary<String,[AnyObject]!>
        //  var reason = userInfo[AVAudioSessionRouteChangeReasonKey]
        
        // var userInfo: [NSObject : AnyObject]? { get }
        //let AVAudioSessionRouteChangeReasonKey: NSString!
        
        /*
        if let reason = notification.userInfo[AVAudioSessionRouteChangeReasonKey] as? NSNumber  {
        }
        
        if let info = notification.userInfo as? Dictionary<String,String> {
        
        
        if let rs = info["AVAudioSessionRouteChangeReasonKey"] {
        var reason =  rs.toInt()!
        
        if rs.integerValue == Int(AVAudioSessionRouteChangeReason.NewDeviceAvailable.toRaw()) {
        }
        
        switch reason  {
        case AVAudioSessionRouteChangeReason
        println("new device")
        }
        
        }
        }
        
        var description = userInfo[AVAudioSessionRouteChangePreviousRouteKey]
        */
        /*
        //        var reason = info.valueForKey(AVAudioSessionRouteChangeReasonKey) as UInt
        //var reason = info.valueForKey(AVAudioSessionRouteChangeReasonKey) as AVAudioSessionRouteChangeReason.Raw
        //var description = info.valueForKey(AVAudioSessionRouteChangePreviousRouteKey) as String
        println(description)
        
        switch reason {
        case AVAudioSessionRouteChangeReason.NewDeviceAvailable.toRaw():
        println("new device")
        case AVAudioSessionRouteChangeReason.OldDeviceUnavailable.toRaw():
        println("old device unavail")
        //case AVAudioSessionRouteChangeReasonCategoryChange
        //case AVAudioSessionRouteChangeReasonOverride
        //case AVAudioSessionRouteChangeReasonWakeFromSleep
        //case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory
        
        default:
        println("something or other")
        }
        */
    }

}

extension ExperienceDetailViewController : userselectedCategoryDelegate {
    
    func userDidSelectCategory(selectedCategory : NSString) {
        
        println(" Category selection received in Add Experience i \(selectedCategory)")
        d_category.text = selectedCategory
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
}