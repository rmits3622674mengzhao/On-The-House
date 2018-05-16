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
        var msgTitle:String = ""
        var msgMessage:String = ""
        if tfnewPassword.text == "" || tfConfirmPassword.text == ""{
            msgTitle = "Error"
            msgMessage = "Please enter your new password"
            showAlert(msgTitle: msgTitle, msgMessage: msgMessage)
        }else if tfnewPassword.text != tfConfirmPassword.text{
            msgTitle = "Error"
            msgMessage = "Passwords do not match!"
            showAlert(msgTitle: msgTitle, msgMessage: msgMessage)
        }else{
            let postBodys = "member_id=\(memberID)&password=\(tfnewPassword.text!)&password_confirm=\(tfConfirmPassword.text!)"
            print(postBodys)
            if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/change-password"){
                let network = NetworkProcessor(url: memberURL)
                network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                    if let status = jsonDictionary?["status"] as? String{
                        if status == "success"{
                            msgTitle = "Success"
                            msgMessage = "Your password has been successfully updated!"
                            OperationQueue.main.addOperation {
                                self.showAlert(msgTitle: msgTitle, msgMessage: msgMessage)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
