//
//  HamburgerMenuTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 22/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class HamburgerMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var cellLogout: UITableViewCell!
    @IBOutlet weak var cellLogin: UITableViewCell!
    @IBOutlet weak var cellWelcomeMsg: UITableViewCell!
    @IBOutlet weak var lbUserName: UILabel!
    var WelcomeMsg = ""
    var userFullName = ""
    var islogedIn:Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        islogedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        checkLogin()
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
}

