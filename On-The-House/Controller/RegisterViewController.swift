//
//  SignInPageController.swift
//  On-The-House
//
//  Created by beier nie on 21/3/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
import UIKit

//var zoneIndex: Int = 0

class RegisterViewController : UIViewController, UIPickerViewDataSource, UITableViewDelegate{
    
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
        //  zoneIndex=row
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
    @IBOutlet weak var PreferenceLabel: UILabel!
    
    
    var statechoices = ["Australian Capital Territory", "New South Wales", "North Territory", "Queensland", "South Australia", "Tasmania", "Victoria", "Western Australia"]
  
    @objc func UserNameBoxDidChange(_ UserNameBox: UITextField) {
        UserDefaults.standard.set("false", forKey: "registerFinished")
        UserDefaults.standard.set(UserNameBox.text, forKey: "userNameBoxXia")
    }
    
    @objc func FirstNameBoxDidChange(_ UserNameBox: UITextField) {
        UserDefaults.standard.set("false", forKey: "registerFinished")
        UserDefaults.standard.set(UserNameBox.text, forKey: "firstNameBoxXia")
    }
    
    @objc func LastNameBoxDidChange(_ UserNameBox: UITextField) {
        UserDefaults.standard.set("false", forKey: "registerFinished")
        UserDefaults.standard.set(UserNameBox.text, forKey: "lastNameBoxXia")
    }
    
    @objc func EmailBoxDidChange(_ UserNameBox: UITextField) {
        UserDefaults.standard.set("false", forKey: "registerFinished")
        UserDefaults.standard.set(UserNameBox.text, forKey: "emailBoxXia")
    }
    
    @objc func PasswordBoxDidChange(_ UserNameBox: UITextField) {
        UserDefaults.standard.set("false", forKey: "registerFinished")
        UserDefaults.standard.set(UserNameBox.text, forKey: "passwordBoxXia")
    }
    
    @objc func ConfirmPasswordBoxDidChange(_ UserNameBox: UITextField) {
        UserDefaults.standard.set("false", forKey: "registerFinished")
        UserDefaults.standard.set(UserNameBox.text, forKey: "confirmPasswordboxXia")
    }
    
    @objc func PostCodeBoxDidChange(_ UserNameBox: UITextField) {
        UserDefaults.standard.set("false", forKey: "registerFinished")
        UserDefaults.standard.set(UserNameBox.text, forKey: "postCodeBoxXia")
    }
    
    
    
    var memberToken:Member?
    
    var status:Bool?;
    //PostCodeBox.placeholder="POST CODE"
    
    
    @IBAction func createAccount(_ sender: Any) {
        if let usernameT = UserNameBox.text, let firstNameT = FirstNameBox.text, let lastNameT = LastNameBox.text,let emailT = EmailBox.text, let passwordT = PasswordBox.text,  let passwordconfirmT = ConfirmPasswordBox.text,let zipId = PostCodeBox.text, let stateT = StateLable.text , let preferenceT =  PreferenceLabel.text {
            if stateT != "STATE"{
                let postBodys = "nickname=\(usernameT)&first_name=\(firstNameT)&last_name=\(lastNameT)&email=\(emailT)&password=\(passwordT)&password_confirm=\(passwordconfirmT)&question_id=\(DataTransition.questions[preferenceT])&zone_id=\(DataTransition.states[stateT])&country_id=13&timezone_id=\(DataTransition.statetimezone[stateT])&zip=\(zipId)&terms=1"
                self.sendRequest(postBodys: postBodys)
            }else{
                let postBodys = "nickname=\(usernameT)&first_name=\(firstNameT)&last_name=\(lastNameT)&email=\(emailT)&password=\(passwordT)&password_confirm=\(passwordconfirmT)&question_id=\(DataTransition.questions[preferenceT])&country_id=13&timezone_id=\(DataTransition.statetimezone[stateT])&zip=\(zipId)&terms=1"
                
                self.sendRequest(postBodys: postBodys)
            }
        }
    }
        
        func sendRequest(postBodys: String) {
            let memberService = MemberService()
            memberService.createMember(member: postBodys) {(member) in
                self.memberToken = member
                print(member?.status)
                
                UserDefaults.standard.set("true", forKey: "registerFinished")
                self.resetUserDefault()

                if member?.status == "success"{
                    
                    self.status = true
                  
                }else{
                    self.status = false
                }
                
                if self.status == true{
                    
                    
                    let button2Alert: UIAlertView = UIAlertView(title: "Sign Up Successful", message: "Please log in",delegate: nil, cancelButtonTitle: "OK")
                    
                    button2Alert.show()
                    
                }else if self.status == false{
                    
                    let button2Alert: UIAlertView = UIAlertView(title: "Sorry", message: member?.message?.description,delegate: nil, cancelButtonTitle: "OK")
                    button2Alert.show()
                }else{
                    print("status is nil")
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
    func resetUserDefault(){
        self.PreferenceLabel.text = nil
        self.StateLable.text = nil
        UserDefaults.standard.set(nil, forKey: "userNameBoxXia")
        UserDefaults.standard.set("", forKey: "firstNameBoxXia")
        UserDefaults.standard.set("", forKey: "lastNameBoxXia")
        UserDefaults.standard.set("", forKey: "emailBoxXia")
        UserDefaults.standard.set("", forKey: "passwordBoxXia")
        UserDefaults.standard.set("", forKey: "confirmPasswordboxXia")
        UserDefaults.standard.set("", forKey: "postCodeBoxXia")
        UserDefaults.standard.set("Where did you hear about On The House", forKey: "preference")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print(self.StateLable.text)
        
        UserNameBox.placeholder="USER NAME"
        FirstNameBox.placeholder="FIRST NAME"
        LastNameBox.placeholder="LAST NAME"
        EmailBox.placeholder="EMAIL ADRESS"
        PasswordBox.placeholder="PASSWORD"
        ConfirmPasswordBox.placeholder="CONFIRM PASSWORD"
        PostCodeBox.placeholder="POST CODE"
        
        UserNameBox.addTarget(self, action: #selector(self.UserNameBoxDidChange(_:)), for: UIControlEvents.editingChanged)
        
        FirstNameBox.addTarget(self, action: #selector(self.FirstNameBoxDidChange(_:)), for: UIControlEvents.editingChanged)
        
        LastNameBox.addTarget(self, action: #selector(self.LastNameBoxDidChange(_:)), for: UIControlEvents.editingChanged)
        
        EmailBox.addTarget(self, action: #selector(self.EmailBoxDidChange(_:)), for: UIControlEvents.editingChanged)
        
        PasswordBox.addTarget(self, action: #selector(self.PasswordBoxDidChange(_:)), for: UIControlEvents.editingChanged)
        
        ConfirmPasswordBox.addTarget(self, action: #selector(self.ConfirmPasswordBoxDidChange(_:)), for: UIControlEvents.editingChanged)
        
        PostCodeBox.addTarget(self, action: #selector(self.PostCodeBoxDidChange(_:)), for: UIControlEvents.editingChanged)
        
        if(UserDefaults.standard.string(forKey: "registerFinished") == "false"){
            UserNameBox.text = UserDefaults.standard.string(forKey: "userNameBoxXia")
            FirstNameBox.text = UserDefaults.standard.string(forKey: "firstNameBoxXia")
            LastNameBox.text = UserDefaults.standard.string(forKey: "lastNameBoxXia")
            EmailBox.text = UserDefaults.standard.string(forKey: "emailBoxXia")
            PasswordBox.text = UserDefaults.standard.string(forKey: "passwordBoxXia")
            ConfirmPasswordBox.text = UserDefaults.standard.string(forKey: "confirmPasswordboxXia")
            PostCodeBox.text = UserDefaults.standard.string(forKey: "postCodeBoxXia")
            PreferenceLabel.text = UserDefaults.standard.string(forKey: "preference")
        }else{
            UserNameBox.placeholder = "USER NAME"
            FirstNameBox.placeholder="FIRST NAME"
            LastNameBox.placeholder="LAST NAME"
            EmailBox.placeholder="EMAIL ADRESS"
            PasswordBox.placeholder="PASSWORD"
            ConfirmPasswordBox.placeholder="CONFIRM PASSWORD"
            PostCodeBox.placeholder="POST CODE"
            PreferenceLabel.text = "Where did you hear about On The House"
        }
        
        
        
        if (UserDefaults.standard.string(forKey: "preference") != ""){
            
            PreferenceLabel.text = UserDefaults.standard.string(forKey: "preference")
        }
        
        
    }
    
    
}

