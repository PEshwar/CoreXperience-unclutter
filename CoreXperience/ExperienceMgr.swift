//
//  ExperienceMgr.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

import Foundation

import CoreData


var expMgr:ExperienceMgr = ExperienceMgr()

var g_typeList:[String] = ["My interactions with Sadguru", "My divine dreams", "My Sadguru's teachings", "Heart-to-Heart messages", "Miscellaneous"]

var g_selectedTypeIndex : Int = 0

var g_pickerSelectedIndex : Int = 0

var g_fileNameAudio : String = ""

var g_cell = customCell ()

var g_selectedListRow : Int = 0

struct Experience {
    var m_user: String = ""
    var m_type: String = ""
    var m_title: String = " "
    var m_desc: String = ""
    var m_location: String = ""
    var m_audio_location : String = ""
   var m_favourites: Bool  = true
   var m_date: NSDate

    
}

var g_experiencesByType =  [Experience]()
var g_experiencesByType1 = [Experience]()
var g_experiencesByType2 = [Experience]()
var g_experiencesByType3 = [Experience]()
var g_experiencesByType4 = [Experience]()
var g_experiencesByType5 = [Experience]()

class ExperienceMgr: NSObject {
   
    var experiences = [Experience]()
    
    var persistenceHelper: ExperiencePersistenceHelper = ExperiencePersistenceHelper()
    
    override init(){
        
        var tempExperiences:NSArray = persistenceHelper.list("CoreExperience")
        super.init()
        for res:AnyObject in tempExperiences{
            
            var tempExperienceArray = experiences
            println("inside init of Exp Mgr before calling types Array Append")
            
         /*  experiences.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String, m_audio_location:res.valueForKey("m_audio_location") as String, m_favourites:res.valueForKey("m_favourites") as Bool, m_date:res.valueForKey("m_date") as NSDate ))*/
           
            experiences.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String, m_audio_location:"", m_favourites:res.valueForKey("m_favourites") as Bool, m_date:res.valueForKey("m_date") as NSDate ))
        }
        
        println(" After init of experiences array, array count is \(experiences.count)")
    }
    
    func loadListArrays() {
        
        //The type selected is determined in Summary VC, and stored in global variable g_selectedType. Based on this, the list controller views are populated i.e, g_experienceByType arrays. Also PickerSelectedIndex variable is used to preset picker view to correct type for ViewEdit functionality. This will be overridden when user decides to change type for new experience entry in 'Add' or 'View/Show' screens.
        
        switch (g_selectedTypeIndex) {
        case 0 :
            
            g_experiencesByType = g_experiencesByType1
            g_pickerSelectedIndex = 0
            
        case 1 :
            
            g_experiencesByType = g_experiencesByType2
            g_pickerSelectedIndex = 1
            
        case 2 :
            
            g_experiencesByType = g_experiencesByType3
            g_pickerSelectedIndex = 2
            
        case 3 :
            
            g_experiencesByType = g_experiencesByType4
            g_pickerSelectedIndex = 3
            
        case 4 :
            
            g_experiencesByType = g_experiencesByType5
            g_pickerSelectedIndex = 4
            
        default:
            break
            
        }
    }
    

    
    func listByType() {
        var tempExperiences:NSArray = persistenceHelper.list("CoreExperience")
        var tempType:String = ""
        g_experiencesByType1.removeAll(keepCapacity: true)
        g_experiencesByType2.removeAll(keepCapacity: true)
        g_experiencesByType3.removeAll(keepCapacity: true)
        g_experiencesByType4.removeAll(keepCapacity: true)
        g_experiencesByType5.removeAll(keepCapacity: true)

        for res:AnyObject in tempExperiences{
        tempType = res.valueForKey("m_type") as String
     //       println("temp type is \(tempType)")
       //     let audio = res.valueForKey("m_audio_location") as String
       //     let favourite = res.valueForKey("m_favourites") as Bool
       //     let selectedDate = res.valueForKey("m_date") as NSDate


      //      println(" audio location is \(audio))")
      //      println(" favourites is \(favourite))")
      //      println(" date selected is \(selectedDate)")

  
            switch (tempType) {
            
            case g_typeList[0]: g_experiencesByType1.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String, m_audio_location:res.valueForKey("m_audio_location") as String, m_favourites:res.valueForKey("m_favourites") as Bool, m_date:res.valueForKey("m_date") as NSDate ))
            
            case g_typeList[1] : g_experiencesByType2.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String, m_audio_location:res.valueForKey("m_audio_location") as String, m_favourites:res.valueForKey("m_favourites") as Bool, m_date:res.valueForKey("m_date") as NSDate ))
            
            case g_typeList[2]: g_experiencesByType3.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String, m_audio_location:res.valueForKey("m_audio_location") as String, m_favourites:res.valueForKey("m_favourites") as Bool, m_date:res.valueForKey("m_date") as NSDate ))
                
            case g_typeList[3]: g_experiencesByType4.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String, m_audio_location:res.valueForKey("m_audio_location") as String, m_favourites:res.valueForKey("m_favourites") as Bool, m_date:res.valueForKey("m_date") as NSDate ))
            
            case g_typeList[4]: g_experiencesByType5.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String, m_audio_location:res.valueForKey("m_audio_location") as String, m_favourites:res.valueForKey("m_favourites") as Bool, m_date:res.valueForKey("m_date") as NSDate ))
            
            default:
                break
                
            }
        
  
    loadListArrays()
 
    }
    }
        
    func addExperience(a_user:String, a_type: String, a_title: String, a_desc:String, a_location:String, a_audio_location: String, a_favourites:Bool, a_date: NSDate){
        
        var dicExperience: Dictionary<String,String> = Dictionary<String,String>()
        
        println("Inside add Experience method")
        println("user is \(a_user)")
        println("type is \(a_type)")
        println("Title is \(a_title)")
        println("Location is \(a_location)")
        println(" audio location is \(a_audio_location)")
            println(" favourites is \(a_favourites)")
            println(" date selected is \(a_date)")
            
        dicExperience["m_user"] = a_user
        dicExperience["m_type"] = a_type
        dicExperience["m_title"] = a_title
        dicExperience["m_desc"] = a_desc
        dicExperience["m_location"] = a_location
        dicExperience["m_audio_location"] = a_audio_location
      //  dicExperience["m_favourites"] = String(a_favourites)
      //  dicExperience["m_location"] = a_date
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        
        
        context = appDel.managedObjectContext!
       
        
      
            
            var newEntity = NSEntityDescription.insertNewObjectForEntityForName("CoreExperience", inManagedObjectContext: context) as NSManagedObject
        
        newEntity.setValue(a_user, forKey: "m_user")
        newEntity.setValue(a_type, forKey: "m_type")
        newEntity.setValue(a_title, forKey: "m_title")
        newEntity.setValue(a_desc, forKey: "m_desc")
        newEntity.setValue(a_location, forKey: "m_location")
        newEntity.setValue(a_audio_location, forKey: "m_audio_location")
        newEntity.setValue(a_favourites, forKey: "m_favourites")
        newEntity.setValue(a_date, forKey: "m_date")

        
            


        
        if(context.save(nil)){
            
            experiences.append(Experience(m_user: a_user, m_type:a_type, m_title:a_title, m_desc:a_desc, m_location:a_location, m_audio_location: a_audio_location, m_favourites: a_favourites, m_date: a_date))
            
            println("Appended new item with title \(a_title) and type \(a_type) and user \(a_user) and location is \(a_location) , and description is \(a_desc), and audio location is \(a_audio_location), and favourites is \(a_favourites), and date is \(a_date)" )
        }
        
        
        }
    
    
  

    func getValueToBeDeleted(index:Int)-> String {
        
        var valueToBeDeleted = ""
        switch (g_selectedTypeIndex) {
            
        case 0 :
            
            valueToBeDeleted = g_experiencesByType1[index].m_title
            
            
        case 1 :
            
            valueToBeDeleted = g_experiencesByType2[index].m_title

            
        case 2 :
            
            valueToBeDeleted = g_experiencesByType3[index].m_title
            
        case 3 :
            
            valueToBeDeleted = g_experiencesByType4[index].m_title
            
        case 4 :
            
            valueToBeDeleted = g_experiencesByType5[index].m_title
            
        default:
            break
            
        }

        return valueToBeDeleted
    }
        
        func removeExperience(index:Int){
            
            var value = getValueToBeDeleted(index)
            //   var value:String = experiences[index].m_title
            
            if(persistenceHelper.remove("CoreExperience", key: "m_title", value: value)){
                experiences.removeAtIndex(index)
                println("Removed item with title \(value)")
            }
        }

  /*  func typesArrayAppend(array: [Experience], res1:AnyObject) -> [Experience] {
        
        var newArray :[Experience] = array
        
        let userStored = res1.valueForKey("m_user") as String
        let typeStored = res1.valueForKey("m_type") as String
        let titleStored = res1.valueForKey("m_title") as String
        let descStored = res1.valueForKey("m_desc") as String
        let locationStored = res1.valueForKey("m_location") as String
        let audioLocationStored = res1.valueForKey("m_audio_location") as String
        let favouritesStored = res1.valueForKey("m_location") as Bool
        let dateStored = res1.valueForKey("m_audio_location") as NSDate

        
        newArray.append(array(m_user:res1.valueForKey("m_user") as String, m_type:res1.valueForKey("m_type") as String,m_title:res1.valueForKey("m_title") as String,m_desc:res1.valueForKey("m_desc") as String,m_location:res1.valueForKey("m_location") as String,m_audio_location:res1.valueForKey("m_audio_location") as String, m_favourites:res1.valueForKey("m_favourites") as Bool, m_date:res1.valueForKey("m_date") as NSDate ))
        
        
        return newArray
        
    }
*/
}
