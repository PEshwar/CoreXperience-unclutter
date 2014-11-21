//
//  fullPhotoViewController.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 21/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

class fullPhotoViewController: UIViewController {

    var tempImage = UIImage()
    
    @IBAction func photoTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    //    navigationController?.popViewControllerAnimated(true)

    }
   
    @IBOutlet weak var fullPhotoView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fullPhotoView.image = tempImage
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
