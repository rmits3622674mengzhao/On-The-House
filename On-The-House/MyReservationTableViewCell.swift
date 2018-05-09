//
//  MyEventTableViewCell.swift
//  On-The-House
//
//  Created by Kay Hoang on 19/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class MyReservationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbVenueName: UILabel!
    @IBOutlet weak var nameCell: UILabel!
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

