//
//  showImagePickerViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 05/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

protocol userPickedPhotoDelegate {
    func userDidPickPhoto(selectedPhoto : UIImage)
}

class showImagePickerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

     var delegatePhoto: userPickedPhotoDelegate? = nil
    var tempPhoto : UIImage = UIImage()
    var viewMode : Bool = false
    
    @IBOutlet weak var photoButton: UIButton!
    
    var pickerController:UIImagePickerController = UIImagePickerController()
    
    @IBOutlet weak var d_imageView: UIImageView!
    
    @IBAction func chooseImagePressed(sender: UIButton) {
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        // 2
        self.presentViewController(pickerController, animated: true, completion: nil)
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        d_imageView.image = tempPhoto
        
        if viewMode == true {
            photoButton.hidden = true
        }
       
        // Do any additional setup after loading the view.
    }

    @IBAction func donePressed(sender: UIButton) {
        self.delegatePhoto?.userDidPickPhoto(d_imageView.image!)
    /*
        //save image to documents directory
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                   
                    let writePath = dirPath.stringByAppendingPathComponent("share2.jpeg")
                    println("write path is \(writePath)")
                    UIImageJPEGRepresentation(d_imageView.image, 1.0).writeToFile(writePath, atomically: true)
                }
            }
        }
*/
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
       
        d_imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
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

}
