//
//  showCategoryViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 01/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import CoreData

protocol userselectedCategoryDelegate {
    func userDidSelectCategory(selectedCategory : NSString)
}

class showCategoryViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    var l_typeList = [NSManagedObject]()
    var categoryArray = [String]()
    var delegateCategory: userselectedCategoryDelegate? = nil
    
    @IBOutlet weak var d_picker: UIPickerView!
    
   
    @IBOutlet weak var selectionLabel: UILabel! = UILabel()
    
    
    //Initialize temp variable (to store user amended picker type value) to the type selected in summary view
    var userAmendedPickerTypeIndex: Int = g_pickerSelectedIndex
    
    @IBAction func donePressed(sender: UIButton) {
       println(" Going to set  value of selected category to \(selectionLabel.text)")
        self.delegateCategory?.userDidSelectCategory(selectionLabel.text!)
         navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        
        //////////////////////////////
        
   
     
        
        
     
        
        
        //load picker type preselection from row selected in Summary VC
        d_picker.selectRow(g_pickerSelectedIndex, inComponent:0,animated: true)
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "CoreCategory")
        
        var totalCategories = context.countForFetchRequest(request, error: nil)
        println("Total categories is \(totalCategories)")
        if totalCategories <= 0 {
            println(" No categories found")
            var categoryAlert = UIAlertController(title: "Action", message: "Add categories first before adding experience", preferredStyle: UIAlertControllerStyle.Alert)
            categoryAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(categoryAlert, animated: true, completion: nil)
        } else {
            var error: NSError?
            let fetchedResults = context.executeFetchRequest(request, error: &error) as [NSManagedObject]?
            var results:NSArray = context.executeFetchRequest(request, error: nil)!
            var i = 0
            println("results coult is \(results.count)")
            for element in results {
                var tempString = element.valueForKey("md_category") as String
                println("value for key is \(tempString)")
                categoryArray.append(tempString)
                i++
            }
            
            
            if let results = fetchedResults {
                l_typeList = results
              
                }
            
            
            else {
                println("Could not fetch \(error), \(error!.userInfo)")
            }
            
            }
    //    selectionLabel.text = l_typeList[g_pickerSelectedIndex]
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
    
    //The following are ViewPicker methods for selection of experience type
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int
    {
        println(" Initializing picker view count to \(g_typeList.count)")
        return categoryArray.count
    }
    
    func pickerView(pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String! {
        
        userAmendedPickerTypeIndex = row
        g_selectedTypeIndex = row
       // println("In picker view, user has changed row selected to \(g_typeList[row])")
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
  //      let task = self.fetchedResultsController.objectAtIndexPath(indexPath) as Task
        
        var catText = l_typeList[indexPath.row].valueForKeyPath("md_category") as? String
        println("Cat text is \(catText)")
        selectionLabel!.text = catText
        return "\(categoryArray[row])"
    }
}
