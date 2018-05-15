//
//  SignInPageController.swift
//  On-The-House
//
//  Created by beier nie on 21/3/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
import UIKit


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
    
    
    var pickerData: [String] = [String]()
    let statechoices = ["New South Wales", "Queensland", "South Australia", "Tasmania", "Victoria", "Western Australia", "Australian Capital Territory"]
    let referencechoices = ["Friend","Twitter","Facebook","Forum","Website"]
    
    
    var memberToken:Member?
    
    var status:Bool?;
    
    func createApiCall(){
        if let usernameT = UserNameBox.text, let firstNameT = FirstNameBox.text, let lastNameT = LastNameBox.text,let emailT = EmailBox.text, let passwordT = PasswordBox.text,  let passwordconfirmT = ConfirmPasswordBox.text,let _ = PostCodeBox.text{
            let postBodys = "nickname=\(usernameT)&first_name=\(firstNameT)&last_name=\(lastNameT)&email=\(emailT)&password=\(passwordT)&password_confirm=\(passwordconfirmT)&terms=1&zone_id=211&country_id=13&timezone_id=108&zip=10001"
            //let postBody = "email=nazisang@gmail.com&password=summer1993"
            
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
        if let usernameT = UserNameBox.text, let firstNameT = FirstNameBox.text, let lastNameT = LastNameBox.text,let emailT = EmailBox.text, let passwordT = PasswordBox.text,  let passwordconfirmT = ConfirmPasswordBox.text,let _ = PostCodeBox.text{
            let postBodys = "nickname=\(usernameT)&first_name=\(firstNameT)&last_name=\(lastNameT)&email=\(emailT)&password=\(passwordT)&password_confirm=\(passwordconfirmT)&terms=1&zone_id=211&country_id=13&timezone_id=108&zip=10001"
            //let postBody = "email=nazisang@gmail.com&password=summer1993"
            
            let memberService = MemberService()
            memberService.createMember(member: postBodys) {(member) in
                print("in")
                self.memberToken = member
                print(member?.status)
                if member?.status == "success"{
                    self.status = true
                }else{
                    self.status = false
                }
                if self.status == true{
                    //UIAlertController.addAction(UIAlertControllerStyle.alert)
                    if let id = member?.id{
                        
                        let button2Alert: UIAlertView = UIAlertView(title: "success", message: "\(id),Welcome to oth",delegate: nil, cancelButtonTitle: "OK")
                        
                        button2Alert.show()
                    }
                }else if self.status == false{
                    let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
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



