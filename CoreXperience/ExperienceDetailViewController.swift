//
//  ExperienceDetailViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import Foundation


class ExperienceDetailViewController: UIViewController {

//    @IBOutlet var d_user: UITextField!
//    @IBOutlet var d_type: UITextField!
    @IBOutlet var d_title: UITextField!
    
    @IBOutlet weak var d_desc: UITextView!
    @IBOutlet var d_location: UITextField!

    
   
    @IBAction func btnSaveTask(sender: UIButton){
        
    
        
        var l_title: String = d_title.text
        var l_desc: String = d_desc.text
        var l_location: String = d_location.text
        var l_user : String = "Family"
        var l_type : String = "Spiritual Experience"
        
        expMgr.addExperience(l_user,a_type:l_type, a_title:l_title,a_desc:l_desc,a_location:l_location)
        d_title.text = ""
        d_desc.text = ""
        d_location.text = ""
        self.view.endEditing(true)
        
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    @IBAction func btnCancel(){
        
        println("Cancel button pressed")
        
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

}
