//
//  ExperienceDetailShowController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 13/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

class ExperienceDetailShowController: UIViewController {

    
    //    @IBOutlet var d_user: UITextField!
    //    @IBOutlet var d_type: UITextField!
    
    @IBOutlet var d_title: UITextField!
    
    @IBOutlet weak var d_pickerShow: UIPickerView!
    
    @IBOutlet weak var d_desc: UITextView!
    @IBOutlet var d_location: UITextField!
    var arrType: NSArray = [] //Array to store experience type list
    var pickerSelectedType: String = "My Spiritual experiences"
    
    //Receiving variable assigned to Summary VC's var
    var s_title:String = ""
    var s_desc:String = ""
    var s_location:String = ""
    
    
    
    @IBOutlet weak var d_type: UIPickerView!
    
    @IBAction func btnSaveTask(sender: UIButton){
        
        println("Inside save button")
        
        var l_title: String = d_title.text
        var l_desc: String = d_desc.text
        var l_location: String = d_location.text
        var l_user : String = "Family"
        var l_type : String = pickerSelectedType
        
        expMgr.addExperience(l_user,a_type:l_type, a_title:l_title,a_desc:l_desc,a_location:l_location)
        d_title.text = ""
        d_desc.text = ""
        d_location.text = ""
        self.view.endEditing(true)
        
        //     println("Inside save button- added new experience to array & database")
        
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        //   println("Inside save button- dismussing curent view controller")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load list of types in UI Picker
        
        arrType = ["My Spiritual experiences", "My Dreams", "My Notes","My Intuition", "Miscellaneous"]
        
        d_pickerShow.selectRow(g_pickerSelectedIndex, inComponent:0,animated: true)
        
        //load Detail VC from row selected in Summary VC
        
        d_title.text = s_title
        d_desc.text = s_desc
        d_location.text = s_location
        
        //        txtName.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
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
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int
    {
        return arrType.count
    }
    
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String! {
   //     println( " Item selected is \(arrType[row])")
        pickerSelectedType = arrType[row] as String
        return "\(arrType[row])"
    }
    

}
