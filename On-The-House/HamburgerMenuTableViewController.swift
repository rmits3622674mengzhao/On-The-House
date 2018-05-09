//
//  HamburgerMenuTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 22/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class HamburgerMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var lbUserName: UILabel!
    var WelcomeMsg = ""
    var memberID = ""
    var membership :[String: Any] = [:]
    var membershipHistory :[[String: Any]] = [[:]]
    var userFullName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let member_id = UserDefaults.standard.string(forKey: "member_id")
        {
            self.memberID = member_id
            print(self.memberID)
        }
        
        loadWelcomeMsg()
    }
    func loadWelcomeMsg(){
        if let firstName = UserDefaults.standard.string(forKey: "first_name"), let lastName = UserDefaults.standard.string(forKey: "last_name")
        {
            WelcomeMsg = ("Welcome, \(String(describing: firstName)) \(String(describing: lastName))")
            lbUserName.text = WelcomeMsg
            print("this is welcome msg")
            print(WelcomeMsg)
            //For next view
            self.userFullName = ("\(String(describing: firstName)) \(String(describing: lastName))")
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    //prepare data for My Membership screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myMembership"{
            let nav = segue.destination as! UINavigationController
            let nextView = nav.topViewController as? MyMembershipViewController
            nextView?.userFullName = userFullName
            //load current user's membership
            let postBodys = "member_id=\(memberID)"
            if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/membership"){
                let network = NetworkProcessor(url: memberURL)
                network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                    if let status = jsonDictionary?["status"] as? String{
                        if status == "success"{
                            self.membership = (jsonDictionary?["membership"] as? [String: Any])!
                            UserDefaults.standard.set(self.membership["membership_level_name"], forKey: "membership_level_name")
                            nextView?.membership = self.membership
                        }else if status == "error"{
                            print("fail to load json")
                        }
                    }
                }
            }
            if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/membership/history"){
                let network = NetworkProcessor(url: memberURL)
                network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                    if let status = jsonDictionary?["status"] as? String{
                        if status == "success"{
                            self.membershipHistory = (jsonDictionary?["memberships"] as? [[String: Any]])!
                            nextView?.membershipHistory = self.membershipHistory
                        }else if status == "error"{
                            print("fail to load json")
                        }
                    }
                }
            }
        }
    }
}

