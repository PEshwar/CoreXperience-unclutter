//
//  categoryTableViewCell.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 12/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

class categoryTableViewCell: UITableViewCell {

 
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
