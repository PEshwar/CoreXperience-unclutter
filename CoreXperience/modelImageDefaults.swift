//
//  modelImageDefaults.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 23/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//


import UIKit
import CoreData

class modelImageDefaults: NSManagedObject {
    
    @NSManaged var m_defaultCategory : String
    @NSManaged var m_defaultImage : UIImage
}
