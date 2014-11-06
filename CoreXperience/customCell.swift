//
//  customCell.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 18/10/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {

    @IBOutlet weak var d_expTitle: UILabel!
    @IBOutlet weak var d_expDesc: UILabel!
    
    @IBOutlet weak var d_date: UILabel!
    
 //   @IBOutlet weak var playIcon: UILabel!
   
    
 
    @IBOutlet weak var playButtonList: UIButton!
 //   @IBOutlet weak var d_shareButton: UIButton!
   
    @IBOutlet weak var d_favouriteFlag: UIImageView!
    
  
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

 
}
