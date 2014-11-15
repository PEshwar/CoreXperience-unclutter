//
//  categoryImageViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 15/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit
import CoreData

protocol categoryImagePickedDelegate {
    func userImagePicked(selectedPhoto : UIImage, categoryName : String)
}

class categoryImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var l_PhotoLocation : String = ""
    var delegateImageCat: categoryImagePickedDelegate? = nil
    
    var pickerController:UIImagePickerController = UIImagePickerController()
    
    @IBOutlet weak var d_catImageView: UIImageView!
    
    
    @IBOutlet weak var d_catName: UITextField!
    
    @IBAction func donePressed(sender: AnyObject) {
       
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext;
        context = appDel.managedObjectContext!
        let ent = NSEntityDescription.entityForName("CoreCategory", inManagedObjectContext: context)
        //Createa instance of model Category class
        var newCategory = modelCategory(entity: ent!, insertIntoManagedObjectContext: context)
        newCategory.md_category = d_catName!.text
        
        // Save image to disk and store location in category table
        
        var imageData = UIImageJPEGRepresentation(d_catImageView.image, 1.0)
        if imageData != nil {
            
            
            //save image to documents directory
            let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
            if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let dirPath = paths[0] as? String {
                        
                        var format = NSDateFormatter()
                        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
                        l_PhotoLocation = "Photo-\(format.stringFromDate(NSDate.date())).jpeg"
                        
                        //   let writePath = dirPath.stringByAppendingPathComponent("share2.jpeg")
                        let writePath = dirPath.stringByAppendingPathComponent(l_PhotoLocation)
                        println("write path is \(writePath)")
                        
                        UIImageJPEGRepresentation(d_catImageView.image, 1.0).writeToFile(writePath, atomically: true)
                    }
                }
            }
        }
        
        
        
        
        //End save image to disk
        newCategory.md_categoryImage = l_PhotoLocation
        context.save(nil)
        println("Context Saved")

        self.delegateImageCat?.userImagePicked(d_catImageView.image!, categoryName: d_catName.text!)
         navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    @IBAction func pickImagePressed(sender: AnyObject) {
    
   
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        // 2
        self.presentViewController(pickerController, animated: true, completion: nil)
        
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        d_catImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //   let mediaType = info[UIImagePickerControllerMediaType]! as String
        if let mediaType = info[UIImagePickerControllerMediaType]! as? String {
            println("Media Type is \(mediaType)")
            // do yo thang
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
