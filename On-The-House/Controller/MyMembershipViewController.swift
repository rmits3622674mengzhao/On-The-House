//
//  MyMembershipViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 26/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyMembershipViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PayPalPaymentDelegate {
    @IBOutlet weak var upgradeMembershipBtn: UIButton!
    @IBOutlet weak var tableViewMembershipHistory: UITableView!
    var memberID:String?
    var membershipHistory :[[String: Any]] = [[:]]
    @IBOutlet weak var lbUserFullname: UILabel!
    @IBOutlet weak var lbCurrentMembership: UILabel!
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    var payPalConfig = PayPalConfiguration() // default
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMembershipStatus()
        tableViewMembershipHistory.dataSource = self
        tableViewMembershipHistory.delegate = self
        self.memberID = UserDefaults.standard.string(forKey: "member_id")!
        lbCurrentMembership.text = UserDefaults.standard.string(forKey:"membership_level_name")! + " Member"
        lbUserFullname.text = UserDefaults.standard.string(forKey:"first_name")! + " " + UserDefaults.standard.string(forKey:"last_name")!
        loadMembershipHistory()
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "On The House, Inc."
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        // Setting the languageOrLocale property is optional.
        //
        // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
        // its user interface according to the device's current language setting.
        //
        // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
        // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
        // to use that language/locale.
        //
        // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
        
        payPalConfig.payPalShippingAddressOption = .payPal;
        
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    func loadMembershipHistory(){
        let postBodys = "member_id=\(memberID!)"
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/membership/history"){
            let network = NetworkProcessor(url: memberURL)
            network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        self.membershipHistory = (jsonDictionary?["memberships"] as? [[String: Any]])!
                        DispatchQueue.main.async{
                            self.tableViewMembershipHistory.reloadData()
                        }
                    }else if status == "error"{
                        print("fail to load json")
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.membershipHistory.count)
        return self.membershipHistory.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Membership History"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewMembershipHistory.dataSource = self
        let cell = tableViewMembershipHistory.dequeueReusableCell(withIdentifier: "myMemHis", for: indexPath) as! MyMembershipHistoryTableViewCell
        cell.lbMembershipName.text = membershipHistory[indexPath.row]["membership_level_name"] as? String
        //convert date format
        let startDateAsString = membershipHistory[indexPath.row]["date_created"] as? String
        let endDateAsString = membershipHistory[indexPath.row]["date_expires"] as? String
        if let startDateAsDouble = startDateAsString?.toDouble(), let endDateAsDouble = endDateAsString?.toDouble(){
            let startDate:String = DateFormat.getFormattedDate(dateToConvert: startDateAsDouble, format: "dd/MM/YYYY")
            let endDate:String = DateFormat.getFormattedDate(dateToConvert: endDateAsDouble, format: "dd/MM/YYYY")
            cell.lbDuration.text = startDate + " - " + endDate
        }
        return cell
    }
    @IBAction func UpgradeMembershipAction(_ sender: UIButton) {
        let payment = PayPalPayment(amount: 0.1, currencyCode: "AUD", shortDescription: "Upgrade to gold membership", intent: .sale)
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            //update user membership in app and in the UI
            UserDefaults.standard.set("9", forKey: "membership_level_id")
            UserDefaults.standard.set("Gold", forKey: "membership_level_name")
            self.upgradeMembershipBtn.isHidden = true
            self.lbCurrentMembership.text = UserDefaults.standard.string(forKey:"membership_level_name")! + " Member"
            //send upgrade information to server
            self.sendUpgradeInformation()
        })
    }
    
    func sendUpgradeInformation(){
        let memberID = UserDefaults.standard.string(forKey: "member_id")
        let memberShipLevelID = "9"  //gold membership level id is 9
        let postBodys = "member_id=\(memberID!)&membership_level_id=\(memberShipLevelID)"
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/membership/update"){
            let network = NetworkProcessor(url: memberURL)
            network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        print("Successfull Upgrade your membership!")
                    }else if status == "error"{
                        print("fail to send confirmation information")
                    }
                }
            }
        }
    }
    
    //If membership is gold then upgrade button will be hidden
    func checkMembershipStatus(){
        if (UserDefaults.standard.string(forKey: "membership_level_id")! == "9"){
            upgradeMembershipBtn.isHidden = true
        }
    }
}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

