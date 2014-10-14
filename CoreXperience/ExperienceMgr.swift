//
//  ExperienceMgr.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

var expMgr:ExperienceMgr = ExperienceMgr()

var g_typeList:[String] = ["My interactions with Sadguru", "My divine dreams", "My Sadguru's teachings", "Heart-to-Heart messages", "Miscellaneous"]

var g_selectedType : String = ""

var g_pickerSelectedIndex : Int = 0

struct Experience {
    var m_user: String = ""
    var m_type: String = ""
    var m_title: String = " "
    var m_desc: String = ""
    var m_location: String = ""
}
var g_experiencesByType = [Experience]()
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
        for res:AnyObject in tempExperiences{
            experiences.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String ))
        }
        
        println(" After init of experiences array, array count is \(experiences.count)")
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
            
            switch (tempType) {
            
                case g_typeList[0]: g_experiencesByType1.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String ))
            
            case g_typeList[1] : g_experiencesByType2.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String ))
            
            case g_typeList[2]: g_experiencesByType3.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String ))
                
            case g_typeList[3]: g_experiencesByType4.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String ))
            
            case g_typeList[4]: g_experiencesByType5.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String ))
            
            default:
                break
                
            }
        
            
        }
 
    loadListArrays()
 
    }
    
    func loadListArrays() {
        
        switch (g_selectedType) {
        case g_typeList[0] :
            
            g_experiencesByType = g_experiencesByType1
            g_pickerSelectedIndex = 0
            
        case g_typeList[1] :
            
            g_experiencesByType = g_experiencesByType2
            g_pickerSelectedIndex = 1
            
        case g_typeList[2] :
            
            g_experiencesByType = g_experiencesByType3
            g_pickerSelectedIndex = 2
            
        case g_typeList[3] :
            
            g_experiencesByType = g_experiencesByType4
            g_pickerSelectedIndex = 3
            
        case g_typeList[4] :
            
            g_experiencesByType = g_experiencesByType5
            g_pickerSelectedIndex = 4
            
        default:
            break
            
        }
    }

    
    func addExperience(a_user:String, a_type: String, a_title: String, a_desc:String, a_location:String){
        
        var dicExperience: Dictionary<String,String> = Dictionary<String,String>()
        
        dicExperience["m_user"] = a_user
        dicExperience["m_type"] = a_type
        dicExperience["m_title"] = a_title
        dicExperience["m_desc"] = a_desc
        dicExperience["m_location"] = a_location

        if(persistenceHelper.save("CoreExperience", parameters: dicExperience)){
            experiences.append(Experience(m_user: a_user, m_type:a_type, m_title:a_title, m_desc:a_desc, m_location:a_location))
            println("Appended new item with title \(a_title) and type \(a_type) and user \(a_user) and location is \(a_location) , and description is \(a_desc)")
        }
    }
    
    
    func removeExperience(index:Int){
        
        var value = getValueToBeDeleted(index)
     //   var value:String = experiences[index].m_title
        
        if(persistenceHelper.remove("CoreExperience", key: "m_title", value: value)){
            experiences.removeAtIndex(index)
             println("Removed item with title \(value)")
        }
    }

    func getValueToBeDeleted(index:Int)-> String {
        
        var valueToBeDeleted = ""
        switch (g_selectedType) {
            
        case g_typeList[0] :
            
            valueToBeDeleted = g_experiencesByType1[index].m_title
            
            
        case g_typeList[1] :
            
            valueToBeDeleted = g_experiencesByType2[index].m_title

            
        case g_typeList[2] :
            
            valueToBeDeleted = g_experiencesByType3[index].m_title
            
        case g_typeList[3] :
            
            valueToBeDeleted = g_experiencesByType4[index].m_title
            
        case g_typeList[4] :
            
            valueToBeDeleted = g_experiencesByType5[index].m_title
            
        default:
            break
            
        }

        return valueToBeDeleted
    }
}
