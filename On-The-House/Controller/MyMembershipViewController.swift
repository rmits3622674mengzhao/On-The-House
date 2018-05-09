//
//  MyMembershipViewController.swift
//  On-The-House
//
//  Created by Kay Hoang on 26/4/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyMembershipViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableViewMembershipHistory: UITableView!
    var membership :[String: Any]?
    var membershipHistory :[[String: Any]]?
    var userFullName:String?
    var memberID = ""
    @IBOutlet weak var lbUserFullname: UILabel!
    @IBOutlet weak var lbCurrentMembership: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let member_id = UserDefaults.standard.string(forKey: "member_id")
        {
            self.memberID = member_id
            print(self.memberID)
        }
        lbCurrentMembership.text = UserDefaults.standard.string(forKey:"membership_level_name")! + " Member"
        lbUserFullname.text = userFullName
        
        tableViewMembershipHistory.dataSource = self
        tableViewMembershipHistory.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.membershipHistory!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Membership History"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableViewMembershipHistory.dataSource = self
        let cell = tableViewMembershipHistory.dequeueReusableCell(withIdentifier: "myMemHis", for: indexPath) as! MyMembershipHistoryTableViewCell
        cell.lbMembershipName.text = membershipHistory![indexPath.row]["membership_level_name"] as? String
        //convert date format
        let startDateAsString = membershipHistory![indexPath.row]["date_created"] as! String
        let endDateAsString = membershipHistory![indexPath.row]["date_expires"] as! String
        if let startDateAsDouble = Double(startDateAsString), let endDateAsDouble = Double(endDateAsString){
            let startDate:String = DateFormat.getFormattedDate(dateToConvert: startDateAsDouble, format: "dd/MM/YYYY")
            let endDate:String = DateFormat.getFormattedDate(dateToConvert: endDateAsDouble, format: "dd/MM/YYYY")
            cell.lbDuration.text = startDate + " - " + endDate
        }
        
        //let endDate:String = DateFormat.getFormattedDate(dateToConvert: membershipHistory![indexPath.row]["date_expires"].doubleValue, format: "dd/MM/YYYY")
        
        
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        loadReservation()
    }
    
    func loadReservation(){
        //load current user's membership
        let postBodys = "member_id=\(self.memberID)"
        if let memberURL = URL(string: "http://ma.on-the-house.org/api/v1/member/membership"){
            let network = NetworkProcessor(url: memberURL)
            network.PostJSONFromURL(postString: postBodys) { (jsonDictionary) in
                if let status = jsonDictionary?["status"] as? String{
                    if status == "success"{
                        self.membership = (jsonDictionary?["membership"] as? [String: Any])!
                        UserDefaults.standard.set(self.membership!["membership_level_name"], forKey: "membership_level_name")
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

