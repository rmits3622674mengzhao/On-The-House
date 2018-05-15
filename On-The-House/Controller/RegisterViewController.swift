//
//  SignInPageController.swift
//  On-The-House
//
//  Created by beier nie on 21/3/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
import UIKit

var zoneIndex: Int = 0
class RegisterViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statechoices.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statechoices[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        StateLable.text = statechoices[row]
        
    }
    
    
  
    

    @IBOutlet var myView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.heightAnchor.constraint(equalToConstant: 173).isActive = true
        myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let c =  myView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 173)
        c.identifier = "bottom"
        c.isActive = true
        myView.layer.cornerRadius = 10
        
        super.viewWillAppear(animated)
    }
    //var UserNameBox: UITextField
    
    //@IBOutlet weak var Reference: UILabel!
    @IBOutlet weak var UserNameBox: UITextField!
    @IBOutlet weak var FirstNameBox: UITextField!
    @IBOutlet weak var LastNameBox: UITextField!
    @IBOutlet weak var EmailBox: UITextField!
    @IBOutlet weak var PasswordBox: UITextField!
    @IBOutlet weak var ConfirmPasswordBox: UITextField!
    @IBOutlet weak var PostCodeBox: UITextField!
    @IBOutlet weak var StateLable: UILabel!
    
    
    var statechoices = ["Australian Capital Territory", "New South Wales", "North Territory", "Queensland", "South Australia", "Tasmania", "Victoria", "Western Australia"]
    
    var stateId = ["210", "211", "212", "213", "214", "215", "216", "217"]
    
    
    
    
    
    
    
    
    
    var memberToken:Member?
    
    var status:Bool?;
    //PostCodeBox.placeholder="POST CODE"
    func createApiCall(){
        if let usernameT = UserNameBox.text, let firstNameT = FirstNameBox.text, let lastNameT = LastNameBox.text,let emailT = EmailBox.text, let passwordT = PasswordBox.text,  let passwordconfirmT = ConfirmPasswordBox.text,let zipId = PostCodeBox.text{
            let postBodys = "nickname=\(usernameT)&first_name=\(firstNameT)&last_name=\(lastNameT)&email=\(emailT)&password=\(passwordT)&password_confirm=\(passwordconfirmT)&terms=1&zone_id=\(stateId[zoneIndex])&country_id=13&timezone_id=108&zip=\(zipId)"
            
            let memberService = MemberService()
            memberService.createMember(member: postBodys) { (member) in
                self.memberToken = member
                print(member?.status)
                if member?.status == "success"{
                    self.status = true
                }else{
                    self.status = false
                }
            }
            
        }
    }

    
    @IBAction func createAccount(_ sender: Any) {
        if let usernameT = UserNameBox.text, let firstNameT = FirstNameBox.text, let lastNameT = LastNameBox.text,let emailT = EmailBox.text, let passwordT = PasswordBox.text,  let passwordconfirmT = ConfirmPasswordBox.text,let zipId = PostCodeBox.text{
            let postBodys = "nickname=\(usernameT)&first_name=\(firstNameT)&last_name=\(lastNameT)&email=\(emailT)&password=\(passwordT)&password_confirm=\(passwordconfirmT)&terms=1&zone_id=\(stateId[zoneIndex]))&country_id=13&timezone_id=108&zip=\(zipId)"
            
            let memberService = MemberService()
            memberService.createMember(member: postBodys) {(member) in
                self.memberToken = member
                print(member?.status)
                if member?.status == "success"{
                    self.status = true
                }else{
                    self.status = false
                }
                
                if self.status == true{
                    let button2Alert: UIAlertView = UIAlertView(title: "Sign Up Successful", message: "Please log in",delegate: nil, cancelButtonTitle: "OK")
                    
                    button2Alert.show()
                    
                }else if self.status == false{
                    
                    print("hello",member?.message)
                    
                    let button2Alert: UIAlertView = UIAlertView(title: "Sorry", message: member?.message?.description,delegate: nil, cancelButtonTitle: "OK")
                    button2Alert.show()
                }else{
                    print("status is nil")
                }
            }
            
        }
    }
    
    @IBAction func stateSelect(_ sender: Any) {
        
        displayPickerView(true)
    }
    
    @IBAction func stateGoBack(_ sender: Any) {
        
        displayPickerView(false)
    }
    
    func displayPickerView(_ show: Bool){
        for c in view.constraints{
            if c.identifier == "bottom"{
                c.constant = (show) ? -10 : 173
                break
            }
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    override func viewDidLoad(){
        UserNameBox.placeholder="USER NAME"
        FirstNameBox.placeholder="FIRST NAME"
        LastNameBox.placeholder="LAST NAME"
        EmailBox.placeholder="EMAIL ADRESS"
        PasswordBox.placeholder="PASSWORD"
        ConfirmPasswordBox.placeholder="CONFIRM PASSWORD"
        PostCodeBox.placeholder="POST CODE"
        
        
        
        
        
        
        super.viewDidLoad()
        
        
        
        
        
    }
    
}



