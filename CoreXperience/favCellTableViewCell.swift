//
//  favCellTableViewCell.swift
//  CoreXperience
//
//  Created by Prabhu Eshwarla on 17/11/14.
//  Copyright (c) 2014 iTripuram. All rights reserved.
//

import UIKit

class favCellTableViewCell: UITableViewCell {

    @IBOutlet weak var d_expTitle: UILabel!
    
    @IBOutlet weak var d_expCategory: UILabel!
    
    
    @IBOutlet weak var d_image: UIImageView!
    
    @IBOutlet weak var d_date: UILabel!
    
    @IBOutlet weak var d_expDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
