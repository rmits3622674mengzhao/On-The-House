//
//  FirstPageController.swift
//  On-The-House
//
//  Created by beier nie on 21/3/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    
    

    
    @IBOutlet weak var EmailInputBox: UITextField!
    
    @IBOutlet weak var PasswordInputBox: UITextField!
    
    var memberToken:Member?
    override func viewDidLoad() {
        
        
        EmailInputBox.placeholder="Email"
        PasswordInputBox.placeholder="Password"
        
        super.viewDidLoad()
        
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if let usernameT = EmailInputBox.text, let passwordT = PasswordInputBox.text{
            let postBodys = "email=\(usernameT)&password=\(passwordT)"
            //let postBody = "email=nazisang@gmail.com&password=summer1993"
            //print(postBodys)
            let memberService = MemberService()
            
            memberService.login(postBody: postBodys) { (member) in
                self.memberToken = member
                if member?.status == "success"{
                    //Set user details to get it later in the application
                    UserDefaults.standard.set(self.memberToken?.id, forKey: "member_id")
                    UserDefaults.standard.set(self.memberToken?.first_name, forKey: "first_name")
                    UserDefaults.standard.set(self.memberToken?.last_name, forKey: "last_name")
                    UserDefaults.standard.set(self.memberToken?.zone_id, forKey: "zone_id")
                    UserDefaults.standard.set(self.memberToken?.email, forKey: "email")
                    UserDefaults.standard.set(self.memberToken?.nickname, forKey: "nickname")
                    UserDefaults.standard.set(self.memberToken?.zip, forKey: "zip")
                    UserDefaults.standard.set(self.memberToken?.membership_level_id, forKey: "membership_level_id")
                    UserDefaults.standard.set(self.memberToken?.title, forKey: "title")
                    UserDefaults.standard.set(self.memberToken?.age, forKey: "age")
                    UserDefaults.standard.set(self.memberToken?.phone, forKey: "phone")
                    UserDefaults.standard.set(self.memberToken?.address1, forKey: "address1")
                    UserDefaults.standard.set(self.memberToken?.address2, forKey: "address2")
                    UserDefaults.standard.set(self.memberToken?.city, forKey: "city")
                    UserDefaults.standard.set(self.memberToken?.timezone_id, forKey: "timezone_id")
                    UserDefaults.standard.set(self.memberToken?.country_id, forKey: "country_id")
                    UserDefaults.standard.set(self.memberToken?.focus_groups, forKey: "focus_groups")
                    UserDefaults.standard.set(self.memberToken?.paid_marketing, forKey: "paid_marketing")
                    UserDefaults.standard.set(self.memberToken?.newsletters, forKey: "newsletters")
                    UserDefaults.standard.set(self.memberToken?.categories, forKey: "categories")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.synchronize()
                    OperationQueue.main.addOperation {
                        self.performSegue(withIdentifier: "loginSuccess", sender: self)
                    }
                }else{
                    OperationQueue.main.addOperation {
                        print("login failed!")
                        let msgMessage = "Wrong Usename or password!"
                        self.showAlert(msgMessage: msgMessage)
                    }
                    
                }
            }
        }
        
    }
    
    func showAlert(msgMessage:String){
        let alert = UIAlertController(title: "Error", message: msgMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

