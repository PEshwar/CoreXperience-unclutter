//
//  ExperienceMgr.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

var expMgr:ExperienceMgr = ExperienceMgr()

struct Experience {
    var m_user: String = "Family"
    var m_type: String = "Spiritual experience"
    var m_title: String = "Test "
    var m_desc: String = "Test desc "
    var m_location: String = "Bangalore "
}

class ExperienceMgr: NSObject {
   
    var experiences = [Experience]()
    var persistenceHelper: ExperiencePersistenceHelper = ExperiencePersistenceHelper()
    
    override init(){
        
        var tempExperiences:NSArray = persistenceHelper.list("CoreExperience")
        for res:AnyObject in tempExperiences{
            experiences.append(Experience(m_user:res.valueForKey("m_user") as String, m_type:res.valueForKey("m_type") as String,m_title:res.valueForKey("m_title") as String,m_desc:res.valueForKey("m_desc") as String,m_location:res.valueForKey("m_location") as String ))
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
        }
    }
    
    func removeExperience(index:Int){
        
        var value:String = experiences[index].m_user
        
        if(persistenceHelper.remove("CoreExperience", key: "m_user", value: value)){
            experiences.removeAtIndex(index)
        }
    }

    
}
