//
//  MyOrderHistoryTableViewCell.swift
//  On-The-House
//
//  Created by Kay Hoang on 21/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class MyOrderHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lbEventName: UILabel!
    @IBOutlet weak var lbEventVenue: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    
    @IBOutlet weak var lbVenueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

