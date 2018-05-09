//
//  CurrentEvents.swift
//  On-The-House
//
//  Created by Dong Wang on 2018/4/11.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit

class OfferEventCell: UITableViewCell {
    //MARK: Properties
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

