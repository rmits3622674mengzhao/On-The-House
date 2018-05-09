//
//  MembershipInfoViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 27/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class MembershipInfoViewController: UIViewController {
    @IBOutlet weak var lbGoldInfo: UILabel!
    
    @IBOutlet weak var lbBronzeInfo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbGoldInfo.text = "As a Gold Member you will have access to premium tickets on our site for a period of 6 months, these tickets will not incur an admin fee. \n \nYou can reserve tickets that are available for both Bronze and Gold Members. You do not pay an admin fee when you take up complimentary tickets. \n \nIf you want to reserve tickets provided to ON THE HOUSE at cut price, you will be charged the ON THE HOUSE ticket price. \n \nStay subcribed to our newsletters to receive our newsletter notifications."
        lbBronzeInfo.text = "Bronze membership allows you to book tickets right throughout the year. \n \nA small admin charge may apply to reserve some give-aways or promotional tickets. \n \nIf you reserve tickets provided to ON THE HOUSE at cut price, you will be charged the ON THE HOUSE ticket price. \n \nYou can reserve tickets available for bronze members only. \n \nStay subcribed to our newsletters to receive our newsletter notifications. "
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

