//
//  OfferEventCell.swift
//  On-The-House
//
//  Created by beier nie on 14/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class OfferEventCell: UITableViewCell {

    //MARK: Properties
    let apiConnection = APIconnection()
    @IBOutlet weak var MemberLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var CompetitionLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var ticketBtn: UIButton!
    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var competeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


