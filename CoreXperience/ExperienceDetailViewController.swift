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


class ExperienceDetailViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet var d_title: UITextField!         //Title field on screen
    @IBOutlet weak var d_desc: UITextView!      //Description field on screen
    @IBOutlet var d_location: UITextField!      //Location field on screen
    @IBOutlet weak var d_picker: UIPickerView!  //Picker type field on screen
    
    @IBOutlet weak var d_date_year: UITextField!
    
    @IBOutlet weak var d_date_month: UITextField!
    
    @IBOutlet weak var d_date_day: UITextField!
    
    //Initialize temp variable (to store user amended picker type value) to the type selected in summary view
    var userAmendedPickerTypeIndex: Int = g_pickerSelectedIndex
    
    
    //Receiving variable assigned to Summary VC's var
    var s_title:String = ""
    var s_desc:String = ""
    var s_location:String = ""
   
    
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


}
