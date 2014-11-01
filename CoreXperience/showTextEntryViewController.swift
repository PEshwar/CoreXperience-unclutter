//
//  showTextEntryViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 01/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

protocol userTextEntryDelegate {
    func userDidEnterText(enteredText : NSString)
}

class showTextEntryViewController: UIViewController {

    @IBOutlet weak var d_textEntry: UITextView!
    var tempTextEntry: String = ""
    
    var delegateText: userTextEntryDelegate? = nil
    
    @IBAction func savePressed(sender: UIButton) {
        println(" Save selected")
            self.delegateText?.userDidEnterText(d_textEntry.text)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        d_textEntry.text = tempTextEntry
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
