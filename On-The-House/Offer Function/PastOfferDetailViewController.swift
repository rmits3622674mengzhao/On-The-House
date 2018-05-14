//
//  PastOfferDetailViewController.swift
//  On-The-House
//
//  Created by beier nie on 14/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class PastOfferDetailViewController: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Rate: RatingControl!
    @IBOutlet weak var Description: UITextView!
    
    var pastOfferDetail:OfferModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Name.text = pastOfferDetail.name
        Rate.rating = pastOfferDetail.rate
        Description.text = pastOfferDetail.description
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}


