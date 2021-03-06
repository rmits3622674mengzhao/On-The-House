//
//  ReviewTableViewCell.swift
//  On-The-House
//
//  Created by Kay Hoang on 18/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var lbNickName: UILabel!
    @IBOutlet weak var stackRating: RatingControl!
    @IBOutlet weak var lbComments: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
