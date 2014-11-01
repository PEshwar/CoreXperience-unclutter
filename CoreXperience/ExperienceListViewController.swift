//
//  ExperienceListViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import MediaPlayer
import Social


class ExperienceListViewController: UITableViewController {

    
var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    
    @IBAction func favButtonPressed(sender: AnyObject) {
        println("Favourite button pressed")
  
        
        
    }
   
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        println("Share button pressed")
        var shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        var textToPost = g_experiencesByType[g_selectedListRow].m_title + "\r " + g_experiencesByType[g_selectedListRow].m_desc
        shareToFacebook.setInitialText(textToPost)
        self.presentViewController(shareToFacebook, animated:true,completion:nil)
        
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        println("Unwinding")
    }

    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    //Show the title of ListController as the type selected in Summary VC
    navigationItem.title = g_typeList[g_selectedTypeIndex]
    //Load the various global list arrays per type from database
    expMgr.listByType()
    
    }

    
    
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    
    //Load the various global list arrays per type from database everytime view is refreshed
    expMgr.listByType()
    tableView.reloadData()
    
    
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
    // Return the number of sections.
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    // Return the number of rows in the section.
    return g_experiencesByType.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        g_cell = tableView.dequeueReusableCellWithIdentifier("customCell") as customCell
 //   cell = customCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier:"customCell")
    
    //Assign the title of each experience to the textLabel of each cell
//    cell.textLabel!.text = g_experiencesByType[indexPath.row].m_title
//    cell.textLabel!.textColor = UIColor.orangeColor()
  
        g_cell.d_expTitle.text = g_experiencesByType[indexPath.row].m_title
        g_cell.d_expDesc.text = g_experiencesByType[indexPath.row].m_desc
       
        //Obtain and convert date to string
        
        let obtainedDate = g_experiencesByType[indexPath.row].m_date
        
        
        let dateStringFormatter = NSDateFormatter()
        
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        var obtainedDateString : String = dateStringFormatter.stringFromDate(obtainedDate)
        println(" Obtained date is \(obtainedDateString)")
         g_cell.d_date.text = obtainedDateString
        g_cell.playIcon.text = "▶️"
        
    // Set the subtitles in list view
//    cell.detailTextLabel!.text = obtainedDateString + "  " + g_experiencesByType[indexPath.row].m_desc
//    cell.detailTextLabel!.textColor = UIColor.purpleColor()
  //      println("after displaying text and subtitle")
        
   //     cell.setCell()
        
        //Set Favourite Flag
        
        var favouriteSelected = g_experiencesByType[indexPath.row].m_favourites
        
        if favouriteSelected == true {
            var image = UIImage (named: "Favourite-selected")
            
            g_cell.d_favouriteFlag.setImage(image, forState: .Normal)
        }
        
        
    return g_cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        println("Inside tableList view : did select row. index path is \(indexPath.row)")
        mediaPlayer.stop()
    //           var previewUrl : String = "file:///Users/prabhueshwarla/Library/Developer/CoreSimulator/Devices/AABE6DBD-56DD-426B-A598-323BBA07484A/data/Containers/Data/Application/994EB8A2-5743-4C6C-9752-1ECB4F0D71F2/Documents/recording-2014-10-19-10-33-00.m4a"
       
        var docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
  //      println(" recording file name is \(recordings[indexPath.row])")
        var soundURL = g_experiencesByType[indexPath.row].m_audio_location
        g_selectedListRow = indexPath.row
        println("Printing current selected index : \(indexPath.row)")
        
        println("Sound URL is \(soundURL)")
        
        var url = NSURL(fileURLWithPath: docsDir + "/" + soundURL)
        
        println("URL is \(url)")
        
      //  var previewUrl : String = "file:///Users/prabhueshwarla/Library/Developer/CoreSimulator/Devices/AABE6DBD-56DD-426B-A598-323BBA07484A/data/Containers/Data/Application/994EB8A2-5743-4C6C-9752-1ECB4F0D71F2/Documents/recording-2014-10-19-10-33-00.m4a"
        
    //   println(" Inside select row-> BEFORE: content URL is \(previewUrl)")
        println(" Inside select row-> BEFORE: content URL is \(url)")
        
    //   mediaPlayer.contentURL = NSURL(string: previewUrl)
        mediaPlayer.contentURL = url
   //     println(" Inside select row-> AFTER: content URL is \(soundURL)")
        mediaPlayer.play()

        }

    
        
    
    //This code adds animation while displaying table rows
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
    cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
    UIView.animateWithDuration(1, animations: {
    cell.layer.transform = CATransform3DMakeScale(1,1,1)
    })
    }
    
    override func tableView(tableView:UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath:NSIndexPath){
    
    if(editingStyle == UITableViewCellEditingStyle.Delete){
    expMgr.removeExperience(indexPath.row)
    expMgr.listByType()
    tableView.reloadData()
        }
    
    }
}


