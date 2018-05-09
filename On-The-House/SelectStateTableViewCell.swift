//
//  SelectStateTableViewCell.swift
//  On-The-House
//
//  Created by Kay Hoang on 5/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class SelectStateTableViewCell: UITableViewCell {

    @IBOutlet weak var lbState: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
