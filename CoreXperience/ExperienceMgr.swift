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




var g_typeList:[String] = []

var g_selectedTypeIndex : Int = 0

var g_pickerSelectedIndex : Int = 0



struct Experience {
    var m_user: String = ""
    var m_type: String = ""
    var m_title: String = " "
    var m_desc: String = ""
    var m_location: String = ""
    var m_audio_location : String = ""
   var m_favourites: Bool  = true
   var m_date: NSDate
    var m_photo_blob : UIImage
    var m_audio_blob : AnyObject
    
    
}


