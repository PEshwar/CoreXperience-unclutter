//
//  ExperienceDetailShowController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 13/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

class ExperienceDetailShowController: UIViewController {
    
    
    
    @IBOutlet var d_title: UITextField!         //Title field on screen
    @IBOutlet weak var d_desc: UITextView!      //Description field on screen
    @IBOutlet var d_location: UITextField!      //Location field on screen
    @IBOutlet weak var d_picker: UIPickerView!  //Picker type field on screen
    //Initialize temp variable (to store user amended picker type value) to the type selected in summary view
    var userAmendedPickerTypeIndex: Int = g_pickerSelectedIndex
    
    
    //Receiving variable assigned to Summary VC's var
    var s_title:String = ""
    var s_desc:String = ""
    var s_location:String = ""
    var s_audio_location = ""
    var s_favourites = false
    var s_date : NSDate = Date.parse("19-09-1993")
    
    //When cancel button is pressed in Detailed VC
    @IBAction func btnCancel(){
        
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    //When Save button is pressed in Detailed VC
    @IBAction func btnSaveTask(sender: UIButton){
        println("Inside save button")
        
  /*      var l_title: String = d_title.text
        var l_desc: String = d_desc.text
        var l_location: String = d_location.text
        var l_user : String = "Family"
        var l_type : String = g_typeList[userAmendedPickerTypeIndex]
        var l_audio_location = ""
        var l_favourites = false
        
        var inputYear : Int = 2014
        var inputMonth:Int = 10
        var inputDay:Int = 16
        
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
        
        
        println("Value of picker selected type before appending is \(g_typeList[userAmendedPickerTypeIndex])")
        
        expMgr.addExperience(l_user,a_type:l_type, a_title:l_title,a_desc:l_desc,a_location:l_location, a_audio_location: l_audio_location, a_favourites: l_favourites, a_date: l_date)
        
        self.view.endEditing(true)
        //Reload list view arrays from database adter adding new item
        expMgr.listByType()
       */
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        println("Inside view did load of show controller")
        //load picker type preselection from row selected in Summary VC
        d_picker.selectRow(g_pickerSelectedIndex, inComponent:0,animated: true)
        //load other details from the temp variables set in List VC before calling Detailed VC
        d_title.text = s_title
        d_desc.text = s_desc
        d_location.text = s_location
         println("Finished view did load of show controller")
        
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
