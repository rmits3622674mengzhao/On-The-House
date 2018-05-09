//
//  PreferedCategoriesTableViewCell.swift
//  On-The-House
//
//  Created by Kay Hoang on 2/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class PreferedCategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbCategory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
