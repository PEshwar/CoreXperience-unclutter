//
//  ViewController.swift
//  Menu
//
//  Created by Mathew Sanders on 9/7/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import UIKit
import CoreData

class MenuViewController: UIViewController {
    
    var desc : String = ""
    // create references to the items on the storyboard 
    // so that we can animate their properties
    
    @IBAction func textPressed(sender: UIButton) {
        
        var destinationVC:showTextEntryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showTextEntryViewController") as showTextEntryViewController
        //         var selectedRow = self.tableView.indexPathForSelectedRow()?.row
        //         println("selected row is \(selectedRow)")
        //         var selectedItem : NSManagedObject = self.typeList[selectedRow!] as NSManagedObject
        //         println("Got reference to selected item")
        
        destinationVC.tempTextEntry = desc
        println("Got reference to desc")
        
        //  self.presentViewController(refreshAlert, animated: true, completion: nil)
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    @IBOutlet weak var textPostIcon: UIImageView!
    @IBOutlet weak var textPostLabel: UILabel!
    
    @IBOutlet weak var photoPostIcon: UIImageView!
    @IBOutlet weak var photoPostLabel: UILabel!
    
    @IBOutlet weak var quotePostIcon: UIImageView!
    @IBOutlet weak var quotePostLabel: UILabel!
    
    @IBOutlet weak var linkPostIcon: UIImageView!
    @IBOutlet weak var linkPostLabel: UILabel!
    
    @IBOutlet weak var chatPostIcon: UIImageView!
    @IBOutlet weak var chatPostLabel: UILabel!
    
    @IBOutlet weak var audioPostIcon: UIImageView!
    @IBOutlet weak var audioPostLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.barTintColor = UIColor.greenColor()


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelPressed(sender: UIButton) {
    //    navigationController?.presentingViewController?.dismissViewControllerAnimated(true, nil)
    navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
}

