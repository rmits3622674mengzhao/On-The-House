//
//  HamburgerMenuTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 22/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class HamburgerMenuTableViewController: UITableViewController{
  
    
    
    @IBOutlet weak var cellLogout: UITableViewCell!
    @IBOutlet weak var cellLogin: UITableViewCell!
    @IBOutlet weak var cellWelcomeMsg: UITableViewCell!
    @IBOutlet weak var lbUserName: UILabel!
    var WelcomeMsg = ""
    var memberID = ""
    var membership :[String: Any] = [:]
    var membershipHistory :[[String: Any]] = [[:]]
    var userFullName = ""
    var islogedIn:Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        islogedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        checkLogin()
        if let member_id = UserDefaults.standard.string(forKey: "member_id")
        {
            self.memberID = member_id
            print(self.memberID)
        }
        
        loadWelcomeMsg()
    }
    func loadWelcomeMsg(){
        if(islogedIn == true){
            if let firstName = UserDefaults.standard.string(forKey: "first_name"), let lastName = UserDefaults.standard.string(forKey: "last_name")
            {
                WelcomeMsg = ("\(String(describing: firstName)) \(String(describing: lastName))")
                lbUserName.text = WelcomeMsg
                print("this is welcome msg")
                print(WelcomeMsg)
                //For next view
                self.userFullName = ("\(String(describing: firstName)) \(String(describing: lastName))")
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }else{
            lbUserName.text = "Welcome"
        }
    }
    
    func checkLogin(){
        if let logincheck = islogedIn{
            if logincheck{
                cellLogin.isHidden = true
                cellLogout.isHidden = false
            }else{
                cellLogout.isHidden = true
                cellLogin.isHidden = false
            }
        }
    }
    
    @IBAction func MyReservationAction(_ sender: UIButton) {
        if islogedIn!{
            self.performSegue(withIdentifier: "myReservation", sender: self)
        }else{
            self.performSegue(withIdentifier: "loginFirst", sender: self)
        }
    }
    @IBAction func MyOrderHistoryAction(_ sender: UIButton) {
        if islogedIn!{
            self.performSegue(withIdentifier: "myOrderHistory", sender: self)
        }else{
            self.performSegue(withIdentifier: "loginFirst", sender: self)
        }
    }
    @IBAction func MyMembershipAction(_ sender: UIButton) {
        if islogedIn!{
            self.performSegue(withIdentifier: "myMembership", sender: self)
        }else{
            self.performSegue(withIdentifier: "loginFirst", sender: self)
        }
    }
    @IBAction func UpdateMyProfileAction(_ sender: UIButton) {
        if islogedIn!{
            self.performSegue(withIdentifier: "updateMyProfile", sender: self)
        }else{
            self.performSegue(withIdentifier: "loginFirst", sender: self)
        }
    }
    @IBAction func ChangePasswordAction(_ sender: UIButton) {
        if islogedIn!{
            self.performSegue(withIdentifier: "changePassword", sender: self)
        }else{
            self.performSegue(withIdentifier: "loginFirst", sender: self)
        }
    }
    @IBAction func LogoutAction(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
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

