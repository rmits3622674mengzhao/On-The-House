//
//  ChangePasswordViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 9/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {    
    @IBOutlet weak var tfnewPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    var memberID = ""
    var status = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let member_id = UserDefaults.standard.string(forKey: "member_id")
        {
            self.memberID = member_id
            print(self.memberID)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func UpdatePasswordAction(_ sender: Any) {
        self.postNewPassword()
    }
    
    func postNewPassword(){
        if tfnewPassword.text == "" || tfConfirmPassword.text == ""{
            showAlert(msgTitle: "Error", msgMessage: "Please enter your new password")
        }else if tfnewPassword.text != tfConfirmPassword.text{
            showAlert(msgTitle: "Error", msgMessage: "Passwords do not match!")
        }else{
            let postBodys = "member_id=\(memberID)&password=\(tfnewPassword.text!)&password_confirm=\(tfConfirmPassword.text!)"
            print(postBodys)
            if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/change-password"){
                let network = NetworkProcessor(url: memberURL)
                network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                    if let status = jsonDictionary?["status"] as? String{
                        if status == "success"{
                            OperationQueue.main.addOperation {
                                self.showAlert(msgTitle: "Success", msgMessage: "Your password has been successfully updated!")
                            }
                        }else if status == "error"{
                            print("fail to load json")
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(msgTitle:String, msgMessage:String){
        let alert = UIAlertController(title: msgTitle, message: msgMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
