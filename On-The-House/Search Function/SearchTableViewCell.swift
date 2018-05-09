//
//  SearchTableViewCell.swift
//  On-The-House
//
//  Created by beier nie on 2018/5/8.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var Rate: RatingControl!
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

