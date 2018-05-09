//
//  UpdateProfileTableViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 4/5/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class UpdateUserProfileTableViewController: UITableViewController {
    @IBOutlet weak var tfNickName: UITextField!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var lbAge: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfAddress1: UITextField!
    @IBOutlet weak var tfAddress2: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var tfPostcode: UITextField!
    @IBOutlet weak var lbTimeZone: UILabel!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var switchNewsletters: UISwitch!
    @IBOutlet weak var lbNewsletters: UILabel!
    @IBOutlet weak var switchFocusGroup: UISwitch!
    @IBOutlet weak var lbFocusGroup: UILabel!
    @IBOutlet weak var switchPaidMarketing: UISwitch!
    @IBOutlet weak var lbPaidMarketing: UILabel!
    
    var memberToken:Member?
    var selectedCategories: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfNickName.text = UserDefaults.standard.string(forKey: "nickname")
        if (UserDefaults.standard.string(forKey: "title") != ""){
            lbTitle.text = UserDefaults.standard.string(forKey: "title")
        }
        tfFirstName.text = UserDefaults.standard.string(forKey: "first_name")
        tfLastName.text = UserDefaults.standard.string(forKey: "last_name")
        tfEmail.text = UserDefaults.standard.string(forKey: "email")
        tfAddress1.text = UserDefaults.standard.string(forKey: "address1")
        tfAddress2.text = UserDefaults.standard.string(forKey: "address2")
        tfCity.text = UserDefaults.standard.string(forKey: "city")
        tfPostcode.text = UserDefaults.standard.string(forKey: "zip")
        if (UserDefaults.standard.string(forKey: "age") != ""){
            lbAge.text = UserDefaults.standard.string(forKey: "age")
        }
        tfPhoneNumber.text = UserDefaults.standard.string(forKey: "phone")
        
        //transfer zone_id to string
        let zone_id = UserDefaults.standard.string(forKey: "zone_id")
        if(zone_id != ""){
            let Tstate = DataTransition.getKey(id: Int(zone_id!)!, dictionaries: DataTransition.states)
            lbState.text = Tstate
        }
        
        //transfer timezone_id to string
        let timezone_id = UserDefaults.standard.string(forKey: "timezone_id")
        if (timezone_id != ""){
            let Ttimezone = DataTransition.getKey(id: Int(timezone_id!)!, dictionaries: DataTransition.timezones)
            lbTimeZone.text = Ttimezone
        }
        
        lbFocusGroup.text = "Are you interested in participating in focus groups?"
        if (UserDefaults.standard.string(forKey: "focus_groups") == "1"){
            switchFocusGroup.isOn = true
        }else{
            switchFocusGroup.isOn = false
        }
        
        lbPaidMarketing.text = "Are you interested in paid marketing work?                         "
        if (UserDefaults.standard.string(forKey: "paid_marketing") == "1"){
            switchPaidMarketing.isOn = true
        }else{
            switchPaidMarketing.isOn = false
        }
        
        lbNewsletters.text = "Subscribe for emails and periodicals                                 "
        if (UserDefaults.standard.string(forKey: "newsletters") == "1"){
            switchNewsletters.isOn = true
        }else{
            switchNewsletters.isOn = false
        }
        //print selected categories to UI label
        var selectedCategoriesKeysArray: [String] = []
        selectedCategories = UserDefaults.standard.array(forKey: "categories") as? [Int]
        if (selectedCategories != nil){
            for category in selectedCategories!{
                selectedCategoriesKeysArray.append(DataTransition.getKey(id: category, dictionaries: DataTransition.categories))
            }
            lbCategories.text = selectedCategoriesKeysArray.joined(separator: ",")
        }else{
            
        }
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        if(validation()){
            self.postUpdatedProfile()
        }
    }
    func postUpdatedProfile(){
        let stateID = DataTransition.states[lbState.text!]
        let timezoneID = DataTransition.timezones[lbTimeZone.text!]
        //focus group
        var focus_Group: String?
        if(switchFocusGroup.isOn){
            focus_Group = "1"
        }else{
            focus_Group = "0"
        }
        //paid marketing
        var paid_Marketing: String?
        if(switchPaidMarketing.isOn){
            paid_Marketing = "1"
        }else{
            paid_Marketing = "0"
        }
        //newsletters
        var news_Letters: String?
        if(switchNewsletters.isOn){
            news_Letters = "1"
        }else{
            news_Letters = "0"
        }
        
        if let nickName = tfNickName.text, let title = lbTitle.text, let firstName = tfFirstName.text, let lastName = tfLastName.text, let age = lbAge.text, let email = tfEmail.text, let phone = tfPhoneNumber.text, let address1 = tfAddress1.text, let address2 = tfAddress2.text, let city = tfCity.text, let zoneID = stateID, let zip = tfPostcode.text, let timeZone_id = timezoneID, let focusGroup = focus_Group, let paidMarketing = paid_Marketing, let newsLetters = news_Letters, let categories = selectedCategories, let member_id = UserDefaults.standard.string(forKey: "member_id"){
            print(categories)
            let parameter1 :[String: Any] = ["nickname": nickName,
                                             "title": title,
                                             "first_name": firstName,
                                             "last_name": lastName,
                                             "age": age,
                                             "email": email,
                                             "phone": phone,
                                             "address1": address1,
                                             "address2": address2,
                                             "city": city,
                                             "zone_id": zoneID,
                                             "zip": zip,
                                             "country_id": "13",
                                             "timezone_id": timeZone_id,
                                             "newsletters": newsLetters,
                                             "focus_groups": focusGroup,
                                             "paid_marketing": paidMarketing,
                                             "categories":categories]
            
            NetworkProcessor.post(command: "api/v1/member/\(member_id)", parameter: parameter1, compeletion: { (member) in
                self.memberToken = member
                if member?.status == "success"{
                    print("successfully updated profile")
                    UserDefaults.standard.set(self.memberToken?.nickname, forKey: "nickname")
                    UserDefaults.standard.set(self.memberToken?.title, forKey: "title")
                    UserDefaults.standard.set(self.memberToken?.first_name, forKey: "first_name")
                    UserDefaults.standard.set(self.memberToken?.last_name, forKey: "last_name")
                    UserDefaults.standard.set(self.memberToken?.age, forKey: "age")
                    UserDefaults.standard.set(self.memberToken?.email, forKey: "email")
                    UserDefaults.standard.set(self.memberToken?.phone, forKey: "phone")
                    UserDefaults.standard.set(self.memberToken?.address1, forKey: "address1")
                    UserDefaults.standard.set(self.memberToken?.address2, forKey: "address2")
                    UserDefaults.standard.set(self.memberToken?.city, forKey: "city")
                    UserDefaults.standard.set(self.memberToken?.zone_id, forKey: "zone_id")
                    UserDefaults.standard.set(self.memberToken?.zip, forKey: "zip")
                    UserDefaults.standard.set(self.memberToken?.timezone_id, forKey: "timezone_id")
                    UserDefaults.standard.set(self.memberToken?.country_id, forKey: "country_id")
                    UserDefaults.standard.set(focusGroup, forKey: "focus_groups")
                    UserDefaults.standard.set(paidMarketing, forKey: "paid_marketing")
                    UserDefaults.standard.set(newsLetters, forKey: "newsletters")
                    UserDefaults.standard.set(self.selectedCategories, forKey: "categories")
                    //show successfull message
                    let successfullyMsg = UIAlertController(title: "Success", message: "Your profile is updated successfully!", preferredStyle: .alert)
                    successfullyMsg.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(successfullyMsg, animated: true, completion: nil)
                }else{
                    print("Fail to load json")
                }
            })
        }
    }
    func showAlert(msgMessage:String){
        let alert = UIAlertController(title: "Error", message: msgMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func validation() -> Bool{
        var msgMessage = ""
        if(isValidEmail(testStr:tfEmail.text!) == false || tfEmail.text == ""){
            msgMessage = "Invalid Email address!"
            self.showAlert(msgMessage: msgMessage)
            return false
        }else if(tfNickName.text == ""){
            msgMessage = "Please enter your nickname!"
            self.showAlert(msgMessage: msgMessage)
            return false
        }else if(tfFirstName.text == ""){
            msgMessage = "Please enter your first name!"
            self.showAlert(msgMessage: msgMessage)
            return false
        }else if(tfLastName.text == ""){
            msgMessage = "Please enter your last name!"
            self.showAlert(msgMessage: msgMessage)
            return false
        }else if(tfLastName.text == ""){
            msgMessage = "Please enter your last name!"
            self.showAlert(msgMessage: msgMessage)
            return false
        }else if(tfAddress1.text == ""){
            msgMessage = "Please enter your address!"
            self.showAlert(msgMessage: msgMessage)
            return false
        }else if(tfCity.text == ""){
            msgMessage = "Please enter your city!"
            self.showAlert(msgMessage: msgMessage)
            return false
        }else if(tfPostcode.text == ""){
            msgMessage = "Please enter your poscode!"
            self.showAlert(msgMessage: msgMessage)
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
