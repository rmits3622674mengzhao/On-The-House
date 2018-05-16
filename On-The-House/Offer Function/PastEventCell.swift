//
//  PastEventCell.swift
//  On-The-House
//
//  Created by beier nie on 14/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class PastEventCell: UITableViewCell {

    @IBOutlet weak var PastEventName: UILabel!
    @IBOutlet weak var PastEventRatingControl: RatingControl!
    @IBOutlet weak var PastEventImage: UIImageView!
    @IBOutlet weak var PastEventDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

