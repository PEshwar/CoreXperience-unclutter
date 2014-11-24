//
//  settingsViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 23/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import CoreData

let kCategoryDefaultConstant:String = "categoryDefaultImage"
let kExperienceDefaultConstant:String = "imageDefaultImage"
let kImageCompressionFactor  = CGFloat(1.0)
let kImageScaleDownHeight = CGFloat(500)

let kCategoryDefaultImage : UIImage = UIImage(named: "Bonsai.jpeg")
let kExperienceDefaultImage: UIImage = UIImage(named: "Bhagawad-Gita.jpg")

func imageDataScaledToHeight(imageData: NSData,
    height: CGFloat) -> NSData {
        
        let image = UIImage(data: imageData)
        let oldHeight = image.size.height
        let scaleFactor = height / oldHeight
        let newWidth = image.size.width * scaleFactor
        let newSize = CGSizeMake(newWidth, height)
        let newRect = CGRectMake(0, 0, newWidth, height)
        
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(newRect)
        let newImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImageJPEGRepresentation(newImage, 1.0)
}


class settingsViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var l_defaultList = [NSManagedObject]()
    
    var pickerController:UIImagePickerController = UIImagePickerController()
   
    var imagePicked : UIImage = UIImage()

    var l_categorySelect : Bool = Bool()
    

    @IBAction func categoryImageSelection(sender: AnyObject) {
        
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //Set flag to know if the image selected is for category or for experience
        
        l_categorySelect = true
        
        // 2
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func experienceImageSelection(sender: AnyObject) {
        
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
       //Set flag to know if the image selected is for category or for experience 
        l_categorySelect = false
        
        // 2
        self.presentViewController(pickerController, animated: true, completion: nil)
    }

    
    @IBAction func categoryImageSave(sender: AnyObject) {
        if l_categorySelect == true {
           
            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            var context: NSManagedObjectContext;
            context = appDel.managedObjectContext!
            let ent = NSEntityDescription.entityForName("DefaultImages", inManagedObjectContext: context)
     
            var newDefaultCategory = modelImageDefaults(entity: ent!, insertIntoManagedObjectContext: context)
           
            
            
            var persistenceHelper: ExperiencePersistenceHelper = ExperiencePersistenceHelper()
            if (persistenceHelper.remove("DefaultImages", key: "m_defaultCategory", value: kCategoryDefaultConstant)) {
                println("Removing category default image from db successful")
            } else {
                println("No  category default available to be removed from DB")
            }
           
            
            
            //Set Category image default in database
            
            newDefaultCategory.m_defaultCategory = kCategoryDefaultConstant
            var imageNSData = UIImageJPEGRepresentation(categoryDefaultImage.image!, kImageCompressionFactor)
            var scaledDownCategoryImage = imageDataScaledToHeight(imageNSData, kImageScaleDownHeight)
          //  newDefaultCategory.m_defaultImage = categoryDefaultImage.image!
            newDefaultCategory.m_defaultImage = UIImage(data:scaledDownCategoryImage)
            //     context.save(nil)
          
            
          
            
            
            context.save(nil)
            println("Category Default image Saved")
            
            //Set the image views in the settings screen
            
            //   categoryDefaultImage.image = kCategoryDefaultImage
            // experienceDefaultImage.image = kExperienceDefaultImage
            
         
            
        }
    }
    
    
    @IBAction func experienceImageSave(sender: AnyObject) {
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        let ent = NSEntityDescription.entityForName("DefaultImages", inManagedObjectContext: context)
   
        var newDefaultExperience = modelImageDefaults(entity: ent!, insertIntoManagedObjectContext: context)
        
        
        var persistenceHelper: ExperiencePersistenceHelper = ExperiencePersistenceHelper()

        if (persistenceHelper.remove("DefaultImages", key: "m_defaultCategory", value: kExperienceDefaultConstant)) {
            println("Removing experience default image from db successful")
        } else {
            println("No experience default available to be removed from DB")
        }
        
      
        
     
        
        
        //Set experience image default in database
        
        newDefaultExperience.m_defaultCategory = kExperienceDefaultConstant
        var imageNSData = UIImageJPEGRepresentation(experienceDefaultImage.image!, kImageCompressionFactor)
        var scaledDownExperienceImage = imageDataScaledToHeight(imageNSData, kImageScaleDownHeight)
        newDefaultExperience.m_defaultImage = UIImage(data: scaledDownExperienceImage)
      //  newDefaultExperience.m_defaultImage = experienceDefaultImage.image!
        
        context.save(nil)
        println("Experience Default image Saved")
        

        

    }
    
    
    @IBOutlet weak var categoryDefaultImage: UIImageView!
    
    
    @IBOutlet weak var experienceDefaultImage: UIImageView!
    
    
    @IBAction func restoreCategoryDefaults(sender: AnyObject) {
        
        
        
        
    }
    
    
    @IBAction func restoreImageDefaults(sender: AnyObject) {
        
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        let ent = NSEntityDescription.entityForName("DefaultImages", inManagedObjectContext: context)
        var newDefaultCategory = modelImageDefaults(entity: ent!, insertIntoManagedObjectContext: context)
        var newDefaultExperience = modelImageDefaults(entity: ent!, insertIntoManagedObjectContext: context)

        
        var persistenceHelper: ExperiencePersistenceHelper = ExperiencePersistenceHelper()
        if (persistenceHelper.remove("DefaultImages", key: "m_defaultCategory", value: kCategoryDefaultConstant)) {
            println("Removing category default image from db successful")
        } else {
            println("No  category default available to be removed from DB")
        }
        if (persistenceHelper.remove("DefaultImages", key: "m_defaultCategory", value: kExperienceDefaultConstant)) {
            println("Removing experience default image from db successful")
        } else {
            println("No experience default available to be removed from DB")
        }
        
        //Set Category image default in database
        
        newDefaultCategory.m_defaultCategory = kCategoryDefaultConstant
        newDefaultCategory.m_defaultImage = UIImage(named: "Bonsai.jpeg")
        
   //     context.save(nil)
        println("Category Default image Saved")
        
        
      //Set experience image default in database
        
        newDefaultExperience.m_defaultCategory = kExperienceDefaultConstant
        newDefaultExperience.m_defaultImage = UIImage(named: "Bhagawad-Gita.jpg")

        
        context.save(nil)
        println("Experience Default image Saved")
   
        //Set the image views in the settings screen
        
     //   categoryDefaultImage.image = kCategoryDefaultImage
       // experienceDefaultImage.image = kExperienceDefaultImage
        
        setCategoryDefaultImage()
        setExperienceDefaultImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setExperienceDefaultImage()
        setCategoryDefaultImage()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func donePressed(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        var defaultImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if l_categorySelect == true {
            categoryDefaultImage.image = defaultImage
        } else {
            experienceDefaultImage.image = defaultImage
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func setCategoryDefaultImage() {
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        
        
        let fetchRequest = NSFetchRequest(entityName:"DefaultImages")
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format: "m_defaultCategory == %@", kCategoryDefaultConstant)
        let l_defaultList = context.executeFetchRequest(fetchRequest, error: nil)! as [NSManagedObject]
        println(" TypeList count is \(l_defaultList.count)")
        
        if l_defaultList.count > 0 {
        categoryDefaultImage.image = l_defaultList[0].valueForKeyPath("m_defaultImage") as? UIImage
        }
               //    println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
    }
    
    func setExperienceDefaultImage() {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"DefaultImages")
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format: "m_defaultCategory == %@", kExperienceDefaultConstant)
        let l_defaultList = context.executeFetchRequest(fetchRequest, error: nil)! as [NSManagedObject]
        println(" TypeList count is \(l_defaultList.count)")
         if l_defaultList.count > 0 {
        experienceDefaultImage.image = l_defaultList[0].valueForKeyPath("m_defaultImage") as? UIImage
        }
        //    println(" selected Type is  \(g_typeList[g_selectedTypeIndex])")
    }
    }
    

