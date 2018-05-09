//
//  MyMembershipHistoryTableViewCell.swift
//  On-The-House
//
//  Created by Kay Hoang on 26/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class MyMembershipHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbMembershipName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

