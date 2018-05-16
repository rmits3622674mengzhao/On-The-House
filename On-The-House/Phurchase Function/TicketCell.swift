//
//  TicketCell.swift
//  On-The-House
//
//  Created by beier nie on 15/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class TicketCell: UITableViewCell {

    
    @IBOutlet weak var TicketType: UILabel!
    
    @IBOutlet weak var TicketTime: UILabel!
    
    @IBOutlet weak var TicketVenue: UILabel!
    
    @IBOutlet weak var quantity: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        quantity.placeholder = "Done"
        // Configure the view for the selected state
    }

}
