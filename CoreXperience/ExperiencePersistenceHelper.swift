//
//  ExperiencePersistenceHelper.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import CoreData

class ExperiencePersistenceHelper: NSObject {
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var context: NSManagedObjectContext;
    
    override init(){
        context = appDel.managedObjectContext!
    }
    
    func save(entity: String, parameters: Dictionary<String,String> )->Bool{
        
        var newEntity = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: context) as NSManagedObject
        for (key, value) in parameters{
            newEntity.setValue(value, forKey: key)
        }
        
        return context.save(nil)
    }
    
  
    
    
    func list(entity: String ) ->NSArray{
        
        var request = NSFetchRequest(entityName: entity)
        request.returnsObjectsAsFaults = false;
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        return results
    }
    
    func listForTitle (entity: String, title: String) ->NSArray {
        
        var request = NSFetchRequest(entityName: entity)
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "m_title == %@", title)
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        return results
    }
    
    
    func remove(entity:String, key:String, value:String)->Bool{
        
        var request = NSFetchRequest(entityName: entity)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "\(key) = %@", value)
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count>0){
            
            var res = results[0] as NSManagedObject
            context.deleteObject(res)
            context.save(nil)
            return true
        }
        
        return false
    }
    

   
}
