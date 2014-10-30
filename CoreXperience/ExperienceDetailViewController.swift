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


class ExperienceDetailViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, userDateTimeDelegate, userTextEntryDelegate {


    @IBOutlet var d_title: UITextField!         //Title field on screen

    @IBOutlet weak var d_desc: UITextField!
    
    @IBOutlet var d_location: UITextField!      //Location field on screen
    @IBOutlet weak var d_picker: UIPickerView!  //Picker type field on screen
    
    @IBOutlet weak var d_date_year: UITextField!
    
    @IBOutlet weak var d_date_month: UITextField!
    
    @IBOutlet weak var d_date_day: UITextField!
    
    @IBOutlet weak var d_date_HH: UITextField!
    
    
    @IBOutlet weak var d_date_MM: UITextField!
    
    //Initialize temp variable (to store user amended picker type value) to the type selected in summary view
    var userAmendedPickerTypeIndex: Int = g_pickerSelectedIndex
    
    
    //Receiving variable assigned to Summary VC's var
    var s_title:String = ""
    var s_desc:String = ""
    var s_location:String = ""
   
    //Variable to check if quick Audio or Quick text entry is required
    
    var quickAudio: Bool = false
    var quickEntry: Bool = false
    
    //When cancel button is pressed in Detailed VC
    @IBAction func btnCancel(){
        
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    //When Save button is pressed in Detailed VC
    @IBAction func btnSaveTask(sender: UIButton){
        
    println("Inside save button")
        
        var l_title: String = d_title.text
        var l_desc: String = d_desc.text
        var l_location: String = d_location.text
        var l_user : String = "Family"
        var l_type : String = g_typeList[userAmendedPickerTypeIndex]
        var l_audio_location = g_fileNameAudio
        var l_favourites = true
        
        var inputYear : Int = d_date_year.text.toInt()!
        var inputMonth:Int = d_date_month.text.toInt()!
        var inputDay:Int = d_date_day.text.toInt()!
        
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

        var l_date:NSDate = Date.from(year:inputYear, month: inputMonth, day:inputDay)
        println(" Date is \(l_date)")
        
        println("Value of picker selected type before appending is \(g_typeList[userAmendedPickerTypeIndex])")
        
        expMgr.addExperience(l_user,a_type:l_type, a_title:l_title,a_desc:l_desc,a_location:l_location, a_audio_location: l_audio_location, a_favourites: l_favourites, a_date: l_date)
       println("Back to Detail controller after appending new experience")
        
        self.view.endEditing(true)
        //Reload list view arrays from database adter adding new item
        expMgr.listByType()
        println("After reloading arrays in save button")
        
        //Reset the global variable audio filename
        
        g_fileNameAudio = ""
        
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
   
    
    
    override func viewDidLoad() {
        
       
        
        super.viewDidLoad()
        
        //load picker type preselection from row selected in Summary VC
        d_picker.selectRow(g_pickerSelectedIndex, inComponent:0,animated: true)
        //load other details from the temp variables set in List VC before calling Detailed VC
        d_title.text = s_title
        d_desc.text = s_desc
        d_location.text = s_location
        
       //Setup audio recording file name
        
        var format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        g_fileNameAudio = "recording-\(format.stringFromDate(NSDate.date())).m4a"
        println("Inside view did load of detail vc, value of file name is \(g_fileNameAudio)")
        
        let date = NSDate()
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
        d_title.text = "Experience on " + d_date_day.text + "/" + d_date_month.text + "/" + d_date_year.text + ", " + d_date_HH.text + d_date_MM.text + " Hrs"
        
        //temporarily hard-setting quik audio to yes
//      quickAudio = true
        if quickAudio {
            println("QuickAudio enabled")
            
            performSegueWithIdentifier("audioRecord", sender: self)
            
            //var detail:RecorderViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RecorderViewController") as RecorderViewController
            
                      //Programmatically push to associated VC (ExperienceDetailViewController)
            //self.navigationController?.pushViewController(detail, animated: true)
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) ->Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    //The following are ViewPicker methods for selection of experience type
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int
    {
        return g_typeList.count
    }
    
    func pickerView(pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String! {
   
        userAmendedPickerTypeIndex = row
        println("In picker view, user has changed row selected to \(g_typeList[row])")
        return "\(g_typeList[row])"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
       
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
            destinationVC.tempTextEntry = d_desc.text
            
            destinationVC.delegateText = self
            //etc...
            println("finished setting delegate for text entry")
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
        
        //Set Auto title based on changed time
        d_title.text = "Experience on " + String(day) + "/" + String(month) + "/" + String(year) + ", " + String(hour) + ":" + String(minutes) + " Hrs"
        
    }
    
    func userDidEnterText(enteredText : NSString) {
        println(" Experience description received from text entry vs is \(enteredText)")
        d_desc.text = enteredText
        
    }
}
