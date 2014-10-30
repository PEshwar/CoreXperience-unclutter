//
//  showDateTimeViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 26/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

protocol userDateTimeDelegate {
    func userDidSelectDateTime(selectedDateTime : NSDate)
}

class showDateTimeViewController: UIViewController {
    
    var delegateDate: userDateTimeDelegate? = nil
    var selectedDateFromPicker = NSDate()

    @IBAction func doneDateSelected(sender: AnyObject) {
        println("Done selected")
        var tempSelectedDate : String = d_dateTime.text!
        self.delegateDate?.userDidSelectDateTime(selectedDateFromPicker)
    
        navigationController?.popViewControllerAnimated(true)

    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var d_dateTime: UILabel! = UILabel()
    var tempDateTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        d_dateTime.text = tempDateTime
        
        datePicker.addTarget(self, action: Selector("datePickerChanged:"),
            forControlEvents: UIControlEvents.ValueChanged)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func datePickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        println("Inside date picker changed")
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let datePicked  = datePicker.date
        //Set variable to pass selected date back to Detail view controller
        selectedDateFromPicker = datePicker.date
        let myCalendar = NSCalendar.currentCalendar()
        let myComponents = myCalendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: datePicked)
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
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        
        println(" Date selected is \(strDate)")
        d_dateTime.text = strDate
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
