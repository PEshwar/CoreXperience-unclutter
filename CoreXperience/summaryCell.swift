//
//  summaryCell.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 11/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

class summaryCell: UITableViewCell {

   
    
    @IBOutlet weak var d_image: UIImageView!
    
    @IBOutlet weak var d_labelTitle: UILabel!
    
    @IBOutlet weak var d_labelItems: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
