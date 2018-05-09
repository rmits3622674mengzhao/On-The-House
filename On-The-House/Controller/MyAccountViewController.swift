//
//  MyAccountPageViewController.swift
//  On-The-House
//
//  Created by beier nie on 5/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {

    @IBOutlet weak var NickNameLabel: UILabel!
    var nickName:String?
    var first_name:String?
    var last_name:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        NickNameLabel.text = nickName

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
